#!/usr/bin/perl -w

use blib '../../G';
use blib '..';
use lib '..';

use Gtk2;
use Data::Dumper;

Gtk2->init;

my $str = 'aaa0';


my $window = Gtk2::Window->new ('toplevel');
$window->signal_connect (delete_event => sub { Gtk2->main_quit; 1 });
$window->set_title ('Timeout Test');
$window->set_border_width (6);
$window->set_default_size (200, 200);

my $vbox = Gtk2::VBox->new (0,0);
$window->add ($vbox);

my $label = Gtk2::Label->new ($str);
$vbox->pack_start ($label, 1, 1, 0);

my $button = Gtk2::ToggleButton->new ('Go');
$vbox->pack_start ($button, 0, 0, 6);
$button->signal_connect (toggled => sub {
		if ($_[0]->get_active) {
			$_[0]->child->set_text ('Stop');
		} else {
			$_[0]->child->set_text ('Go');
		}
		});

#
# here's a timeout that is always running, but only does something if
# $button is toggled on.
#
# the real way...
#my $id = G::Timeout->add (100, sub {
# the Gtk2 wrapper
my $id = Gtk2->timeout_add (100, sub {
#			warn Dumper(\@_);
			#if ($button->get_active) {
			if ($_[0][1]->get_active) {
				$str++;
				#$label->set_text ($str);
				$_[0][0]->set_text ($str);
			}
			1;
		}, [$label, $button]);


#
# now let's test timeouts that uninstall themselves.
# we'll have a 'sticky' toggle button -- it turns itself off after a delay
# (much like the cruise control in the car i got from my sister, where she'd
# spilled so much soda on the switch that it was all gummy and took a while
# to pop out).
#
# if the user clicks again before it has a chance to run, we'll uninstall
# it by the id.
#
my $button2 = Gtk2::ToggleButton->new ('click me');
$vbox->pack_start ($button2, 0, 0, 5);
my $id2 = undef;
$button2->signal_connect (toggled => sub {
		if (!$_[0]->get_active) {
			# user turned us off before the callback ran
			warn "uninstalling $id2";
			###Gtk2->timeout_remove ($id2);
			G::Source->remove ($id2);
			$id2 = undef;
		} else {
			###$id2 = Gtk2->timeout_add (1000, sub {
			$id2 = G::Timeout->add (1000, sub {
				warn "callback, $_[0]";
				#$_[0]->toggle;
				$_[0]->set_active (0);
				0;	# don't run again
				}, $_[0]);
		}
	});


$window->show_all;
Gtk2->main;
