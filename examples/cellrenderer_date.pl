#!/usr/bin/perl -w

#
# Copyright (C) 2003 by Torsten Schoenfeld
# 
# This library is free software; you can redistribute it and/or modify it under
# the terms of the GNU Library General Public License as published by the Free
# Software Foundation; either version 2.1 of the License, or (at your option)
# any later version.
# 
# This library is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
# FOR A PARTICULAR PURPOSE.  See the GNU Library General Public License for
# more details.
# 
# You should have received a copy of the GNU Library General Public License
# along with this library; if not, write to the Free Software Foundation, Inc.,
# 59 Temple Place - Suite 330, Boston, MA  02111-1307  USA.
#
# $Header$
#


use strict;
use Gtk2 -init;

package Gtk2::CellRendererDate;

use Glib::Object::Subclass
  "Gtk2::CellRenderer",
  signals => {
    edited => {
      flags => [qw(run-last)],
      param_types => [qw(Glib::String Glib::Scalar)],
    },
  },
  properties => [
    Glib::ParamSpec -> boolean("editable", "Editable", "Can I change that?", 0, [qw(readable writable)]),
    Glib::ParamSpec -> string("date", "Date", "What's the date again?", "", [qw(readable writable)]),
  ]
;
__PACKAGE__->_install_overrides;

use constant x_padding => 2;
use constant y_padding => 3;

use constant arrow_width => 15;
use constant arrow_height => 15;

our $popup_window;
our $arrow = Gtk2::Arrow -> new("down", "none");

sub get_date_string {
  my ($cell) = @_;
  my ($year, $month, $day) = split(/\//, $cell -> { date });
  return join("/", ($year, sprintf("%02d", $month), sprintf("%02d", $day)));
}

sub calc_size {
  my ($cell, $layout) = @_;
  my ($width, $height) = $layout -> get_pixel_size();

  return (0,
          0,
          $width + x_padding * 2 + arrow_width,
          $height + y_padding * 2);
}

sub on_get_size {
  my ($cell, $widget, $cell_area) = @_;

  my $layout = $cell -> get_layout($widget);
  $layout -> set_text($cell -> get_date_string());

  return $cell -> calc_size($layout);
}

sub get_layout {
  my ($cell, $widget) = @_;

  return $widget -> create_pango_layout("");
}

sub on_render {
  my ($cell, $window, $widget, $background_area, $cell_area, $expose_area, $flags) = @_;
  my $state;

  if (grep {/selected/} @$flags) {
    $state = $widget -> has_focus()
      ? 'selected'
      : 'active';
  } else {
    $state = $widget -> state() eq 'insensitive'
      ? 'insensitive'
      : 'normal';
  }

  my $layout = $cell -> get_layout($widget);
  $layout -> set_text($cell -> get_date_string());

  my ($x_offset, $y_offset, $width, $height) = $cell -> calc_size($layout);

  $widget -> get_style -> paint_layout($window,
                                       $state,
                                       1,
                                       $cell_area,
                                       $widget,
                                       "cellrenderertext",
                                       $cell_area -> x() + $x_offset + x_padding,
                                       $cell_area -> y() + $y_offset + y_padding,
                                       $layout);

  $widget -> get_style -> paint_arrow ($window,
                                       $widget->state,
                                       'none',
                                       $cell_area,
                                       $arrow,
                                       "",
                                       "down",
                                       1,
                                       $cell_area -> x + $cell_area -> width - arrow_width,
                                       $cell_area -> y + $cell_area -> height - arrow_height - 2,
                                       arrow_width - 3,
                                       arrow_height);
}

sub on_start_editing {
  my ($cell, $event, $view, $path, $background_area, $cell_area, $flags) = @_;

  if (defined($popup_window)) {
    $popup_window -> destroy();
    $popup_window = undef;
  }

  

  my ($x_origin, $y_origin) =  $view -> get_bin_window() -> get_origin();
  my ($x_cell, $y_cell) = $view -> tree_to_widget_coords($cell_area -> x(), $cell_area -> y());

  $popup_window = Gtk2::Window -> new("popup");
  my $calendar = Gtk2::Calendar -> new();

  my ($year, $month, $day) = split(/\//, $cell -> get_date_string());

  $calendar -> select_month($month - 1, $year);
  $calendar -> select_day($day);

  $calendar -> display_options([qw(show_heading
                                   show_day_names
                                   week_start_monday)]);

  # FIXME this needs some serious work on focus handling and events and
  # keyboard and pointer grabs and such so that the date popup goes away
  # at the right time.  i tried looking through GtkCombo for inspiration,
  # but that's a little beyond what i'm up for right now.  -- muppet
#  $popup_window -> signal_connect(button_press_event => sub {
#    my ($widget, $event) = @_;
#    warn "hey there";
#    return 0;
#  });
#  $popup_window -> signal_connect(key_press_event => sub {
#    my ($widget, $event) = @_;
#    use Gtk2::Gdk::Keysyms;
#    if ($event -> keyval == $Gtk2::Gdk::Keysyms{ Escape }) {
#      $popup_window->destroy;
#      $popup_window = undef;
#      return 1;
#    }
#    return 0;
#  });
  $calendar -> signal_connect(day_selected_double_click => sub {
    my ($calendar) = @_;

    $cell -> signal_emit(edited => $path, [$calendar -> get_date()]);
    $popup_window -> destroy();
    $popup_window = undef;
  });

  $popup_window -> move($x_origin + $x_cell,
                        $y_origin + $y_cell + $cell_area -> height());

  $popup_window -> add($calendar);
  $popup_window -> show_all();

#  $calendar->grab_focus;
#  Gtk2->grab_add ($popup_window);

  return;
}


###############################################################################

package main;

my $window = Gtk2::Window -> new("toplevel");
$window -> set_title ("CellRendererDate");
$window -> signal_connect (delete_event => sub { Gtk2 -> main_quit(); });

my $model = Gtk2::ListStore -> new(qw(Glib::String));
my $view = Gtk2::TreeView -> new($model);

foreach (qw(2003/10/1 2003/10/2 2003/10/3)) {
  $model -> set($model -> append(), 0 => $_);
}

my $renderer = Gtk2::CellRendererDate -> new();
$renderer -> set(mode => "editable");

$renderer -> signal_connect(edited => sub {
  my ($cell, $path, $new_date) = @_;
  my ($year, $month, $day) = @{$new_date};

  $model -> set($model -> get_iter(Gtk2::TreePath -> new_from_string($path)),
                0 => join("/", ($year, $month + 1, $day)));
});

my $column = Gtk2::TreeViewColumn -> new_with_attributes ("Date",
                                                          $renderer,
                                                          date => 0);

$view -> append_column($column);

$window -> add($view);
$window -> show_all();

Gtk2 -> main();
