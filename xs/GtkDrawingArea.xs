/*
 * $Header$
 */

#include "gtk2perl.h"

MODULE = Gtk2::DrawingArea	PACKAGE = Gtk2::DrawingArea	PREFIX = gtk_drawing_area_

## GtkWidget* gtk_drawing_area_new (void)
GtkWidget *
gtk_drawing_area_new (class)
	SV * class
    C_ARGS:

## void gtk_drawing_area_size (GtkDrawingArea *darea, gint width, gint height)
void
gtk_drawing_area_size (darea, width, height)
	GtkDrawingArea * darea
	gint             width
	gint             height

