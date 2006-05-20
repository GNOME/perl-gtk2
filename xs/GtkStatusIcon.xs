/*
 * Copyright (c) 2006 by the gtk2-perl team (see the file AUTHORS)
 *
 * Licensed under the LGPL, see LICENSE file for more information.
 *
 * $Header$
 */

#include "gtk2perl.h"

MODULE = Gtk2::StatusIcon	PACKAGE = Gtk2::StatusIcon	PREFIX = gtk_status_icon_

GtkStatusIcon_noinc *gtk_status_icon_new (class);
    C_ARGS:
        /*void*/

GtkStatusIcon_noinc *gtk_status_icon_new_from_pixbuf (class, GdkPixbuf *pixbuf);
    C_ARGS:
        pixbuf

GtkStatusIcon_noinc *gtk_status_icon_new_from_file (class, GPerlFilename_const filename);
    C_ARGS:
        filename

GtkStatusIcon_noinc *gtk_status_icon_new_from_stock (class, const gchar *stock_id);
    C_ARGS:
        stock_id

GtkStatusIcon_noinc *gtk_status_icon_new_from_icon_name (class, const gchar *icon_name);
    C_ARGS:
        icon_name

void gtk_status_icon_set_from_pixbuf (GtkStatusIcon *status_icon, GdkPixbuf_ornull *pixbuf);

##void gtk_status_icon_set_from_file (GtkStatusIcon *status_icon, const gchar *filename);
void gtk_status_icon_set_from_file (GtkStatusIcon *status_icon, GPerlFilename_const filename);

void gtk_status_icon_set_from_stock (GtkStatusIcon *status_icon, const gchar *stock_id);

void gtk_status_icon_set_from_icon_name (GtkStatusIcon *status_icon, const gchar *icon_name);

GtkImageType gtk_status_icon_get_storage_type (GtkStatusIcon *status_icon);

GdkPixbuf_ornull *gtk_status_icon_get_pixbuf (GtkStatusIcon *status_icon);

const gchar_ornull *gtk_status_icon_get_stock (GtkStatusIcon *status_icon);

const gchar_ornull *gtk_status_icon_get_icon_name (GtkStatusIcon *status_icon);

gint gtk_status_icon_get_size (GtkStatusIcon *status_icon);

void gtk_status_icon_set_tooltip (GtkStatusIcon *status_icon, const gchar_ornull *tooltip_text);

void gtk_status_icon_set_visible (GtkStatusIcon *status_icon, gboolean visible);

gboolean gtk_status_icon_get_visible (GtkStatusIcon *status_icon);

void gtk_status_icon_set_blinking (GtkStatusIcon *status_icon, gboolean blinking);

gboolean gtk_status_icon_get_blinking (GtkStatusIcon *status_icon);

gboolean gtk_status_icon_is_embedded (GtkStatusIcon *status_icon);

=for apidoc __function__
This function can be used as the I<menu_pos_func> argument to
I<Gtk2::Menu::popup>.
=cut
##void gtk_status_icon_position_menu (GtkMenu *menu, gint *x, gint *y, gboolean *push_in, gpointer user_data)
void
gtk_status_icon_position_menu (GtkMenu *menu, gint x, gint y, GtkStatusIcon *icon)
    PREINIT:
	gboolean push_in;
    PPCODE:
	gtk_status_icon_position_menu (menu, &x, &y, &push_in, icon);
	EXTEND (sp, 3);
	PUSHs (sv_2mortal (newSViv (x)));
	PUSHs (sv_2mortal (newSViv (y)));
	PUSHs (sv_2mortal (newSVuv (push_in)));
