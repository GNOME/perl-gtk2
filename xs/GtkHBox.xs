/*
 * $Header$
 */

#include "gtk2perl.h"

MODULE = Gtk2::HBox	PACKAGE = Gtk2::HBox	PREFIX = gtk_hbox_

GtkWidget*
gtk_hbox_new (class, homogeneous, spacing)
	SV * class
	gboolean homogeneous
	gint spacing
    C_ARGS:
	homogeneous, spacing

