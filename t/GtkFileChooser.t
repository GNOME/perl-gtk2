#
# $Header$
#

use Gtk2::TestHelper
	# FIXME 2.4
	at_least_version => [2, 3, 0, "GtkFileChooser is new in 2.4"],
	tests => 37;
use File::Spec;
use Cwd;

my $file_chooser = Gtk2::FileChooserWidget->new ('save');

isa_ok ($file_chooser, 'Gtk2::FileChooser');

is ($file_chooser->get_action, 'save', 'mode option from construction');


$file_chooser->set_local_only (TRUE);
ok ($file_chooser->get_local_only, 'local files only');

$file_chooser->set_local_only (FALSE);
ok (!$file_chooser->get_local_only, 'not only local files');

# apparently it likes to complain about setting this back.
$file_chooser->set_select_multiple (FALSE);
ok (!$file_chooser->get_select_multiple, 'not select multiple');

# Filename manipulation
#
my $filename = 'something that may not exist';
my $cwd = cwd ();

$file_chooser->set_current_name ('something that may not exist');
is ($file_chooser->get_filename,
    $cwd . "/" . 'something that may not exist',
    'set current name');

$file_chooser->set_action ('open');
is ($file_chooser->get_action, 'open', 'change action to open');

#ok (!$file_chooser->set_filename ('/something bogus'));
$filename = File::Spec->catfile ($cwd, 'gtk2perl.h');
ok ($file_chooser->set_filename ($filename),
    'set filename to something that exists');
is ($file_chooser->get_filename, $filename,
    'set current name to something that does exist');


#ok (!$file_chooser->select_filename ('/something bogus'));
ok ($file_chooser->select_filename ($filename));
is ($file_chooser->get_filename, $filename, 'select something');
my @list = $file_chooser->get_filenames;
is (scalar (@list), 1, 'selected one thing');
is ($list[0], $filename, 'selected '.$filename);

$file_chooser->set_select_multiple (TRUE);
ok ($file_chooser->get_select_multiple, 'select multiple');

$file_chooser->select_all;
@list = $file_chooser->get_filenames;
ok (scalar (@list));
$file_chooser->unselect_all;

$filename = File::Spec->catfile ($cwd, 'nonexistent');
ok (!$file_chooser->set_current_folder ($filename),
    'set_current_folder fails when the folder does not exist');

$filename = File::Spec->catfile ($cwd, 't');
ok ($file_chooser->set_current_folder ($filename));
is ($file_chooser->get_current_folder, $filename);

$file_chooser->set_current_folder ($cwd);
is ($file_chooser->get_current_folder, $cwd);



## URI manipulation
##
#ok (!$file_chooser->set_uri (Glib::filename_to_uri ('/bogus', undef)));
#ok (!$file_chooser->select_uri (Glib::filename_to_uri ('/bogus', undef)));

my $uri = Glib::filename_to_uri (File::Spec->rel2abs ($0), undef);
ok ($file_chooser->set_uri ($uri));
is ($file_chooser->get_uri, $uri);

ok ($file_chooser->select_uri ($uri));

@list = $file_chooser->get_uris;
ok (scalar (@list), 'selected a uri');

$file_chooser->unselect_uri ($uri);

ok ($file_chooser->set_current_folder_uri ($uri));
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

$file_chooser->set_use_preview_label (1);
is ($file_chooser->get_use_preview_label, 1);


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

# Per-application shortcut folders
#
$file_chooser->add_shortcut_folder ($cwd);
$file_chooser->add_shortcut_folder_uri ("file://" . $cwd);

SKIP: {
	skip "list_shortcut_folders, get_uris, and get_filenames were broken prior to 2.3.5", 4
		unless Gtk2->CHECK_VERSION (2, 3, 5);

	is_deeply ([$file_chooser->list_shortcut_folders], [$cwd, $cwd]);
	is_deeply ([$file_chooser->list_shortcut_folder_uris], ["file://" . $cwd, "file://" . $cwd]);

	@list = $file_chooser->get_uris;
	ok (!scalar (@list), 'no uris selected');

	$file_chooser->unselect_filename ($filename);
	@list = $file_chooser->get_filenames;
	is (scalar (@list), 0, 'unselected everything');
}

$file_chooser->remove_shortcut_folder ($cwd);
$file_chooser->remove_shortcut_folder_uri ($cwd);

__END__

Copyright (C) 2003 by the gtk2-perl team (see the file AUTHORS for the
full list).  See LICENSE for more information.
