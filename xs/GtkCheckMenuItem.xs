/*
 * $Header$
 */

#include "gtk2perl.h"

MODULE = Gtk2::CheckMenuItem	PACKAGE = Gtk2::CheckMenuItem	PREFIX = gtk_check_menu_item_

## GtkWidget* gtk_check_menu_item_new (void)
## GtkWidget* gtk_check_menu_item_new_with_mnemonic (const gchar *label)
GtkWidget *
gtk_check_menu_item_news (class, label=NULL)
	SV          * class
	const gchar * label
    ALIAS:
	Gtk2::CheckMenuItem::new = 0
	Gtk2::CheckMenuItem::new_with_mnemonic = 1
    CODE:
	if (label)
		RETVAL = gtk_check_menu_item_new_with_mnemonic (label);
	else
		RETVAL = gtk_check_menu_item_new ();
    OUTPUT:
	RETVAL

## GtkWidget* gtk_check_menu_item_new_with_label (const gchar *label)
GtkWidget *
gtk_check_menu_item_new_with_label (class, label)
	SV          * class
	const gchar * label
    C_ARGS:
	label

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

