#include "gtk2perl.h"

MODULE = Gtk2::VScale	PACKAGE = Gtk2::VScale	PREFIX = gtk_vscale_

## GtkWidget* gtk_vscale_new (GtkAdjustment *adjustment)
GtkWidget *
gtk_vscale_new (class, adjustment)
	SV            * class
	GtkAdjustment * adjustment
    C_ARGS:
	adjustment

## GtkWidget* gtk_vscale_new_with_range (gdouble min, gdouble max, gdouble step)
GtkWidget *
gtk_vscale_new_with_range (min, max, step)
	gdouble min
	gdouble max
	gdouble step

