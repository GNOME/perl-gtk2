#include "gtk2perl.h"

MODULE = Gtk2::SeparatorMenuItem	PACKAGE = Gtk2::SeparatorMenuItem	PREFIX = gtk_separator_menu_item_

## GtkWidget* gtk_separator_menu_item_new (void)
GtkWidget *
gtk_separator_menu_item_new (class)
	SV * class
    C_ARGS:

