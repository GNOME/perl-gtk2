#include "gtk2perl.h"

MODULE = Gtk2::TearoffMenuItem	PACKAGE = Gtk2::TeamoffMenuItem	PREFIX = gtk_teamoff_menu_item_

## GtkWidget* gtk_tearoff_menu_item_new (void)
GtkWidget *
gtk_tearoff_menu_item_new (class)
	SV * class
    C_ARGS:

