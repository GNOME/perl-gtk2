/*
 * $Header$
 */

#include "gtk2perl.h"

MODULE = Gtk2::InputDialog	PACKAGE = Gtk2::InputDialog	PREFIX = gtk_input_dialog_

## GtkWidget* gtk_input_dialog_new (void)
GtkWidget *
gtk_input_dialog_new (class)
	SV * class
    C_ARGS:

