/*
 * $Header$
 */

#include "gtk2perl.h"

MODULE = Gtk2::MenuBar	PACKAGE = Gtk2::MenuBar	PREFIX = gtk_menu_bar_

## GtkWidget* gtk_menu_bar_new (void)
GtkWidget *
gtk_menu_bar_new (class)
	SV * class
    C_ARGS:

##void _gtk_menu_bar_cycle_focus (GtkMenuBar *menubar, GtkDirectionType dir
