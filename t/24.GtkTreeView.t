#!/usr/bin/perl -w

###############################################################################

use Gtk2::TestHelper tests => 166;

my @version_info = Gtk2 -> get_version_info();

###############################################################################

my $window = Gtk2::Window -> new("toplevel");

my $model = Gtk2::TreeStore -> new("Glib::String", "Glib::Boolean");
my $view = Gtk2::TreeView -> new();
isa_ok($view, "Gtk2::TreeView");

$view -> set_model($model);
isa_ok($view -> get_model(), "Gtk2::TreeStore");

foreach (qw(bla blee bliii bloooo)) {
	my $iter = $model -> append(undef);

	$model -> set($iter,
		      0 => $_,
		      1 => 0);

	#######################################################################

	foreach my $multiplier(1 .. 3) {
		my $iter_child = $model -> append($iter);

		$model -> set($iter_child,
			      0 => $_ x $multiplier,
			      1 => 0);

		my $iter_child_child = $model -> append($iter_child);

		$model -> set($iter_child_child,
			      0 => reverse($_) x $multiplier,
			      1 => 1);
	}
}

###############################################################################

$window -> add($view);
$view -> realize();
$window -> show_all();

###############################################################################

my $view_column = Gtk2::TreeViewColumn -> new();
isa_ok($view_column, "Gtk2::TreeViewColumn");

$view_column -> set_spacing(23);
is($view_column -> get_spacing(), 23);

$view_column -> set_visible(0);
is($view_column -> get_visible(), ""); # xxx

$view_column -> set_resizable(1);
is($view_column -> get_resizable(), 1);

like($view_column -> get_width(), qr/^\d+$/);

$view_column -> set_fixed_width(42);
is($view_column -> get_fixed_width(), 42);

$view_column -> set_min_width(23);
is($view_column -> get_min_width(), 23);

$view_column -> set_max_width(42);
is($view_column -> get_max_width(), 42);

$view_column -> set_sizing("autosize");
is($view_column -> get_sizing(), "autosize");

$view_column -> set_title("Bla");
is($view_column -> get_title(), "Bla");

$view_column -> set_widget(Gtk2::Button -> new("Bla"));
isa_ok($view_column -> get_widget(), "Gtk2::Button");

$view_column -> set_alignment(1.0);
is($view_column -> get_alignment(), 1.0);

$view_column -> set_reorderable(1);
is($view_column -> get_reorderable(), 1);

$view_column -> set_sort_column_id(5);
is($view_column -> get_sort_column_id(), 5);

$view_column -> set_sort_indicator(1);
is($view_column -> get_sort_indicator(), 1);

$view_column -> set_sort_order("descending");
is($view_column -> get_sort_order(), "descending");

SKIP: {
	skip("cell_is_visible is new in 2.2.x", 1)
		unless ($version_info[1] >= 2);

	is($view_column -> cell_is_visible(), ""); # xxx
}

###############################################################################

my $cell_renderer = Gtk2::CellRendererText -> new();
isa_ok($cell_renderer, "Gtk2::CellRendererText");

$view_column = Gtk2::TreeViewColumn -> new_with_attributes("Bla",
							   $cell_renderer,
							   text => 0);

$cell_renderer -> set_fixed_height_from_font(-1);

$view_column -> pack_start(Gtk2::CellRendererToggle -> new(), 1);
$view_column -> pack_end(Gtk2::CellRendererPixbuf -> new(), 0);

isa_ok(($view_column -> get_cell_renderers())[0], "Gtk2::CellRendererText");
isa_ok(($view_column -> get_cell_renderers())[1], "Gtk2::CellRendererToggle");
isa_ok(($view_column -> get_cell_renderers())[2], "Gtk2::CellRendererPixbuf");

$view_column -> clear();
is($view_column -> get_cell_renderers(), undef);

###############################################################################

$cell_renderer = Gtk2::CellRendererToggle -> new();
isa_ok($cell_renderer, "Gtk2::CellRendererToggle");

$view_column -> pack_start($cell_renderer, 1);

$view_column -> add_attribute($cell_renderer,
			      activatable => 1);

$cell_renderer -> set_radio(1);
is($cell_renderer -> get_radio(), 1);

$cell_renderer -> set_active(1);
is($cell_renderer -> get_active(), 1);

###############################################################################

$cell_renderer = Gtk2::CellRendererPixbuf -> new();
isa_ok($cell_renderer, "Gtk2::CellRendererPixbuf");

$view_column -> pack_start($cell_renderer, 1);

$view_column -> set_attributes($cell_renderer, stock_id => 0);
$view_column -> clear_attributes($cell_renderer);

###############################################################################

$view_column -> set_clickable(1);
is($view_column -> get_clickable(), 1);

$view_column -> signal_connect(clicked => sub {
	my ($view_column) = @_;
	isa_ok($view_column, "Gtk2::TreeViewColumn");
});

# xxx
# $view_column -> clicked();
$view_column -> signal_emit("clicked");

###############################################################################

$view -> append_column(my $view_column_one = Gtk2::TreeViewColumn -> new());
$view -> insert_column(my $view_column_two = Gtk2::TreeViewColumn -> new(), 1);
$view -> insert_column_with_attributes(0,
				       "Bla",
				       Gtk2::CellRendererToggle -> new(),
				       text => 0);
$view -> insert_column_with_data_func(1,
				      "Blub",
				      Gtk2::CellRendererText -> new(),
				      sub {});

$view -> move_column_after($view_column_one, $view_column_two);

$view -> set_expander_column($view_column_one);

SKIP: {
	skip("get_expander_column is new in 2.2.x", 1)
		unless ($version_info[1] >= 2);

	is($view -> get_expander_column(), $view_column_one);
}

isa_ok($view -> get_cell_area(Gtk2::TreePath -> new("0:0"), $view_column_two),
   "Gtk2::Gdk::Rectangle");

isa_ok($view -> get_background_area(Gtk2::TreePath -> new("0:0"), $view_column_two),
   "Gtk2::Gdk::Rectangle");

$view -> set_cursor(Gtk2::TreePath -> new("1:0"), $view_column_one, 0);
is(($view -> get_cursor())[0] -> to_string(), "1:0");
is(($view -> get_cursor())[1], $view_column_one);

$view -> scroll_to_cell(Gtk2::TreePath -> new("1:1"), $view_column_one, 1, 0.5, 0.5);
$view -> scroll_to_cell(Gtk2::TreePath -> new("1:1"), $view_column_one, 0);

$view -> row_activated(Gtk2::TreePath -> new("2:0"), $view_column);

$view -> remove_column($view -> get_column(0));
$view -> remove_column($_) foreach ($view -> get_columns());

is($view -> get_columns(), undef);

###############################################################################

isa_ok($view -> get_hadjustment(), "Gtk2::Adjustment");
isa_ok($view -> get_vadjustment(), "Gtk2::Adjustment");

my $h_adjustment = Gtk2::Adjustment -> new(0, 0, 100, 5, 20, 40);
my $v_adjustment = Gtk2::Adjustment -> new(0, 0, 100, 5, 20, 40);

$view -> set_hadjustment($h_adjustment);
$view -> set_vadjustment($v_adjustment);

is($view -> get_hadjustment(), $h_adjustment);
is($view -> get_vadjustment(), $v_adjustment);

$view -> set_headers_visible(0);
is($view -> get_headers_visible(), ""); # xxx

$view -> set_headers_clickable(1);

$view -> set_rules_hint(1);
is($view -> get_rules_hint(), 1);

$view -> set_reorderable(1);
is($view -> get_reorderable(), 1);

$view -> set_enable_search(0);
is($view -> get_enable_search(), ""); # xxx

$view -> set_search_column(1);
is($view -> get_search_column(), 1);

isa_ok($view -> get_bin_window(), "Gtk2::Gdk::Window");

isa_ok($view -> get_visible_rect(), "Gtk2::Gdk::Rectangle");

$view -> columns_autosize();

###############################################################################

my $path = Gtk2::TreePath -> new("1:1");

$view -> expand_all();
is($view -> row_expanded($path), 1);

SKIP: {
	skip("expand_to_path is new in 2.2.x", 1)
		unless ($version_info[1] >= 2);

	$view -> expand_to_path($path);
	is($view -> row_expanded($path), 1);
}

$view -> collapse_row($path);
is($view -> row_expanded($path), ""); # xxx

$view -> expand_row($path, 0);
is($view -> row_expanded($path), 1);

$view -> map_expanded_rows(sub {
	my ($view, $path) = @_;

	isa_ok($view, "Gtk2::TreeView");
	isa_ok($path, "Gtk2::TreePath");

	is($view -> row_expanded($path), 1);
});

$view -> collapse_all();
is($view -> row_expanded($path), ""); # xxx

###############################################################################

$view -> set_search_equal_func(sub { return 1; });
$view -> set_column_drag_function(sub { return 1; });

###############################################################################

$cell_renderer = Gtk2::CellRendererToggle -> new();

$view_column = Gtk2::TreeViewColumn -> new_with_attributes("Blab", $cell_renderer);
$view_column -> set_cell_data_func($cell_renderer, sub {
	my ($view_column, $cell, $model, $iter) = @_;

	isa_ok($view_column, "Gtk2::TreeViewColumn");
	isa_ok($cell, "Gtk2::CellRendererToggle");
	isa_ok($model, "Gtk2::TreeStore");
	isa_ok($iter, "Gtk2::TreeIter");

	SKIP: {
		skip("focus_cell is new in 2.2.x", 2)
			unless ($version_info[1] >= 2);

		$view_column -> focus_cell($cell);

		is(($view_column -> cell_get_position($cell))[0], 0);
		like(($view_column -> cell_get_position($cell))[1], qr/^\d+$/);
	}

	$cell -> set_fixed_size(23, 42);

	is(($cell -> get_fixed_size())[0], 23);
	is(($cell -> get_fixed_size())[1], 42);
});

$view -> append_column($view_column);

SKIP: {
	skip("set_cursor_on_cell is new in 2.2.x", 2)
		unless ($version_info[1] >= 2);

	$view -> set_cursor_on_cell(Gtk2::TreePath -> new("1:1"),
				    $view_column,
				    $cell_renderer,
				    0);

	is(($view -> get_cursor())[0] -> to_string(), "1:1");
	is(($view -> get_cursor())[1], $view_column);
}

###############################################################################

Glib::Idle -> add(sub {
	Gtk2 -> main_quit();
	return 0;
});

Gtk2 -> main();

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
with this library; if not, write to the Free Software Foundation, Inc., 59
Temple Place - Suite 330, Boston, MA  02111-1307  USA.
