#
# $Header$
#

use Gtk2::TestHelper
	# FIXME 2.4
	at_least_version => [2, 3, 0, "GtkFileChooser is new in 2.4"],
	tests => 30;
use File::Spec;
use Cwd;

my $file_chooser = Gtk2::FileChooserWidget->new ('save');

isa_ok ($file_chooser, 'Gtk2::FileChooser');

is ($file_chooser->get_action, 'save', 'mode option from construction');

$file_chooser->set_action ('open');
is ($file_chooser->get_action, 'open', 'change action to open');


$file_chooser->set_folder_mode (TRUE);
ok ($file_chooser->get_folder_mode, 'folder mode');

$file_chooser->set_folder_mode (FALSE);
ok (!$file_chooser->get_folder_mode, 'not folder mode');


$file_chooser->set_local_only (TRUE);
ok ($file_chooser->get_local_only, 'local files only');

$file_chooser->set_local_only (FALSE);
ok (!$file_chooser->get_local_only, 'not only local files');


$file_chooser->set_select_multiple (TRUE);
ok ($file_chooser->get_select_multiple, 'select multiple');

# apparently it likes to complain about setting this back.
$file_chooser->set_select_multiple (FALSE);
ok (!$file_chooser->get_select_multiple, 'not select multiple');

# Filename manipulation
#
my $filename = 'something that may not exist';
my $cwd = cwd ();
$file_chooser->set_current_name ('something that may not exist');
is ($file_chooser->get_filename, undef,
    'set current name to something that may not exist');

my $filename = File::Spec->catfile ($cwd, 'gtk2perl.h');
$file_chooser->set_filename ($filename);
is ($file_chooser->get_filename, $filename,
    'set current name to something that does exist');

$file_chooser->select_filename ($filename);
is ($file_chooser->get_filename, $filename, 'select something');
my @list = $file_chooser->get_filenames;
is (scalar (@list), 1, 'selected one thing');
is ($list[0], $filename, 'selected '.$filename);

$file_chooser->unselect_filename ($filename);
@list = $file_chooser->get_filenames;
is (scalar (@list), 0, 'unselected everything');

$file_chooser->set_select_multiple (TRUE);
ok ($file_chooser->get_select_multiple, 'select multiple');

$file_chooser->select_all;
my @list = $file_chooser->get_filenames;
ok (scalar (@list));
$file_chooser->unselect_all;

$filename = File::Spec->catfile ($cwd, 't');
$file_chooser->set_current_folder ($filename);
is ($file_chooser->get_current_folder, $filename);

$file_chooser->set_current_folder ($cwd);
is ($file_chooser->get_current_folder, $cwd);



## URI manipulation
##
my $uri = Glib::filename_to_uri (File::Spec->rel2abs ($0), undef);
$file_chooser->set_uri ($uri);
is ($file_chooser->get_uri, $uri);

$file_chooser->select_uri ($uri);

@list = $file_chooser->get_uris;
ok (scalar (@list), 'selected a uri');

$file_chooser->unselect_uri ($uri);

@list = $file_chooser->get_uris;
ok (!scalar (@list), 'no uris selected');

$file_chooser->set_current_folder_uri ($uri);
is ($file_chooser->get_current_folder_uri, $uri);



## Preview widget
##

my $preview_widget = Gtk2::Frame->new ('whee');
$file_chooser->set_preview_widget ($preview_widget);
is ($file_chooser->get_preview_widget, $preview_widget);

$file_chooser->set_preview_widget_active (FALSE);
ok (!$file_chooser->get_preview_widget_active);

$file_chooser->set_preview_widget_active (TRUE);
ok ($file_chooser->get_preview_widget_active);


# FIXME
#$filename = File::Spec->catfile ($cwd, 'gtk2perl.h');
#$file_chooser->select_filename ($filename);
#is ($file_chooser->get_preview_filename, $filename, 'get_preview_filename');
#is ($file_chooser->get_preview_uri, "file://".$filename, 'get_preview_uri');


# Extra widget

my $extra_widget = Gtk2::Frame->new ('extra widget');
$file_chooser->set_extra_widget ($extra_widget);
is ($file_chooser->get_extra_widget, $extra_widget);

# List of user selectable filters
#
my $filter = Gtk2::FileFilter->new;
$filter->set_name ('fred');
$filter->add_mime_type ('text/plain');

$file_chooser->add_filter ($filter);
@list = $file_chooser->list_filters;
is (scalar (@list), 1, 'list_filters after adding one filter');

$file_chooser->remove_filter ($filter);
@list = $file_chooser->list_filters;
is (scalar (@list), 0, 'list_filters after removing one filter');

## Current filter
##
$file_chooser->set_filter ($filter);
is ($filter, $file_chooser->get_filter);

# FIXME
### Per-application shortcut folders
#
#$file_chooser->add_shortcut_folder (const char *folder);
#$file_chooser->remove_shortcut_folder (const char *folder);
#$file_chooser->add_shortcut_folder_uri (const char *folder);
#$file_chooser->remove_shortcut_folder_uri (const char *folder);

@list = $file_chooser->list_shortcut_folders;
@list = $file_chooser->list_shortcut_folder_uris;
