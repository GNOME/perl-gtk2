/*
 * $Header$
 */

#include "gtk2perl.h"

MODULE = Gtk2::Adjustment	PACKAGE = Gtk2::Adjustment	PREFIX = gtk_adjustment_

GtkObject*
gtk_adjustment_new (class, value, lower, upper, step_increment, page_increment, page_size)
	SV      * class
	gdouble   value
	gdouble   lower
	gdouble   upper
	gdouble   step_increment
	gdouble   page_increment
	gdouble   page_size
    C_ARGS:
	value, lower, upper, step_increment, page_increment, page_size

void
gtk_adjustment_changed (adjustment)
	GtkAdjustment *adjustment

void
gtk_adjustment_value_changed (adjustment)
	GtkAdjustment *adjustment

void
gtk_adjustment_clamp_page (adjustment, lower, upper)
	GtkAdjustment *adjustment
	gdouble lower
	gdouble upper

gdouble
gtk_adjustment_get_value (adjustment)
	GtkAdjustment *adjustment

void
gtk_adjustment_set_value (adjustment, value)
	GtkAdjustment *adjustment
	gdouble value

