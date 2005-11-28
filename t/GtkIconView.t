#
# $Header$
#

#########################
# GtkIconView Tests
# 	- rm
#########################

#########################

use strict;
use warnings;

use Gtk2::TestHelper tests => 52,
    at_least_version => [2, 6, 0, "GtkIconView is new in 2.6"],
    ;

use constant TEXT => 0;
use constant PIXBUF => 1;
use constant BOOLEAN => 2;

my $win = Gtk2::Window->new;
#my $swin = Gtk2::ScrolledWindow->new;
#$win->add ($swin);

my $model = create_store ();

isa_ok (my $iview = Gtk2::IconView->new, 'Gtk2::IconView',
	'Gtk2::IconView->new');

is ($iview->get_model, undef, '$iview->get_model, undef');
$iview->set_model ($model);
is ($iview->get_model, $model, '$iview->set|get_model');

isa_ok ($iview = Gtk2::IconView->new_with_model ($model), 'Gtk2::IconView',
	'Gtk2::IconView->new');
#$swin->add ($iview);
is ($iview->get_model, $model, '$iview->get_model, new_with_model');

fill_store ($model, get_pixbufs ($win));

is ($iview->get_text_column, -1, '$iview->get_text_column, undef');
$iview->set_text_column (TEXT);
is ($iview->get_text_column, TEXT, '$iview->set|get_text_column');

is ($iview->get_pixbuf_column, -1, '$iview->get_pixbuf_column, undef');
$iview->set_pixbuf_column (PIXBUF);
is ($iview->get_pixbuf_column, PIXBUF, '$iview->set|get_pixbuf_column');

is ($iview->get_markup_column, -1, '$iview->get_markup_column, undef');
$iview->set_markup_column (TEXT);
is ($iview->get_markup_column, TEXT, '$iview->set|get_markup_column');

foreach (qw/horizontal vertical/)
{
	$iview->set_orientation ($_);
	is ($iview->get_orientation, $_, '$iview->set|get_orienation, '.$_);
}

# extended should be in this list, but it seems to fail
foreach (qw/none single browse multiple/)
{
	$iview->set_selection_mode ($_);
	is ($iview->get_selection_mode, $_,
	    '$iview->set|get_selection_mode '.$_);
}

$iview->set_columns (23);
is ($iview->get_columns, 23);

$iview->set_item_width (23);
is ($iview->get_item_width, 23);

$iview->set_spacing (23),
is ($iview->get_spacing, 23);

$iview->set_row_spacing (23);
is ($iview->get_row_spacing, 23);

$iview->set_column_spacing (23);
is ($iview->get_column_spacing, 23);

$iview->set_margin (23);
is ($iview->get_margin, 23);

#$win->show_all;

run_main sub {
	# this stuff is liable to be flaky, it may require TODO's
	my $path = $iview->get_path_at_pos (50, 50);
	isa_ok ($path, 'Gtk2::TreePath', '$iview->get_path_at_pos (50, 50)');

	is ($iview->path_is_selected ($path), '',
	    '$iview->path_is_selected, no');
	$iview->select_path ($path);
	is ($iview->path_is_selected ($path), 1,
	    '$iview->path_is_selected, yes');
	$iview->unselect_path ($path);
	is ($iview->path_is_selected ($path), '',
	    '$iview->path_is_selected, no');

	$iview->item_activated ($path);

	my @sels = $iview->get_selected_items;
	is (scalar (@sels), 0, '$iview->get_selected_items, count 0');

	$iview->select_all;
	@sels = $iview->get_selected_items;
	is (scalar (@sels), 14, '$iview->get_selected_items, count 14');
	isa_ok ($sels[0], 'Gtk2::TreePath', '$iview->get_selected_items, type');

	$iview->unselect_all;
	@sels = $iview->get_selected_items;
	is (scalar (@sels), 0, '$iview->get_selected_items, count 0');

	$iview->select_path ($path);
	$iview->selected_foreach (sub {
		my ($view, $path, $data) = @_;
		isa_ok ($view, 'Gtk2::IconView');
		isa_ok ($path, 'Gtk2::TreePath');
		isa_ok ($data, 'HASH');
		is ($data->{foo}, 'bar', 'callback data intact');
	}, { foo => 'bar' });
	$iview->select_all;
	my $ncalls = 0;
	$iview->selected_foreach (sub { $ncalls++ });
	my @selected_items = $iview->get_selected_items;
	is ($ncalls, scalar(@selected_items),
	    'called once for each selected child');

	SKIP: {
		skip 'new 2.8 stuff', 16
			unless Gtk2->CHECK_VERSION (2, 8, 0);

		$win->add ($iview);
		$win->show_all;

		my ($path, $cell) = $iview->get_item_at_pos (50, 50);
		isa_ok ($path, "Gtk2::TreePath");
		isa_ok ($cell, "Gtk2::CellRenderer");

		$iview->set_cursor ($path, undef, FALSE);
		my @tmp = $iview->get_cursor;
		is (@tmp, 2);
		isa_ok ($tmp[0], "Gtk2::TreePath");
		is ($tmp[1], undef);

		$iview->set_cursor ($path, $cell, TRUE);
		@tmp = $iview->get_cursor;
		is (@tmp, 2);
		isa_ok ($tmp[0], "Gtk2::TreePath");
		is ($tmp[1], $cell);

		@tmp = $iview->get_visible_range;
		isa_ok ($tmp[0], "Gtk2::TreePath");
		isa_ok ($tmp[1], "Gtk2::TreePath");

		$iview->scroll_to_path ($path, TRUE, 0.5, 0.5);

		$iview->enable_model_drag_source ([qw/shift-mask/], "copy",
		  { target => "STRING", flags => ["same-app", "same-widget"], info => 42 });
		$iview->enable_model_drag_dest ("copy",
		  { target => "STRING", flags => ["same-app", "same-widget"], info => 42 });

		$iview->unset_model_drag_source;
		$iview->unset_model_drag_dest;

		$iview->set_reorderable (TRUE);
		ok ($iview->get_reorderable);

		$iview->set_drag_dest_item ($path, "drop-into");
		@tmp = $iview->get_drag_dest_item;
		isa_ok ($tmp[0], "Gtk2::TreePath");
		is ($tmp[1], "drop-into");

		my ($tmp_path, $pos) = $iview->get_dest_item_at_pos (50, 50);
		isa_ok ($tmp_path, "Gtk2::TreePath");
		like ($pos, qr/drop/);

		isa_ok ($iview->create_drag_icon ($path), "Gtk2::Gdk::Pixmap");
	}
};

sub create_store
{
	my $store = Gtk2::ListStore->new (qw/Glib::String Gtk2::Gdk::Pixbuf
					     Glib::Boolean/);
	return $store;
}

sub get_pixbufs
{
	my $win = shift;

	my @pbs;

	foreach (qw/gtk-ok gtk-cancel gtk-about gtk-quit/)
	{
		push @pbs, $win->render_icon ($_, 'dialog');
	}

	return \@pbs;
}

sub fill_store
{
	my $store = shift;
	my $pbs = shift;

	foreach (qw/one two three four five six seven eight nine uno dos
		    tres quatro cinco/)
	{
		my $iter = $store->append;
		$store->set ($iter,
			     TEXT, "$_",
			     PIXBUF, $pbs->[rand (@$pbs)],
			     BOOLEAN, rand (2),
		     );
	}
}
