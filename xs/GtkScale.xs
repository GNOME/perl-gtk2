#include "gtk2perl.h"

MODULE = Gtk2::Scale	PACKAGE = Gtk2::Scale	PREFIX = gtk_scale_

## void gtk_scale_set_digits (GtkScale *scale, gint digits)
void
gtk_scale_set_digits (scale, digits)
	GtkScale * scale
	gint       digits

## gint gtk_scale_get_digits (GtkScale *scale)
gint
gtk_scale_get_digits (scale)
	GtkScale * scale

## void gtk_scale_set_draw_value (GtkScale *scale, gboolean draw_value)
void
gtk_scale_set_draw_value (scale, draw_value)
	GtkScale * scale
	gboolean   draw_value

## gboolean gtk_scale_get_draw_value (GtkScale *scale)
gboolean
gtk_scale_get_draw_value (scale)
	GtkScale * scale

## void gtk_scale_set_value_pos (GtkScale *scale, GtkPositionType pos)
void
gtk_scale_set_value_pos (scale, pos)
	GtkScale        * scale
	GtkPositionType   pos

## GtkPositionType gtk_scale_get_value_pos (GtkScale *scale)
GtkPositionType
gtk_scale_get_value_pos (scale)
	GtkScale * scale

## void _gtk_scale_get_value_size (GtkScale *scale, gint *width, gint *height)
#void
#_gtk_scale_get_value_size (scale, width, height)
#	GtkScale * scale
#	gint     * width
#	gint     * height

