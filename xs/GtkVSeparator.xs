/*
 * $Header$
 */

#include "gtk2perl.h"

MODULE = Gtk2::VSeparator	PACKAGE = Gtk2::VSeparator	PREFIX = gtk_vseparator_

## GtkWidget* gtk_vseparator_new (void)
GtkWidget *
gtk_vseparator_new (class)
	SV * class
    C_ARGS:

