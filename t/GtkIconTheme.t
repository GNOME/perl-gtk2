#
# $Header$
#

use Gtk2::TestHelper
	# FIXME 2.4
	at_least_version => [2, 3, 0, "GtkIconTheme is new in 2.4"],
	tests => 1, noinit => 1;

SKIP: { skip "NOT IMPLEMENTED", 1; }
__END__

my $icon_theme = Gtk2::IconTheme->new;
isa_ok ($icon_theme, 'Gtk2::IconTheme');

$icon_theme = Gtk2::IconTheme->get_default;

$icon_theme = Gtk2::IconTheme->get_for_screen (GdkScreen *screen);

$icon_theme->set_screen (GdkScreen *screen);

$icon_theme->set_search_path (@paths)

my @paths = $icon_theme->get_search_path

$icon_theme->append_search_path (GPerlFilename_const path);

$icon_theme->prepend_search_path (GPerlFilename_const path);

$icon_theme->set_custom_theme (const gchar *theme_name);

gboolean $icon_theme->has_icon (const gchar *icon_name);

GtkIconInfo_own_ornull = $icon_theme->lookup_icon (const gchar *icon_name, gint size, GtkIconLookupFlags flags);

GdkPixbuf_ornull = $icon_theme->load_icon (const gchar *icon_name, gint size, GtkIconLookupFlags flags)

my @icons = $icon_theme->list_icons (const char * context)

 ## char * $icon_theme->get_example_icon_name (GtkIconTheme *icon_theme);
gchar_own = $icon_theme->get_example_icon_name;

gboolean = $icon_theme->rescan_if_needed

$icon_theme->add_builtin_icon (const gchar *icon_name, gint size, GdkPixbuf *pixbuf);



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

