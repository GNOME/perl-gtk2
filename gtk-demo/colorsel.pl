#!/usr/bin/perl -w
#
# Color Selector
#
# GtkColorSelection lets the user choose a color. GtkColorSelectionDialog is
# a prebuilt dialog containing a GtkColorSelection.
#
#

use blib '..';
use blib '../..';
use blib '../../G';

use constant FALSE => 0;
use constant TRUE => 1;

use Gtk2;

my $window = undef;
my $da;
my $color;

sub change_color_callback {
  my $button = shift;
  
  my $dialog = Gtk2::ColorSelectionDialog->new ("Changing color");

  $dialog->set_transient_for ($window);
  
  my $colorsel = $dialog->colorsel;

  $colorsel->set_previous_color ($color);
  $colorsel->set_current_color ($color);
  $colorsel->set_has_palette (TRUE);
  
  my $response = $dialog->run;

  if ($response eq 'ok') {
      $color = $colorsel->get_current_color;

      $da->modify_bg ('normal', $color);
  }
  
  $dialog->destroy;
}

sub do_colorsel {
  if (!$window) {
      $color = Gtk2::Gdk::Color->new (0, 65535, 0);
      
      $window = Gtk2::Window->new;
      $window->set_title ("Color Selection");

      $window->signal_connect (destroy => sub { $window = undef });

      $window->set_border_width (8);

      my $vbox = Gtk2::VBox->new (FALSE, 8);
      $vbox->set_border_width (8);
      $window->add ($vbox);

      #
      # Create the color swatch area
      #
      
      my $frame = Gtk2::Frame->new;
      $frame->set_shadow_type ('in');
      $vbox->pack_start ($frame, TRUE, TRUE, 0);
      
      $da = Gtk2::DrawingArea->new;
      # set a minimum size
      $da->set_size_request (200, 200);
      # set the color
      $da->modify_bg ('normal', $color);
      
      $frame->add ($da);

      my $alignment = Gtk2::Alignment->new (1.0, 0.5, 0.0, 0.0);
      
      my $button = Gtk2::Button->new_with_mnemonic ("_Change the above color");
      $alignment->add ($button);
      
      $vbox->pack_start ($alignment, FALSE, FALSE, 0);
      
      $button->signal_connect (clicked => \&change_color_callback);
  }

  if (!$window->visible) {
      $window->show_all;
  } else {
      $window->destroy;
      $window = undef;
  }

  return $window;
}


Gtk2->init;
do_colorsel;
Gtk2->main;
