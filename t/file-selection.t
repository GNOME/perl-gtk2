

use Test::More;

use Gtk2;
use Cwd;
use File::Spec;

if (Gtk2->init_check) {
	plan (tests => 3);
} else {
	plan (skip_all => "can't open display");
}

$basename = "Makefile.PL";

$fs = Gtk2::FileSelection->new ('bogo');
$fs->set_filename ($basename);
$fs->show;

Glib::Idle->add (sub { $fs->activate_default; 0 });
$response = $fs->run;

# TODO it would be nice to have some tests that use funny filenames...

is ($response, 'ok', 'default is ok');

#
# WARNING: i tried to write this portably, but have not tested it
#          on anything but linux.
#

$expect = File::Spec->catfile (cwd (), $basename);
is ($fs->get_filename, $expect, 'what we want');


$fs->set_select_multiple (1);
# select all the files in this directory...
$sel = $fs->file_list->get_selection;
# on 2.0.x, $sel->select_all causes a core dump in the filesel's
# internal select-all handler, unless i first select at least one
# row.  i don't understand, but it does not happen in 2.2.x.
$sel->select_path (Gtk2::TreePath->new_from_string ("0"))
	if (Gtk2->get_version_info)[1] < 2;
$sel->select_all;
$nfiles = $sel->count_selected_rows;
Glib::Idle->add (sub { $fs->activate_default; 0 });
$response = $fs->run;
@files = $fs->get_selections;
is (scalar (@files), $nfiles, 'we got back as many as were selected');
