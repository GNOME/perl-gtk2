#include "gtk2perl.h"

MODULE = Gtk2::HScrollBar	PACKAGE = Gtk2::HScrollBar	PREFIX = gtk_hscrollbar_

## GtkWidget* gtk_hscrollbar_new (GtkAdjustment *adjustment)
GtkWidget *
gtk_hscrollbar_new (class, adjustment)
	SV            * class
	GtkAdjustment * adjustment
    C_ARGS:
	adjustment

