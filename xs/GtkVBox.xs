/*
 * $Header$
 */

#include "gtk2perl.h"

MODULE = Gtk2::VBox	PACKAGE = Gtk2::VBox	PREFIX = gtk_vbox_

GtkWidget*
gtk_vbox_new (class, homogeneous=0, spacing=5)
	SV * class
	gboolean homogeneous
	gint spacing
    C_ARGS:
	homogeneous, spacing

