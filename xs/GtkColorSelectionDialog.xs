/*
 * $Header$
 */

#include "gtk2perl.h"

MODULE = Gtk2::ColorSelectionDialog	PACKAGE = Gtk2::ColorSelectionDialog	PREFIX = gtk_color_selection_dialog_


GtkWidget * colorsel (GtkColorSelectionDialog * dialog)
    CODE:
	RETVAL = dialog->colorsel;
    OUTPUT:
	RETVAL


## GtkWidget* gtk_color_selection_dialog_new (const gchar *title)
GtkWidget *
gtk_color_selection_dialog_new (class, title)
	SV          * class
	const gchar * title
    C_ARGS:
	title

