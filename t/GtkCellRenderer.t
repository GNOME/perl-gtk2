#!/usr/bin/perl -w

# $Id$

use Gtk2::TestHelper tests => 13;
use strict;

package Mup::CellRendererPopup;

use Test::More;

use Glib::Object::Subclass
	Gtk2::CellRendererText::,
	;

my %hits;

sub INIT_INSTANCE { $hits{init}++; }

sub GET_SIZE { $hits{size}++;  shift->SUPER::GET_SIZE (@_) }
sub RENDER { $hits{render}++;  shift->SUPER::RENDER (@_) }
sub ACTIVATE { $hits{activate}++;  shift->SUPER::ACTIVATE (@_) }
sub START_EDITING { $hits{edit}++;  shift->SUPER::START_EDITING (@_) }


# do that again, in the style of 1.02x, to check for regressions of
# backward compatibility.
package Mup::CellRendererPopupCompat;

use Test::More;

use Glib::Object::Subclass
	Gtk2::CellRendererText::,
	;

__PACKAGE__->_install_overrides;

my %hits_compat;

sub INIT_INSTANCE { $hits_compat{init}++; }

sub on_get_size { $hits_compat{size}++;  shift->parent_get_size (@_) }
sub on_render { $hits_compat{render}++;  shift->parent_render (@_) }
sub on_activate { $hits_compat{activate}++;  shift->parent_activate (@_) }
sub on_start_editing { $hits_compat{edit}++;  shift->parent_start_editing (@_) }

##########################################################################
# driver code
package main;

my $window = Gtk2::Window->new;
$window->set_title ('cell renderer test');
$window->signal_connect (delete_event => sub { Gtk2->main_quit; 0; });

my $vbox = Gtk2::VBox->new;
$window->add ($vbox);

my $label = Gtk2::Label->new;
$label->set_markup ('<big>F-Words</big>');
$vbox->pack_start ($label, 0, 0, 0);

# create and load the model
my $model = Gtk2::ListStore->new ('Glib::String', 'Glib::Scalar', 'Glib::Int');
foreach (qw/foo fluffy flurble frob frobnitz ftang fire truck/) {
	my $iter = $model->append;
	$model->set ($iter, 0, $_);
}


# now a view
my $treeview = Gtk2::TreeView->new ($model);

#
# custom cell renderer
#
ok (my $renderer = Mup::CellRendererPopup->new, 'Mup::CellRendererPopup->new');
$renderer->set (mode => 'editable');
my $column = Gtk2::TreeViewColumn->new_with_attributes ('selector', $renderer,
                                                     text => 0,);
# this handler commits the user's selection to the model.  compare with
# the one for the typical text renderer -- the only difference is a var name.
$renderer->signal_connect (edited => sub {
		my ($cell, $text_path, $new_text, $model) = @_;
		my $path = Gtk2::TreePath->new_from_string ($text_path);
		my $iter = $model->get_iter ($path);
		$model->set ($iter, 2, $new_text);
	}, $model);
$treeview->append_column ($column);


#
# custom cell renderer
#
ok ($renderer = Mup::CellRendererPopupCompat->new, 'Mup::CellRendererPopupCompat->new');
$renderer->set (mode => 'editable');
$renderer->set (editable => 1);
my $column_compat = Gtk2::TreeViewColumn->new_with_attributes ('selector', $renderer,
                                                     text => 0,);
# this handler commits the user's selection to the model.  compare with
# the one for the typical text renderer -- the only difference is a var name.
$renderer->signal_connect (edited => sub {
		my ($cell, $text_path, $new_text, $model) = @_;
		my $path = Gtk2::TreePath->new_from_string ($text_path);
		my $iter = $model->get_iter ($path);
		$model->set ($iter, 2, $new_text);
	}, $model);
$treeview->append_column ($column_compat);

##########################################################################

$vbox->pack_start ($treeview, 1, 1, 0);

$window->show_all;

##########################################################################

isa_ok ($renderer, "Gtk2::CellRenderer");

my $rect = Gtk2::Gdk::Rectangle->new (5, 5, 10, 10);
my @size = $renderer->get_size ($treeview, $rect);
is (@size, 4);
like($size[0], qr/^\d+$/);
like($size[1], qr/^\d+$/);
like($size[2], qr/^\d+$/);
like($size[3], qr/^\d+$/);

my $event = Gtk2::Gdk::Event->new ("button-press");

$renderer->render ($window->window, $treeview, $rect, $rect, $rect, [qw(sorted prelit)]);
ok(!$renderer->activate ($event, $treeview, "0", $rect, $rect, qw(selected)));
isa_ok ($renderer->start_editing ($event, $treeview, "0", $rect, $rect, qw(selected)), "Gtk2::Entry");

$renderer->set_fixed_size (23, 42);
is_deeply([$renderer->get_fixed_size], [23, 42]);

SKIP: {
	skip "editing_canceled is new in 2.4", 0
		unless Gtk2->CHECK_VERSION (2, 4, 0);

	$renderer->editing_canceled;
}

SKIP: {
	skip "stop_editing is new in 2.6", 0
		unless Gtk2->CHECK_VERSION (2, 6, 0);

	$renderer->stop_editing (FALSE);
}

##########################################################################

run_main sub {
	$treeview->set_cursor (Gtk2::TreePath->new_from_string ('0'),
	                       $column, 1);
	$treeview->set_cursor (Gtk2::TreePath->new_from_string ('0'),
	                       $column_compat, 1);
};


is_deeply ([ sort keys %hits ], [ qw/edit init render size/ ], 'callbacks encountered');
is_deeply ([ sort keys %hits_compat ], [ qw/edit init render size/ ], 'callbacks encountered');

__END__

Copyright (C) 2003-2005 by the gtk2-perl team (see the file AUTHORS for the
full list).  See LICENSE for more information.
