#include "gtk2perl.h"

MODULE = Gtk2::VScrollBar	PACKAGE = Gtk2::VScrollBar	PREFIX = gtk_vscrollbar_

## GtkWidget* gtk_vscrollbar_new (GtkAdjustment *adjustment)
GtkWidget *
gtk_vscrollbar_new (class, adjustment)
	SV            * class
	GtkAdjustment * adjustment
    C_ARGS:
	adjustment

