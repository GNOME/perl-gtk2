#include "gtk2perl.h"

MODULE = Gtk2::HSeparator	PACKAGE = Gtk2::HSeparator	PREFIX = gtk_hseparator_

## GtkWidget* gtk_hseparator_new (void)
GtkWidget *
gtk_hseparator_new (class)
	SV * class
    C_ARGS:

