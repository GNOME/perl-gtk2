#!/usr/bin/perl -w 

#
# $Header$
#
# r.m.
# 

use strict;
use Gtk2 '-init';
use Gtk2::SimpleMenu;
use Data::Dumper;

sub callback
{
	print "Callback:\n";
	print Dumper(@_);
}

sub default_callback
{
	print "Default Callback:\n";
	print Dumper(@_);
}

my $action = 0;
my $menu_tree = [
	_File  => {
		item_type  => '<Branch>',
		children => [
			_New       => {
				callback => \&callback,
				callback_action => $action++,
				accelerator => '<ctrl>N',
			},
			_Save      => {
				callback_action => $action++,
				accelerator => '<ctrl>S',
			},
			'Save _As' => {
				callback => \&callback,
				callback_action => $action++,
				accelerator => '<ctrl>A',
			},
			_Exit      => {
				callback => sub { Gtk2->main_quit; },
				callback_action => $action++,
				accelerator => '<ctrl>E',
			},
		],
	},
	_Edit  => {
		item_type => '<Branch>',
		children => [
			_Copy  => {
				callback => \&callback,
				callback_action => $action++,
			},
			_Paste => {
				callback_action => $action++,
			},
		],
	},
	_Tools => {
		item_type => '<Branch>',
		children => [
			_Tearoff => {
				item_type => '<Tearoff>',
			},
			_CheckItem => {
				callback => \&callback,
				callback_action => $action++,
				item_type => '<CheckItem>',
			},
			_ToggleItem => {
				callback_action => $action++,
				item_type => '<ToggleItem>',
			},
			_StockItem => {
				callback => \&callback,
				callback_action => $action++,
				item_type => '<StockItem>',
				extra_data => 'gtk-execute',
			},
			_Radios => {
				item_type => '<Branch>',
				children => [
					'Radio _1' => {
						callback => \&callback,
						callback_action => $action++,
						item_type  => '<RadioItem>',
						groupid => 1,
					},
					'Radio _2' => {
						callback => \&callback,
						callback_action => $action++,
						item_type  => '<RadioItem>',
						groupid => 1,
					},
					'Radio _3' => {
						callback => \&callback,
						callback_action => $action++,
						item_type  => '<RadioItem>',
						groupid => 1,
					},
				],
			},
			Separator => {
				item_type => '<Separator>',
			},
#			image menu item types are not supported at this point
#			_Image => {
#				callback => \&callback,
#				callback_action => $action++,
#				item_type => '<ImageItem>',
#			},
		],
	},
	_Help  => {
		item_type => '<Branch>',
		children => [
			_Introduction => {
				callback => \&callback,
				callback_action => $action++,
			},
			_About        => {
				callback_action => $action++,
			}
		],
	},
];

my $menu = Gtk2::SimpleMenu->new(
				menu_tree        => $menu_tree,
				default_callback => \&default_callback,
				user_data        => 'user data',
			);

$menu->get_widget('/Tools/Radios/Radio 2')->set_active(1);

my $win = Gtk2::Window->new;
$win->add($menu->{widget});
$win->add_accel_group($menu->{accel_group});
$win->show_all;
Gtk2->main;

