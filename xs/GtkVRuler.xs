#include "gtk2perl.h"

MODULE = Gtk2::VRuler	PACKAGE = Gtk2::VRuler	PREFIX = gtk_vruler_

## GtkWidget* gtk_vruler_new (void)
GtkWidget *
gtk_vruler_new (class)
	SV * class
    C_ARGS:

