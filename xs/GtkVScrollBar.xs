/*
 * $Header$
 */

#include "gtk2perl.h"

MODULE = Gtk2::VScrollBar	PACKAGE = Gtk2::VScrollBar	PREFIX = gtk_vscrollbar_

## GtkWidget* gtk_vscrollbar_new (GtkAdjustment *adjustment)
GtkWidget *
gtk_vscrollbar_new (class, adjustment=NULL)
	SV            * class
	GtkAdjustment_ornull * adjustment
    C_ARGS:
	adjustment

