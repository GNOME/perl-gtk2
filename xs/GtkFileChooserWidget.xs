#include "gtk2perl.h"

MODULE = Gtk2::FileChooserWidget	PACKAGE = Gtk2::FileChooserWidget	PREFIX = gtk_file_chooser_widget_

BOOT:
	/* GtkFileChooserWidget implements the GtkFileChooserIface */
	gperl_prepend_isa ("Gtk2::FileChooserWidget", "Gtk2::FileChooser");

GtkWidget *gtk_file_chooser_widget_new (class, GtkFileChooserAction action);
    C_ARGS:
	action

