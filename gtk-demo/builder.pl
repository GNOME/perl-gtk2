#!/usr/bin/perl -w
#
# Builder
#
# Demonstrates an interface loaded from a XML description.
#

package builder;

use strict;
use warnings;
use Glib ':constants';
use Gtk2;
#include "demo-common.h"

my $builder = undef;
my $window = undef;


sub quit_activate($) {
  my $action = shift;
  my $window;

  $window = $builder->get_object("window1");
  $window->destroy();
}


sub about_activate($) {
  my $action = shift;
  my $about_dlg;

  $about_dlg = $builder->get_object("aboutdialog1");
  $about_dlg->run();
  $about_dlg->hide();
}


sub do {  
  my $do_widget = shift;
  my $filename;
  
  if (!$window) {
      $builder = Gtk2::Builder->new();
      eval {
        $filename = main::demo_find_file ("demo.ui");
        $builder->add_from_file($filename);
      };
      warn "ERROR: $@"
            if $@;
      $builder->connect_signals();
      $window = $builder->get_object("window1");
      $window->set_screen ($do_widget->get_screen)
        if Gtk2->CHECK_VERSION (2, 2, 0);
      $window->signal_connect("destroy", sub { $window = undef; });
  }

  if (!$window->visible()) {
      $window->show();
  } else {
      $window->destroy();
  }

  return $window;
}


1;
__END__
Copyright (C) 2003 by the gtk2-perl team (see the file AUTHORS for the
full list)

This library is free software; you can redistribute it and/or modify it under
the terms of the GNU Library General Public License as published by the Free
Software Foundation; either version 2.1 of the License, or (at your option) any
later version.

This library is distributed in the hope that it will be useful, but WITHOUT ANY
WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
PARTICULAR PURPOSE.  See the GNU Library General Public License for more
details.

You should have received a copy of the GNU Library General Public License along
with this library; if not, write to the Free Software Foundation, Inc., 
51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA.
