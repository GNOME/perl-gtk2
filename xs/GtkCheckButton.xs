/*
 * $Header$
 */

#include "gtk2perl.h"

MODULE = Gtk2::CheckButton	PACKAGE = Gtk2::CheckButton	PREFIX = gtk_check_button_

## GtkWidget* gtk_check_button_new (void)
## GtkWidget* gtk_check_button_new_with_mnemonic (const gchar *label)
GtkWidget*
gtk_check_button_news (class, label=NULL)
	SV * class
	const gchar * label
    ALIAS:
	Gtk2::CheckButton::new = 0
	Gtk2::CheckButton::new_with_mnemonic = 1
    CODE:
	if (label)
		RETVAL = gtk_check_button_new_with_mnemonic (label);
	else
		RETVAL = gtk_check_button_new ();
    OUTPUT:
	RETVAL

## GtkWidget* gtk_check_button_new_with_label (const gchar *label)
GtkWidget *
gtk_check_button_new_with_label (class, label)
	SV          * class
	const gchar * label
    C_ARGS:
	label

## void _gtk_check_button_get_props (GtkCheckButton *check_button, gint *indicator_size, gint *indicator_spacing)
#void
#_gtk_check_button_get_props (check_button, indicator_size, indicator_spacing)
#	GtkCheckButton * check_button
#	gint           * indicator_size
#	gint           * indicator_spacing

