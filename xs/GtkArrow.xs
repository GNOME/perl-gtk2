/*
 * $Header$
 */

#include "gtk2perl.h"

MODULE = Gtk2::Arrow	PACKAGE = Gtk2::Arrow	PREFIX = gtk_arrow_

## GtkWidget* gtk_arrow_new (GtkArrowType arrow_type, GtkShadowType shadow_type)
GtkWidget *
gtk_arrow_new (class, arrow_type, shadow_type)
	SV            * class
	GtkArrowType    arrow_type
	GtkShadowType   shadow_type
    C_ARGS:
	arrow_type, shadow_type

## void gtk_arrow_set (GtkArrow *arrow, GtkArrowType arrow_type, GtkShadowType shadow_type)
void
gtk_arrow_set (arrow, arrow_type, shadow_type)
	GtkArrow      * arrow
	GtkArrowType    arrow_type
	GtkShadowType   shadow_type

