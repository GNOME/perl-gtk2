#!/usr/bin/perl -w
#
# Images
#
# GtkImage is used to display an image; the image can be in a number of formats.
# Typically, you load an image into a GdkPixbuf, then display the pixbuf.
#
# This demo code shows some of the more obscure cases, in the simple
# case a call to gtk_image_new_from_file() is all you need.
#
# If you want to put image data in your program as a C variable,
# use the make-inline-pixbuf program that comes with GTK+.
# This way you won't need to depend on loading external files, your
# application binary can be self-contained.
#

package images;

use blib '..';
use blib '../..';
use blib '../../G';
use constant FALSE => 0;
use constant TRUE => 1;
use Gtk2;
use strict;

my $i;
#include "demo-common.h"

my $window = undef;
my $pixbuf_loader = undef;
my $load_timeout = 0;
my $image_stream = undef;

sub error_popup {
	my $parent = shift;
	my $message = shift;
	my $dialog = Gtk2::MessageDialog->new ($parent, 'destroy-with-parent',
	                                       'error', 'close', $message);
	$dialog->signal_connect (response => sub {$_[0]->destroy; 1});
	$dialog->show;
}

sub progressive_prepared_callback {
  my ($loader, $image) = @_;
  
  my $pixbuf = $loader->get_pixbuf;

  #
  # Avoid displaying random memory contents, since the pixbuf
  # isn't filled in yet.
  #
  $pixbuf->fill (0xaaaaaaff);
  
  $image->set_from_pixbuf ($pixbuf);
}

sub progressive_updated_callback {
  my ($loader, $x, $y, $width, $height, $image) = @_;

  #
  # We know the pixbuf inside the GtkImage has changed, but the image
  # itself doesn't know this; so queue a redraw.  If we wanted to be
  # really efficient, we could use a drawing area or something
  # instead of a GtkImage, so we could control the exact position of
  # the pixbuf on the display, then we could queue a draw for only
  # the updated area of the image.
  # 
  
  $image->queue_draw;
}

sub progressive_timeout {
  my $image = shift;
  
  #
  # This shows off fully-paranoid error handling, so looks scary.
  # You could factor out the error handling code into a nice separate
  # function to make things nicer.
  #

  if (defined $image_stream) {
      my $buf;
      my $bytes_read = sysread ($image_stream, $buf, 256);

      # sysread returns undef on error
      if (not defined $bytes_read) {
	  error_popup ($window, "Failure reading image file 'alphatest.png': $!");

	  close $image_stream;
	  $image_stream = undef;

	  $load_timeout = 0;

	  return FALSE; # uninstall the timeout
      }

      eval { $pixbuf_loader->write ($buf, $bytes_read); };
###      eval { $pixbuf_loader->write ($buf); };

      if ($@) {
         error_popup ($window, "Failed to load image: $@");

         close $image_stream;
         $image_stream = undef;
	  
         $load_timeout = 0;

         return FALSE; # uninstall the timeout
      }

      if (eof $image_stream) {
	  close $image_stream;
	  $image_stream = undef;

          #
	  # Errors can happen on close, e.g. if the image file was
          # truncated we'll know on close that it was incomplete.
	  #
	  eval { $pixbuf_loader->close; };
	  if ($@) {
	     error_popup ($window, "Failed to load image: $@");

	     ##g_object_unref (pixbuf_loader);
	     $pixbuf_loader = undef;
	      
	     $load_timeout = 0;
	      
	     return FALSE; # uninstall the timeout
	  }
	  
	  ##g_object_unref (pixbuf_loader);
	  $pixbuf_loader = undef;
     }
  } else {
      my $error_message = undef;

      #
      # demo_find_file() looks in the the current directory first,
      # so you can run gtk-demo without installing GTK, then looks
      # in the location where the file is installed.
      #
      my $filename;
###      eval { $filename = demo_find_file ("alphatest.png"); };
      $filename = "alphatest.png";
      if ($@) {
	  $error_message = $@;
      } else {
          open ($image_stream, $filename)
	    or $error_message = "Unable to open image file 'alphatest.png': $!";
      }

      if (not defined $image_stream) {
	  error_popup ($window, $error_message);

	  $load_timeout = 0;

	  return FALSE; # uninstall the timeout
      }

      if ($pixbuf_loader) {
	  $pixbuf_loader->close;
	  ##g_object_unref (pixbuf_loader);
	  $pixbuf_loader = undef;
      }
      
      $pixbuf_loader = Gtk2::Gdk::PixbufLoader->new;
      
      $pixbuf_loader->signal_connect (area_prepared =>
			\&progressive_prepared_callback, $image);
      
      $pixbuf_loader->signal_connect (area_updated =>
			\&progressive_updated_callback, $image);
    }

  # leave timeout installed
  return TRUE;
}

sub start_progressive_loading {
  my $image = shift;
  #
  # This is obviously totally contrived (we slow down loading
  # on purpose to show how incremental loading works).
  # The real purpose of incremental loading is the case where
  # you are reading data from a slow source such as the network.
  # The timeout simply simulates a slow data source by inserting
  # pauses in the reading process.
  #
  $load_timeout = G::Timeout->add (150, \&progressive_timeout, $image);
}

sub cleanup_callback {
  my ($object, $data) = @_;

  if ($load_timeout) {
      G::Source->remove ($load_timeout);
      $load_timeout = 0;
  }
  
  if ($pixbuf_loader) {
      $pixbuf_loader->close;
      ##g_object_unref (pixbuf_loader);
      $pixbuf_loader = undef;
  }

  if ($image_stream) {
    close $image_stream;
  }
  $image_stream = undef;
}

sub toggle_sensitivity_callback {
  my ($togglebutton, $container) = @_;
  my $newstate = ! $togglebutton->get_active;

  foreach my $child ($container->get_children) {
      # don't disable our toggle
      $child->set_sensitive ($newstate)
           if not $child->eq ($togglebutton);
  }
}
  

sub do {
  if (!$window) {
      $window = Gtk2::Window->new;
      $window->set_title ("Images");

      $window->signal_connect (destroy => sub { $window = undef; 1 });
      $window->signal_connect (destroy => \&cleanup_callback);

      $window->set_border_width (8);

      my $vbox = Gtk2::VBox->new (FALSE, 8);
      $vbox->set_border_width (8);
      $window->add ($vbox);

      my $label = Gtk2::Label->new;
      $label->set_markup ("<u>Image loaded from a file</u>");
      $vbox->pack_start ($label, FALSE, FALSE, 0);
      
      my $frame = Gtk2::Frame->new;
      $frame->set_shadow_type ('in');
      #
      # The alignment keeps the frame from growing when users resize
      # the window
      #
      my $align = Gtk2::Alignment->new (0.5, 0.5, 0, 0);
      $align->add ($frame);
      $vbox->pack_start ($align, FALSE, FALSE, 0);

      #
      # demo_find_file() looks in the the current directory first,
      # so you can run gtk-demo without installing GTK, then looks
      # in the location where the file is installed.
      #
      my $pixbuf = undef;
      eval {
        my $filename = "gtk-logo-rgb.gif";
        ##my $filename = demo_find_file ("gtk-logo-rgb.gif");
        $pixbuf = Gtk2::Gdk::Pixbuf->new_from_file ($filename);
      };

      if ($@) {
          # This code shows off error handling. You can just use
          # gtk_image_new_from_file() instead if you don't want to report
          # errors to the user. If the file doesn't load when using
          # gtk_image_new_from_file(), a "missing image" icon will
          # be displayed instead.
          #
          error_popup ($window,
                       "Unable to open image file 'gtk-logo-rgb.gif': $@");
      }
	  
      my $image = Gtk2::Image->new_from_pixbuf ($pixbuf);

      $frame->add ($image);


      # Animation

      $label = Gtk2::Label->new;
      $label->set_markup ("<u>Animation loaded from a file</u>");
      $vbox->pack_start ($label, FALSE, FALSE, 0);
      
      $frame = Gtk2::Frame->new;
      $frame->set_shadow_type ('in');
      #
      # The alignment keeps the frame from growing when users resize
      # the window
      #
      $align = Gtk2::Alignment->new (0.5, 0.5, 0, 0);
      $align->add ($frame);
      $vbox->pack_start ($align, FALSE, FALSE, 0);

      my $filename;
      eval {
##          $filename = demo_find_file ("floppybuddy.gif");
          $filename = "floppybuddy.gif";
      };
      $image = Gtk2::Image->new_from_file ($filename);
      ##g_free (filename);

      $frame->add ($image);
      

      # Progressive
      
      
      $label = Gtk2::Label->new;
      $label->set_markup ("<u>Progressive image loading</u>");
      $vbox->pack_start ($label, FALSE, FALSE, 0);
      
      $frame = Gtk2::Frame->new;
      $frame->set_shadow_type ('in');
      #
      # The alignment keeps the frame from growing when users resize
      # the window
      #
      $align = Gtk2::Alignment->new (0.5, 0.5, 0, 0);
      $align->add ($frame);
      $vbox->pack_start ($align, FALSE, FALSE, 0);

      #
      # Create an empty image for now; the progressive loader
      # will create the pixbuf and fill it in.
      #
      $image = Gtk2::Image->new_from_pixbuf (undef);
      $frame->add ($image);

      start_progressive_loading ($image);

      # Sensitivity control
###      my $button = Gtk2::ToggleButton->new_with_mnemonic ("_Insensitive");
      my $button = Gtk2::ToggleButton->new ("_Insensitive");
      $vbox->pack_start ($button, FALSE, FALSE, 0);

      $button->signal_connect (toggled => \&toggle_sensitivity_callback, $vbox);
  }

  if (!$window->visible) {
      $window->show_all;
  } else {
      $window->destroy;
      $window = undef;
  }

  return $window;
}

1;
