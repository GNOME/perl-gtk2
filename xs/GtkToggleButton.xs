#include "gtk2perl.h"

MODULE = Gtk2::ToggleButton	PACKAGE = Gtk2::ToggleButton	PREFIX = gtk_toggle_button_

GtkWidget*
gtk_toggle_button_new (class, label=NULL)
	SV * class
	const gchar * label
    CODE:
	if (label)
		RETVAL = gtk_toggle_button_new_with_label (label);
	else
		RETVAL = gtk_toggle_button_new ();
    OUTPUT:
	RETVAL

GtkWidget *
gtk_toggle_button_new_with_label (class, label)
	SV          * class
	const gchar * label
    C_ARGS:
	label

GtkWidget*
gtk_toggle_button_new_with_mnemonic (class, label)
	SV * class
	const gchar *label
    C_ARGS:
	label

void
gtk_toggle_button_set_mode (toggle_button, draw_indicator)
	GtkToggleButton *toggle_button
	gboolean draw_indicator

gboolean
gtk_toggle_button_get_mode (toggle_button)
	GtkToggleButton *toggle_button

void
gtk_toggle_button_set_active (toggle_button, is_active)
	GtkToggleButton *toggle_button
	gboolean is_active

gboolean
gtk_toggle_button_get_active (toggle_button)
	GtkToggleButton *toggle_button

void
gtk_toggle_button_toggled (toggle_button)
	GtkToggleButton *toggle_button

void
gtk_toggle_button_set_inconsistent (toggle_button, setting)
	GtkToggleButton *toggle_button
	gboolean setting

gboolean
gtk_toggle_button_get_inconsistent (toggle_button)
	GtkToggleButton *toggle_button

