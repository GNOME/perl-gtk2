#
# $Header$
#

use Gtk2::TestHelper
	# FIXME 2.4
	at_least_version => [2, 3, 0, "GtkIconTheme is new in 2.4"],
	tests => 11;

my $icon_theme = Gtk2::IconTheme->new;
isa_ok ($icon_theme, 'Gtk2::IconTheme');

$icon_theme = Gtk2::IconTheme->get_default;
isa_ok ($icon_theme, 'Gtk2::IconTheme');

$icon_theme = Gtk2::IconTheme->get_for_screen (Gtk2::Gdk::Screen->get_default);
isa_ok ($icon_theme, 'Gtk2::IconTheme');

$icon_theme->set_screen (Gtk2::Gdk::Screen->get_default);

ok ($icon_theme->list_icons (undef));

SKIP: {
	skip "the search path api was broken prior to 2.3.3", 3
		if Gtk2->check_version(2, 3, 3);
	
	my @paths = qw(/tmp /etc /home);
	$icon_theme->set_search_path (@paths);
	
	is_deeply ([$icon_theme->get_search_path], \@paths);
	
	$icon_theme->append_search_path ('/usr/local/tmp');
	push @paths, '/usr/local/tmp';
	is_deeply ([$icon_theme->get_search_path], \@paths);
	
	$icon_theme->prepend_search_path ('/usr/tmp');
	unshift @paths, '/usr/tmp';
	is_deeply ([$icon_theme->get_search_path], \@paths);
}

ok (!$icon_theme->has_icon ('gtk-open'));
ok (!$icon_theme->has_icon ('something crazy'));

# cannot call set_custom_theme on a default theme
$icon_theme = Gtk2::IconTheme->new;
$icon_theme->set_custom_theme ('crazy custom theme');

is ($icon_theme->get_example_icon_name, undef);

##GtkIconInfo_own_ornull = $icon_theme->lookup_icon (const gchar *icon_name, gint size, GtkIconLookupFlags flags);
##
##GdkPixbuf_ornull = $icon_theme->load_icon (const gchar *icon_name, gint size, GtkIconLookupFlags flags);

ok (!$icon_theme->rescan_if_needed);

##$icon_theme->add_builtin_icon (const gchar *icon_name, gint size, GdkPixbuf *pixbuf);


__END__

gint = $icon_info->get_base_size

const gchar * = $icon_info->get_filename

GdkPixbuf * = $icon_info->get_builtin_pixbuf

GdkPixbuf * = $icon_info->load_icon

$icon_info->set_raw_coordinates (gboolean raw_coordinates);

GdkRectangle_copy * = $icon_info->get_embedded_rect

 ## gboolean $icon_info->get_attach_points (GtkIconInfo *icon_info, GdkPoint **points, gint *n_points);
=for apidoc

Returns the attach points as an interleaved list of x and y coordinates.

=cut
my @points = $icon_info->get_attach_points;

const gchar * = $icon_info->get_display_name

