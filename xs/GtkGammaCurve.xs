#include "gtk2perl.h"

MODULE = Gtk2::GammaCurve	PACKAGE = Gtk2::GammaCurve	PREFIX = gtk_gamma_curve_

## GtkWidget* gtk_gamma_curve_new (void)
GtkWidget *
gtk_gamma_curve_new (class)
	SV * class
    C_ARGS:

GtkCurve *
curve (gamma)
	GtkGammaCurve * gamma
    CODE:
	RETVAL = (GtkCurve*)gamma->curve;
    OUTPUT:
	RETVAL
