/* 
 * Copyright (C) 2003 by the gtk2-perl team (see the file AUTHORS for a
 * complete listing)
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with this library; if not, write to the
 * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
 * Boston, MA 02111-1307, USA.
 */

#include "gtk2perl.h"

MODULE = Gtk2::IconTheme	PACKAGE = Gtk2::IconTheme	PREFIX = gtk_icon_theme_

GtkIconTheme_noinc * gtk_icon_theme_new (class)
    C_ARGS:
	/*void*/

GtkIconTheme *gtk_icon_theme_get_default (class)
    C_ARGS:
	/*void*/

GtkIconTheme * gtk_icon_theme_get_for_screen (class, GdkScreen *screen)
    C_ARGS:
	screen

void gtk_icon_theme_set_screen (GtkIconTheme *icon_theme, GdkScreen *screen);

 ## void gtk_icon_theme_set_search_path (GtkIconTheme *icon_theme, const gchar *path[], gint n_elements);
void gtk_icon_theme_set_search_path (GtkIconTheme *icon_theme, ...)
    PREINIT:
	const gchar ** path = NULL;
	gint n_elements, i;
    CODE:
	n_elements = items - 1;
	path = gperl_alloc_temp (sizeof (gchar*) * n_elements + 1);
	for (i = 0 ; i < n_elements ; i++)
		path[i] = gperl_filename_from_sv (ST (i + 1));
	gtk_icon_theme_set_search_path (icon_theme, path, n_elements);

 ## void gtk_icon_theme_get_search_path (GtkIconTheme *icon_theme, gchar **path[], gint *n_elements);
void gtk_icon_theme_get_search_path (GtkIconTheme *icon_theme)
    PREINIT:
	gchar ** path = NULL;
	gint n_elements, i;
    PPCODE:
	gtk_icon_theme_get_search_path (icon_theme, &path, &n_elements);
	EXTEND (SP, n_elements);
	for (i = 0; i < n_elements; i++)
		PUSHs (sv_2mortal (gperl_sv_from_filename (path[i])));
	g_strfreev (path);

 ## void gtk_icon_theme_append_search_path (GtkIconTheme *icon_theme, const gchar *path);
void gtk_icon_theme_append_search_path (GtkIconTheme *icon_theme, GPerlFilename_const path);

 ## void gtk_icon_theme_prepend_search_path (GtkIconTheme *icon_theme, const gchar *path);
void gtk_icon_theme_prepend_search_path (GtkIconTheme *icon_theme, GPerlFilename_const path);

void gtk_icon_theme_set_custom_theme (GtkIconTheme *icon_theme, const gchar *theme_name);

gboolean gtk_icon_theme_has_icon (GtkIconTheme *icon_theme, const gchar *icon_name);

GtkIconInfo_own_ornull * gtk_icon_theme_lookup_icon (GtkIconTheme *icon_theme, const gchar *icon_name, gint size, GtkIconLookupFlags flags);

 ## GdkPixbuf * gtk_icon_theme_load_icon (GtkIconTheme *icon_theme, const gchar *icon_name, gint size, GtkIconLookupFlags flags, GError **error);
GdkPixbuf_ornull * gtk_icon_theme_load_icon (GtkIconTheme *icon_theme, const gchar *icon_name, gint size, GtkIconLookupFlags flags)
    PREINIT:
	GError * error = NULL;
    CODE:
	RETVAL = gtk_icon_theme_load_icon (icon_theme, icon_name, size,
	                                   flags, &error);
	if (!RETVAL)
		gperl_croak_gerror (NULL, error);
    OUTPUT:
	RETVAL

 ## GList * gtk_icon_theme_list_icons (GtkIconTheme *icon_theme, const gchar *context);
void
gtk_icon_theme_list_icons (GtkIconTheme * icon_theme, const char * context)
    PREINIT:
	GList * list, * i;
    PPCODE:
	list = gtk_icon_theme_list_icons (icon_theme, context);
	for (i = list ; i != NULL ; i = i->next) {
		XPUSHs (sv_2mortal (newSVGChar (i->data)));
		g_free (i->data);
	}
	g_list_free (list);

 ## char * gtk_icon_theme_get_example_icon_name (GtkIconTheme *icon_theme);
gchar_own * gtk_icon_theme_get_example_icon_name (GtkIconTheme *icon_theme);

gboolean gtk_icon_theme_rescan_if_needed (GtkIconTheme *icon_theme);

void gtk_icon_theme_add_builtin_icon (class, const gchar *icon_name, gint size, GdkPixbuf *pixbuf);
    C_ARGS:
	icon_name, size, pixbuf

MODULE = Gtk2::IconTheme	PACKAGE = Gtk2::IconInfo	PREFIX = gtk_icon_info_

 ## don't need to bind these -- they are automagical
 ## GType gtk_icon_info_get_type (void);
 ## GtkIconInfo *gtk_icon_info_copy (GtkIconInfo *icon_info);
 ## void gtk_icon_info_free (GtkIconInfo *icon_info);

gint gtk_icon_info_get_base_size (GtkIconInfo *icon_info);

const gchar *gtk_icon_info_get_filename (GtkIconInfo *icon_info);

GdkPixbuf * gtk_icon_info_get_builtin_pixbuf (GtkIconInfo *icon_info);

 ## GdkPixbuf * gtk_icon_info_load_icon (GtkIconInfo *icon_info, GError **error);
GdkPixbuf * gtk_icon_info_load_icon (GtkIconInfo *icon_info)
    PREINIT:
	GError *error = NULL;
    CODE:
	RETVAL = gtk_icon_info_load_icon (icon_info, &error);
	if (!RETVAL)
		gperl_croak_gerror (NULL, error);
    OUTPUT:
	RETVAL

void gtk_icon_info_set_raw_coordinates (GtkIconInfo *icon_info, gboolean raw_coordinates);

 ## gboolean gtk_icon_info_get_embedded_rect (GtkIconInfo *icon_info, GdkRectangle *rectangle);
GdkRectangle_copy *
gtk_icon_info_get_embedded_rect (GtkIconInfo *icon_info)
    PREINIT:
	GdkRectangle rectangle;
    CODE:
	if (!gtk_icon_info_get_embedded_rect (icon_info, &rectangle))
		XSRETURN_UNDEF;
	RETVAL = &rectangle;
    OUTPUT:
	RETVAL

 ## gboolean gtk_icon_info_get_attach_points (GtkIconInfo *icon_info, GdkPoint **points, gint *n_points);
=for apidoc

Returns the attach points as an interleaved list of x and y coordinates.

=cut
void
gtk_icon_info_get_attach_points (GtkIconInfo *icon_info)
    PREINIT:
	GdkPoint *points = NULL;
	gint n_points;
    PPCODE:
	if (gtk_icon_info_get_attach_points (icon_info, &points, &n_points)) {
		int i;
		EXTEND (SP, n_points * 2);
		for (i = 0 ; i < n_points ; i++) {
			PUSHs (sv_2mortal (newSViv (points[i].x)));
			PUSHs (sv_2mortal (newSViv (points[i].y)));
		}
		g_free (points);
	}

const gchar *gtk_icon_info_get_display_name (GtkIconInfo *icon_info);

