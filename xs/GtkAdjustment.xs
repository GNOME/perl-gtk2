/*
 * Copyright (c) 2003 by the gtk2-perl team (see the file AUTHORS)
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Library General Public
 * License as published by the Free Software Foundation; either
 * version 2 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Library General Public License for more details.
 *
 * You should have received a copy of the GNU Library General Public
 * License along with this library; if not, write to the 
 * Free Software Foundation, Inc., 59 Temple Place - Suite 330, 
 * Boston, MA  02111-1307  USA.
 *
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

