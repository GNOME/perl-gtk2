#include "gtk2perl.h"

MODULE = Gtk2::EventBox	PACKAGE = Gtk2::EventBox	PREFIX = gtk_event_box_

## GtkWidget* gtk_event_box_new (void)
GtkWidget *
gtk_event_box_new (class)
	SV * class
    C_ARGS:

