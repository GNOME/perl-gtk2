#include "gtk2perl.h"

MODULE = Gtk2::HScale	PACKAGE = Gtk2::HScale	PREFIX = gtk_hscale_

## GtkWidget* gtk_hscale_new (GtkAdjustment *adjustment)
GtkWidget *
gtk_hscale_new (class, adjustment)
	SV            * class
	GtkAdjustment * adjustment
    C_ARGS:
	adjustment

## GtkWidget* gtk_hscale_new_with_range (gdouble min, gdouble max, gdouble step)
GtkWidget *
gtk_hscale_new_with_range (min, max, step)
	gdouble min
	gdouble max
	gdouble step

