#!/usr/bin/perl -w
use strict;
use Gtk2::TestHelper tests => 145;

# $Header$

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
ginterfaces_ok($view_column);

$view_column -> set_spacing(23);
is($view_column -> get_spacing(), 23);

$view_column -> set_visible(1);
is($view_column -> get_visible(), 1);

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
		unless Gtk2->CHECK_VERSION (2, 2, 0);

	ok(!$view_column -> cell_is_visible());
}

SKIP: {
	skip("[sg]et_expand are new in 2.4", 1)
		unless Gtk2->CHECK_VERSION (2, 4, 0);

	$view_column -> set_expand(1);
	is($view_column -> get_expand(), 1);
}

SKIP: {
	skip("new 2.8 stuff", 0)
		unless Gtk2->CHECK_VERSION (2, 8, 0);

	$view_column -> queue_resize();
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

$view_column -> clicked();
$view_column -> signal_emit("clicked");

###############################################################################

$view -> append_column(my $view_column_one = Gtk2::TreeViewColumn -> new());
$view -> insert_column(my $view_column_two = Gtk2::TreeViewColumn -> new(), 1);
$view -> insert_column_with_attributes(0,
				       "Bla",
				       Gtk2::CellRendererToggle -> new(),
				       active => 1);
$view -> insert_column_with_data_func(1,
				      "Blub",
				      Gtk2::CellRendererText -> new(),
				      sub {});

$view -> move_column_after($view_column_one, $view_column_two);

$view -> set_expander_column($view_column_one);

SKIP: {
	skip("get_expander_column is new in 2.2.x", 1)
		unless Gtk2->CHECK_VERSION (2, 2, 0);

	is($view -> get_expander_column(), $view_column_one);
}

my $path = Gtk2::TreePath -> new("0:0");

isa_ok($view -> get_cell_area($path, $view_column_two), "Gtk2::Gdk::Rectangle");
isa_ok($view -> get_cell_area(undef, $view_column_two), "Gtk2::Gdk::Rectangle");
isa_ok($view -> get_cell_area($path, undef), "Gtk2::Gdk::Rectangle");

isa_ok($view -> get_background_area($path, $view_column_two), "Gtk2::Gdk::Rectangle");
isa_ok($view -> get_background_area(undef, $view_column_two), "Gtk2::Gdk::Rectangle");
isa_ok($view -> get_background_area($path, undef), "Gtk2::Gdk::Rectangle");

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

$view -> set_headers_visible(1);
is($view -> get_headers_visible(), 1);

$view -> set_headers_clickable(1);

SKIP: {
	skip "new 2.10 stuff", 1
		unless Gtk2 -> CHECK_VERSION(2, 10, 0);

	is($view -> get_headers_clickable(), 1);
}

$view -> set_rules_hint(1);
is($view -> get_rules_hint(), 1);

$view -> set_reorderable(1);
is($view -> get_reorderable(), 1);

$view -> set_enable_search(1);
is($view -> get_enable_search(), 1);

$view -> set_search_column(1);
is($view -> get_search_column(), 1);

isa_ok($view -> get_bin_window(), "Gtk2::Gdk::Window");

isa_ok($view -> get_visible_rect(), "Gtk2::Gdk::Rectangle");

$view -> columns_autosize();

###############################################################################

$path = Gtk2::TreePath -> new("1:1");

$view -> expand_all();
is($view -> row_expanded($path), 1);

SKIP: {
	skip("expand_to_path is new in 2.2.x", 1)
		unless Gtk2->CHECK_VERSION (2, 2, 0);

	$view -> expand_to_path($path);
	is($view -> row_expanded($path), 1);
}

$view -> collapse_row($path);
ok(!$view -> row_expanded($path));

$view -> expand_row($path, 0);
ok($view -> row_expanded($path));

$view -> map_expanded_rows(sub {
	my ($view, $path) = @_;

	isa_ok($view, "Gtk2::TreeView");
	isa_ok($path, "Gtk2::TreePath");

	is($view -> row_expanded($path), 1);
});

$view -> collapse_all();
ok(!$view -> row_expanded($path));

###############################################################################

$view -> set_search_equal_func(sub { return 1; });
$view -> set_column_drag_function(sub { return 1; });

###############################################################################

SKIP: {
	# NOTE: the skip count here includes 2 for each tested accessor and
	#       three for the row separator callback.
	skip "new toys in 2.6", 9
		unless Gtk2->CHECK_VERSION (2, 6, 0);

	# here are a few new properties which default to off; let's check
	# the accessors & mutators by turning them on and then back off,
	# to avoid disrupting the tests that follow.
	foreach my $thing (qw(fixed_height_mode
			      hover_selection
			      hover_expand)) {
		my $setter = "set_$thing";
		my $getter = "get_$thing";
		$view->$setter (1);
		ok ($view->$getter, $thing);

		$view->$setter (0);
		ok (!$view->$getter, $thing);
	}

	my $i_know_this_place = 0;
	$view->set_row_separator_func (sub {
		my ($model, $iter, $data) = @_;

		return FALSE if ($i_know_this_place++);

		isa_ok ($model, 'Gtk2::TreeModel');
		isa_ok ($iter, 'Gtk2::TreeIter');
		isa_ok ($data, 'HASH');
		my $path = $model->get_path ($iter);
		return 1 == ($path->get_indices)[0];
	}, {thing=>'foo'});
}

SKIP: {
	skip("new 2.8 stuff", 2)
		unless Gtk2 -> CHECK_VERSION(2, 8, 0);

	my ($start, $end) = $view -> get_visible_range();
        isa_ok($start, "Gtk2::TreePath");
        isa_ok($end, "Gtk2::TreePath");
}

SKIP: {
	skip("new 2.10 stuff", 1)
		unless Gtk2 -> CHECK_VERSION(2, 10, 0);

	my $entry = Gtk2::Entry -> new();
	$view -> set_search_entry($entry);
	isa_ok($view -> get_search_entry(), "Gtk2::Entry");

	# FIXME: This doesn't actually invoke the handler.
	$view -> set_search_position_func(sub { warn @_; }, "bla");
	run_main sub { $view -> signal_emit("start_interactive_search") };
	$view -> set_search_position_func(undef);

	$view -> set_rubber_banding(TRUE);
	ok($view -> get_rubber_banding());

	$view -> set_grid_lines("both");
	is($view -> get_grid_lines(), "both");

	$view -> set_enable_tree_lines(FALSE);
	ok(!$view -> get_enable_tree_lines());
}

SKIP: {
	skip "new 2.12 stuff", 2
		unless Gtk2 -> CHECK_VERSION(2, 11, 0); # FIXME: 2.12

	$view -> set_show_expanders(TRUE);
	ok($view -> get_show_expanders());

	$view -> set_level_indentation(23);
	is($view -> get_level_indentation(), 23);
}

###############################################################################

my $i_know_this_place = 0;
$cell_renderer = Gtk2::CellRendererToggle -> new();

$view_column = Gtk2::TreeViewColumn -> new_with_attributes("Blab", $cell_renderer);
$view_column -> set_cell_data_func($cell_renderer, sub {
	my ($view_column, $cell, $model, $iter) = @_;

        return if ($i_know_this_place++);

	$view_column -> cell_set_cell_data($model,
	                                   $model -> get_iter_first(),
	                                   1, 1);

	my ($x_offset,
	    $y_offset,
	    $width,
	    $height,
	    $cell_area) = $view_column -> cell_get_size();

	like($x_offset, qr/^\d+$/);
	like($y_offset, qr/^\d+$/);
	like($width, qr/^\d+$/);
	like($height, qr/^\d+$/);
	isa_ok($cell_area, "Gtk2::Gdk::Rectangle");

	isa_ok($view_column, "Gtk2::TreeViewColumn");
	isa_ok($cell, "Gtk2::CellRendererToggle");
	isa_ok($model, "Gtk2::TreeStore");
	isa_ok($iter, "Gtk2::TreeIter");

	SKIP: {
		skip("focus_cell is new in 2.2.x", 2)
			unless Gtk2->CHECK_VERSION (2, 2, 0);

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
		unless Gtk2->CHECK_VERSION (2, 2, 0);

	$view -> set_cursor_on_cell(Gtk2::TreePath -> new("1:1"),
				    $view_column,
				    $cell_renderer,
				    0);

	is(($view -> get_cursor())[0] -> to_string(), "1:1");
	is(($view -> get_cursor())[1], $view_column);
}


$view->scroll_to_point (0, 0);

$view->set_cursor_on_cell (Gtk2::TreePath->new ("1:1"), undef, undef, 0)
	if Gtk2->CHECK_VERSION (2, 2, 0);

$view->signal_connect (button_press_event => sub {
		my ($v, $e) = @_;

		my @res = $view->get_path_at_pos ($e->x, $e->y);
		isa_ok ($res[0], 'Gtk2::TreePath', 'get_path_at_pos, path');
		isa_ok ($res[1], 'Gtk2::TreeViewColumn', 'get_path_at_pos, col');
		ok ($res[2] == 0 && $res[3] == 0, 'get_path_at_pos, pos');

		@res = $view->tree_to_widget_coords (10, 10);
		is (scalar (@res), 2, 'tree_to_widget_coords, num returns');
		@res = $view->widget_to_tree_coords (@res);
		is (scalar (@res), 2, 'tree_to_widget_coords, num returns');
		ok (eq_array (\@res, [10, 10]), 
		    'tree_to_widget_coords -> widget_to_tree_coords');

	});
my $event = Gtk2::Gdk::Event->new ('button-press');

run_main sub { $view->signal_emit ('button_press_event', $event) };

__END__

Copyright (C) 2003-2006 by the gtk2-perl team (see the file AUTHORS for the
full list).  See LICENSE for more information.
