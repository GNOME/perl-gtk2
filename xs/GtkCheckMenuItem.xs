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

MODULE = Gtk2::CheckMenuItem	PACKAGE = Gtk2::CheckMenuItem	PREFIX = gtk_check_menu_item_

## GtkWidget* gtk_check_menu_item_new (void)
## GtkWidget* gtk_check_menu_item_new_with_mnemonic (const gchar *label)
## GtkWidget* gtk_check_menu_item_new_with_label (const gchar *label)
GtkWidget *
gtk_check_menu_item_news (class, label=NULL)
	const gchar * label
    ALIAS:
	Gtk2::CheckMenuItem::new = 0
	Gtk2::CheckMenuItem::new_with_mnemonic = 1
	Gtk2::CheckMenuItem::new_with_label = 2
    CODE:
	if (label) {
		if (ix == 2) 
			RETVAL = gtk_check_menu_item_new_with_label (label);
		else
			RETVAL = gtk_check_menu_item_new_with_mnemonic (label);
	} else
		RETVAL = gtk_check_menu_item_new ();
    OUTPUT:
	RETVAL

## void gtk_check_menu_item_set_active (GtkCheckMenuItem *check_menu_item, gboolean is_active)
void
gtk_check_menu_item_set_active (check_menu_item, is_active)
	GtkCheckMenuItem * check_menu_item
	gboolean           is_active

## gboolean gtk_check_menu_item_get_active (GtkCheckMenuItem *check_menu_item)
gboolean
gtk_check_menu_item_get_active (check_menu_item)
	GtkCheckMenuItem * check_menu_item

## void gtk_check_menu_item_toggled (GtkCheckMenuItem *check_menu_item)
void
gtk_check_menu_item_toggled (check_menu_item)
	GtkCheckMenuItem * check_menu_item

## void gtk_check_menu_item_set_inconsistent (GtkCheckMenuItem *check_menu_item, gboolean setting)
void
gtk_check_menu_item_set_inconsistent (check_menu_item, setting)
	GtkCheckMenuItem * check_menu_item
	gboolean setting

## gboolean gtk_check_menu_item_get_inconsistent (GtkCheckMenuItem *check_menu_item)
gboolean
gtk_check_menu_item_get_inconsistent (check_menu_item)
	GtkCheckMenuItem * check_menu_item

## void gtk_check_menu_item_set_show_toggle (GtkCheckMenuItem *menu_item, gboolean always)
void
gtk_check_menu_item_set_show_toggle (menu_item, always)
	GtkCheckMenuItem * menu_item
	gboolean           always

