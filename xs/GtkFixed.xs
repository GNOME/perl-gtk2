/*
 * $Header$
 */

#include "gtk2perl.h"

MODULE = Gtk2::Fixed	PACKAGE = Gtk2::Fixed	PREFIX = gtk_fixed_

## GtkWidget* gtk_fixed_new (void)
GtkWidget *
gtk_fixed_new (class)
	SV * class
    C_ARGS:

## void gtk_fixed_put (GtkFixed *fixed, GtkWidget *widget, gint x, gint y)
void
gtk_fixed_put (fixed, widget, x, y)
	GtkFixed  * fixed
	GtkWidget * widget
	gint        x
	gint        y

## void gtk_fixed_move (GtkFixed *fixed, GtkWidget *widget, gint x, gint y)
void
gtk_fixed_move (fixed, widget, x, y)
	GtkFixed  * fixed
	GtkWidget * widget
	gint        x
	gint        y

## void gtk_fixed_set_has_window (GtkFixed *fixed, gboolean has_window)
void
gtk_fixed_set_has_window (fixed, has_window)
	GtkFixed * fixed
	gboolean   has_window

## gboolean gtk_fixed_get_has_window (GtkFixed *fixed)
gboolean
gtk_fixed_get_has_window (fixed)
	GtkFixed * fixed

