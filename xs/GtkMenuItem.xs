/*
 * Copyright (c) 2003 by the gtk2-perl team (see the file AUTHORS)
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Library General Public
 * License as published by the Free Software Foundation; either
 * version 2.1 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Library General Public License for more details.
 *
 * You should have received a copy of the GNU Library General Public
 * License along with this library; if not, write to the 
 * Free Software Foundation, Inc., 59 Temple Place - Suite 330, 
 * Boston, MA  02111-1307  USA.
 *
 * $Header$
 */

#include "gtk2perl.h"

MODULE = Gtk2::MenuItem	PACKAGE = Gtk2::MenuItem	PREFIX = gtk_menu_item_

GtkWidget*
gtk_menu_item_news (class, label=NULL)
	const gchar * label
    ALIAS:
	Gtk2::MenuItem::new = 0
	Gtk2::MenuItem::new_with_mnemonic = 1
	Gtk2::MenuItem::new_with_label = 2
    CODE:
	if (label) {
		if (ix == 2)
			RETVAL = gtk_menu_item_new_with_label (label);
		else
			RETVAL = gtk_menu_item_new_with_mnemonic (label);
	} else
		RETVAL = gtk_menu_item_new ();
    OUTPUT:
	RETVAL

void
gtk_menu_item_set_submenu (menu_item, submenu)
	GtkMenuItem *menu_item
	GtkWidget *submenu

GtkWidget_ornull*
gtk_menu_item_get_submenu (menu_item)
	GtkMenuItem *menu_item

void
gtk_menu_item_remove_submenu (menu_item)
	GtkMenuItem *menu_item

void
gtk_menu_item_select (menu_item)
	GtkMenuItem *menu_item

void
gtk_menu_item_deselect (menu_item)
	GtkMenuItem *menu_item

void
gtk_menu_item_activate (menu_item)
	GtkMenuItem *menu_item

 # FIXME
 ## void gtk_menu_item_toggle_size_request (GtkMenuItem *menu_item, gint *requisition)
 ##void
 ##gtk_menu_item_toggle_size_request (menu_item, requisition)
 ##	GtkMenuItem *menu_item
 ##	gint *requisition

 # FIXME
 ## void gtk_menu_item_toggle_size_allocate (GtkMenuItem *menu_item, gint allocation)
 ##void
 ##gtk_menu_item_toggle_size_allocate (menu_item, allocation)
 ##	GtkMenuItem *menu_item
 ##	gint allocation

void
gtk_menu_item_set_right_justified (menu_item, right_justified)
	GtkMenuItem *menu_item
	gboolean right_justified

gboolean
gtk_menu_item_get_right_justified (menu_item)
	GtkMenuItem *menu_item

void
gtk_menu_item_set_accel_path (menu_item, accel_path)
	GtkMenuItem *menu_item
	const gchar *accel_path

 ##void _gtk_menu_item_refresh_accel_path (GtkMenuItem *menu_item, const gchar *prefix, GtkAccelGroup *accel_group, gboolean group_changed)
