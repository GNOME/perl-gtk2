/*
 * $Header$
 */

#include "gtk2perl.h"

MODULE = Gtk2::VButtonBox	PACKAGE = Gtk2::VButtonBox	PREFIX = gtk_vbutton_box_

## GtkWidget* gtk_vbutton_box_new (void)
GtkWidget *
gtk_vbutton_box_new (class)
	SV * class
    C_ARGS:

## void gtk_vbutton_box_set_spacing_default (gint spacing)
void
gtk_vbutton_box_set_spacing_default (spacing)
	gint spacing

## GtkButtonBoxStyle gtk_vbutton_box_get_layout_default (void)
GtkButtonBoxStyle
gtk_vbutton_box_get_layout_default ()

## void gtk_vbutton_box_set_layout_default (GtkButtonBoxStyle layout)
void
gtk_vbutton_box_set_layout_default (layout)
	GtkButtonBoxStyle layout

##gint gtk_vbutton_box_get_spacing_default (void)
gint
gtk_vbutton_box_get_spacing_default (class)
	SV * class
    C_ARGS:

