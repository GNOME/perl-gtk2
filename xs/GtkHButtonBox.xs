/*
 * $Header$
 */

#include "gtk2perl.h"

MODULE = Gtk2::HButtonBox	PACKAGE = Gtk2::HButtonBox	PREFIX = gtk_hbutton_box_

## GtkWidget* gtk_hbutton_box_new (void)
GtkWidget *
gtk_hbutton_box_new (class)
	SV * class
    C_ARGS:

## GtkButtonBoxStyle gtk_hbutton_box_get_layout_default (void)
GtkButtonBoxStyle
gtk_hbutton_box_get_layout_default ()

## void gtk_hbutton_box_set_spacing_default (gint spacing)
void
gtk_hbutton_box_set_spacing_default (spacing)
	gint spacing

## void gtk_hbutton_box_set_layout_default (GtkButtonBoxStyle layout)
void
gtk_hbutton_box_set_layout_default (layout)
	GtkButtonBoxStyle layout

# TODO: should we accept class here
##gint gtk_hbutton_box_get_spacing_default (void)
gint
gtk_hbutton_box_get_spacing_default ()
