#!/usr/bin/perl -w
use strict;
use Gtk2::TestHelper
  tests => 1,
  at_least_version => [2, 12, 0, "GtkTooltip appeared in 2.12"];

# $Id$

my $window = Gtk2::Window->new;
$window->set (tooltip_markup => "<b>Bla!</b>");

$window->signal_connect (query_tooltip => sub {
  my ($window, $x, $y, $keyboard_mode, $tip) = @_;

  isa_ok ($tip, "Gtk2::Tooltip");

  $tip->set_markup ("<b>Alb!</b>");
  $tip->set_markup (undef);

  $tip->set_text ('Alb!');
  $tip->set_text (undef);

  $tip->set_icon (Gtk2::Gdk::Pixbuf->new ("rgb", TRUE, 8, 12, 12));
  $tip->set_icon (undef);

  $tip->set_icon_from_stock ("gtk-open", "button");
  $tip->set_icon_from_stock (undef, "menu");

  $tip->set_custom (Gtk2::Button->new ("Bla!"));
  $tip->set_custom (undef);

  $tip->set_tip_area (Gtk2::Gdk::Rectangle->new (0, 0, 10, 10));
  $tip->set_tip_area (undef);

  Glib::Idle->add (sub { Gtk2->main_quit; });

  return TRUE;
});

$window->realize;

my $event = Gtk2::Gdk::Event->new ('motion-notify');
$event->window ($window->window);
Gtk2->main_do_event ($event);
Gtk2->main_do_event ($event);

Gtk2->main;

Gtk2::Tooltip::trigger_tooltip_query (Gtk2::Gdk::Display->get_default);

__END__

Copyright (C) 2007 by the gtk2-perl team (see the file AUTHORS for the
full list).  See LICENSE for more information.
