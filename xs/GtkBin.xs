#include "gtk2perl.h"

MODULE = Gtk2::Bin	PACKAGE = Gtk2::Bin	PREFIX = gtk_bin_

GtkWidget *
child (bin)
	GtkBin * bin
    CODE:
	RETVAL = gtk_bin_get_child (bin);
    OUTPUT:
	RETVAL

GtkWidget *
gtk_bin_get_child (bin)
	GtkBin * bin

