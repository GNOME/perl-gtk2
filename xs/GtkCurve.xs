/*
 * $Header$
 */

#include "gtk2perl.h"

MODULE = Gtk2::Curve	PACKAGE = Gtk2::Curve	PREFIX = gtk_curve_

## GtkWidget* gtk_curve_new (void)
GtkWidget *
gtk_curve_new (class)
	SV * class
    C_ARGS:

## void gtk_curve_reset (GtkCurve *curve)
void
gtk_curve_reset (curve)
	GtkCurve * curve

## void gtk_curve_set_gamma (GtkCurve *curve, gfloat gamma)
void
gtk_curve_set_gamma (curve, gamma)
	GtkCurve * curve
	gfloat     gamma

## void gtk_curve_set_range (GtkCurve *curve, gfloat min_x, gfloat max_x, gfloat min_y, gfloat max_y)
void
gtk_curve_set_range (curve, min_x, max_x, min_y, max_y)
	GtkCurve * curve
	gfloat     min_x
	gfloat     max_x
	gfloat     min_y
	gfloat     max_y

## void gtk_curve_get_vector (GtkCurve *curve, int veclen, gfloat vector[])
void
gtk_curve_get_vector (curve, veclen=32)
	GtkCurve * curve
	int        veclen
    PREINIT:
	gint     i;
	gfloat * vector;
    PPCODE:
	if( veclen < 1 )
		croak("ERROR: gtk_curve_get_vector: veclen must be greater "
		      "zero");
	vector = g_new(gfloat, veclen);
	gtk_curve_get_vector(curve, veclen, vector);
	EXTEND(SP, veclen);
	for( i = 0; i < veclen; i++ )
		PUSHs(sv_2mortal(newSVnv(vector[i])));
	g_free(vector);

## void gtk_curve_set_vector (GtkCurve *curve, int veclen, gfloat vector[])
void
gtk_curve_set_vector (curve, ...)
	GtkCurve * curve
    PREINIT:
	int      veclen;
	gfloat * vector;
    CODE:
	veclen = --items;
	vector = g_new(gfloat, veclen);
	for( ; items > 0; items-- )
		vector[items-1] = SvNV(ST(items));
	gtk_curve_set_vector(curve, veclen, vector);
	g_free(vector);

## void gtk_curve_set_curve_type (GtkCurve *curve, GtkCurveType type)
void
gtk_curve_set_curve_type (curve, type)
	GtkCurve     * curve
	GtkCurveType   type
    CODE:
	/* there's a bug in gtk2 that causes a core dump if set_curve_type is
	 * called before the widget is realized, they won't fix it so i'll
         * catch and prevent it here. */
	g_return_if_fail(GTK_WIDGET_REALIZED(curve));
	gtk_curve_set_curve_type(curve, type);

