use strict;
use Gtk2;
use Test::More;

##############################################################################

if( Gtk2->init_check )
{
	plan tests => 17;
}
else
{
	plan skip_all =>
		'Gtk2->init_check failed, probably unable to open DISPLAY';
}

##############################################################################

my $window = Gtk2::Window -> new("toplevel");
my $model = Gtk2::ListStore -> new("Glib::String");
my $view = Gtk2::TreeView -> new($model);

my $renderer = Gtk2::CellRendererText -> new();
my $column = Gtk2::TreeViewColumn -> new_with_attributes(
				       "Hmm",
				       $renderer,
				       text => 0);

$view -> append_column($column);

foreach (qw(bla ble bli blo blu)) {
	$model -> set($model -> append(), 0 => $_);
}

##############################################################################

my $selection = $view -> get_selection();
$selection -> select_path(Gtk2::TreePath -> new_from_string(0));

##############################################################################

$selection -> set_mode("browse");
ok($selection -> get_mode() eq "browse");

##############################################################################

ok(ref($selection -> get_tree_view()) eq "Gtk2::TreeView");

##############################################################################

my ($tmp_model, $tmp_iterator) = $selection -> get_selected();
ok(ref($tmp_model) eq "Gtk2::ListStore" &&
   ref($tmp_iterator) eq "Gtk2::TreeIter");

ok(ref($selection -> get_selected) eq "Gtk2::TreeIter");

##############################################################################

ok(ref($selection -> get_selected_rows()) eq "Gtk2::TreePath");

##############################################################################

ok($selection -> count_selected_rows() == 1);

my $path = Gtk2::TreePath -> new_from_string(1);

$selection -> select_path($path);
ok($selection -> path_is_selected($path));

$selection -> unselect_path($path);
ok(not $selection -> path_is_selected($path));

##############################################################################

my $iterator = $model -> get_iter($path);

$selection -> select_iter($iterator);
ok($selection -> iter_is_selected($iterator));

$selection -> unselect_iter($iterator);
ok(not $selection -> iter_is_selected($iterator));

##############################################################################

$selection -> set_mode("multiple");

$selection -> select_all();
ok($selection -> count_selected_rows() == 5);

$selection -> unselect_all();
ok($selection -> count_selected_rows() == 0);

my $path_start = Gtk2::TreePath -> new_from_string(3);
my $path_end = Gtk2::TreePath -> new_from_string(4);

$selection -> select_range($path_start, $path_end);
ok($selection -> count_selected_rows() == 2);

SKIP: {
	skip 'unselect_range is new in 2.2.x', 1
		unless (Gtk2->get_version_info)[1] >= 2;
	$selection -> unselect_range($path_start, $path_end);
	is($selection -> count_selected_rows(), 0);
}

##############################################################################

Glib::Idle -> add(sub {
	$selection -> unselect_all();

	$selection -> set_select_function(sub {
		my ($selection, $model, $path, $selected) = @_;

		ok(ref($selection) eq "Gtk2::TreeSelection" &&
		   ref($model) eq "Gtk2::ListStore" &&
		   ref($path) eq "Gtk2::TreePath");

		return 0;
	});

	$selection -> select_path(Gtk2::TreePath -> new_from_string(1));
	ok($selection -> count_selected_rows() == 0);

	$selection -> set_select_function(sub { return 1; });

	######################################################################

	$selection -> select_path(Gtk2::TreePath -> new_from_string(1));

	$selection -> selected_foreach(sub {
		my ($model, $path, $iterator) = @_;

		ok(ref($model) eq "Gtk2::ListStore" &&
		   ref($path) eq "Gtk2::TreePath" &&
		   ref($iterator) eq "Gtk2::TreeIter");
	});

	######################################################################

	Gtk2 -> main_quit();
	return 0;
});

$window -> add($view);
$window -> show_all();

Gtk2 -> main();
