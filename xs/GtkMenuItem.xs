/*
 * $Header$
 */

#include "gtk2perl.h"

MODULE = Gtk2::MenuItem	PACKAGE = Gtk2::MenuItem	PREFIX = gtk_menu_item_

GtkWidget*
gtk_menu_item_new (class, label=NULL)
	SV * class
	const gchar * label
    CODE:
	if (label)
		RETVAL = gtk_menu_item_new_with_label (label);
	else
		RETVAL = gtk_menu_item_new ();
    OUTPUT:
	RETVAL

GtkWidget*
gtk_menu_item_new_with_label (class, label)
	SV * class
	const gchar *label
    C_ARGS:
	label

GtkWidget*
gtk_menu_item_new_with_mnemonic (class, label)
	SV * class
	const gchar *label
    C_ARGS:
	label

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

 ## void gtk_menu_item_toggle_size_request (GtkMenuItem *menu_item, gint *requisition)
 ##void
 ##gtk_menu_item_toggle_size_request (menu_item, requisition)
 ##	GtkMenuItem *menu_item
 ##	gint *requisition

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

 ## void gtk_menu_item_set_accel_path (GtkMenuItem *menu_item, const gchar *accel_path)
 ##void
 ##gtk_menu_item_set_accel_path (menu_item, accel_path)
 ##	GtkMenuItem *menu_item
 ##	const gchar *accel_path

 ##void _gtk_menu_item_refresh_accel_path (GtkMenuItem *menu_item, const gchar *prefix, GtkAccelGroup *accel_group, gboolean group_changed)
