/*
 * $Header$
 */

#include "gtk2perl.h"

MODULE = Gtk2::HRuler	PACKAGE = Gtk2::HRuler	PREFIX = gtk_hruler_

## GtkWidget* gtk_hruler_new (void)
GtkWidget *
gtk_hruler_new (class)
	SV * class
    C_ARGS:

