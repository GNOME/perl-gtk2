#include "gtk2perl.h"

MODULE = Gtk2::OptionMenu	PACKAGE = Gtk2::OptionMenu	PREFIX = gtk_option_menu_

GtkWidget *
gtk_option_menu_new (class)
	SV * class
    C_ARGS:


GtkWidget *
gtk_option_menu_get_menu (option_menu)
	GtkOptionMenu * option_menu

void
gtk_option_menu_set_menu (option_menu, menu)
	GtkOptionMenu * option_menu
	GtkWidget     * menu

void
gtk_option_menu_remove_menu (option_menu)
	GtkOptionMenu *option_menu

gint
gtk_option_menu_get_history (option_menu)
	GtkOptionMenu *option_menu

void
gtk_option_menu_set_history (option_menu, index)
	GtkOptionMenu *option_menu
	guint index

