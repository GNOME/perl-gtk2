#!/usr/bin/perl -w
#
# Button Boxes
#
# The Button Box widgets are used to arrange buttons with padding.
#

use blib '..';
use blib '../..';
use blib '../../G';

use constant FALSE => 0;
use constant TRUE => 1;

use Gtk2;

sub create_bbox {
  my ($horizontal, $spacing, $layout) = @_;

  my $title = ucfirst $layout;

  my $frame = Gtk2::Frame->new ($title);

  my $bbox = $horizontal
           ? Gtk2::HButtonBox->new
	   : Gtk2::VButtonBox->new;

  $bbox->set_border_width (5);
  $frame->add ($bbox);

  $bbox->set_layout ($layout);
  $bbox->set_spacing ($spacing);
  
  my $button = Gtk2::Button->new_from_stock ('gtk-ok');
  $bbox->add ($button);
  
  $button = Gtk2::Button->new_from_stock ('gtk-cancel');
  $bbox->add ($button);
  
  $button = Gtk2::Button->new_from_stock ('gtk-help');
  $bbox->add ($button);

  return $frame;
}

my $window = undef;

sub do_button_box {
  if (!$window) {
    $window = Gtk2::Window->new;
    $window->set_title ("Button Boxes");
    
    $window->signal_connect (destroy => sub { $window = undef; 1 });
    
    $window->set_border_width (10);

    my $main_vbox = Gtk2::VBox->new (FALSE, 0);
    $window->add ($main_vbox);
    
    my $frame_horz = Gtk2::Frame->new ("Horizontal Button Boxes");
    $main_vbox->pack_start ($frame_horz, TRUE, TRUE, 10);
    
    my $vbox = Gtk2::VBox->new (FALSE, 0);
    $vbox->set_border_width (10);
    $frame_horz->add ($vbox);

    $vbox->pack_start (create_bbox (TRUE, 40, 'spread'), TRUE, TRUE, 0);
    $vbox->pack_start (create_bbox (TRUE, 40, 'edge'),   TRUE, TRUE, 5);
    $vbox->pack_start (create_bbox (TRUE, 40, 'start'),  TRUE, TRUE, 5);
    $vbox->pack_start (create_bbox (TRUE, 40, 'end'),    TRUE, TRUE, 5);

    my $frame_vert = Gtk2::Frame->new ("Vertical Button Boxes");
    $main_vbox->pack_start ($frame_vert, TRUE, TRUE, 10);
    
    my $hbox = Gtk2::HBox->new (FALSE, 0);
    $hbox->set_border_width (10);
    $frame_vert->add ($hbox);

    $hbox->pack_start (create_bbox (FALSE, 30, 'spread'), TRUE, TRUE, 0);
    $hbox->pack_start (create_bbox (FALSE, 30, 'edge'),   TRUE, TRUE, 5);
    $hbox->pack_start (create_bbox (FALSE, 30, 'start'),  TRUE, TRUE, 5);
    $hbox->pack_start (create_bbox (FALSE, 30, 'end'),    TRUE, TRUE, 5);
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
do_button_box;
Gtk2->main;
