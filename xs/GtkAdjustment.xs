/*
 * Copyright (c) 2003 by the gtk2-perl team (see the file AUTHORS)
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Library General Public
 * License as published by the Free Software Foundation; either
 * version 2.1 of the License, or (at your option) any later version.
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
 * $Id$
 */

#include "gtk2perl.h"

MODULE = Gtk2::Adjustment	PACKAGE = Gtk2::Adjustment	PREFIX = gtk_adjustment_

=for apidoc Gtk2::Adjustment::value
=for signature double = $adjustment->value
=for signature double = $adjustment->value ($newval)
=for signature double = $adjustment->lower
=for signature double = $adjustment->lower ($newval)
=for signature double = $adjustment->upper
=for signature double = $adjustment->upper ($newval)
=for signature double = $adjustment->step_increment
=for signature double = $adjustment->step_increment ($newval)
=for signature double = $adjustment->page_increment
=for signature double = $adjustment->page_increment ($newval)
=for signature double = $adjustment->page_size
=for signature double = $adjustment->page_size ($newval)

Get or set the six fields of a Gtk2::Adjustment.

The setter functions store $newval and return the old value.  Note
that they don't emit any signals; it's up to you to emit "notify"
(because the fields are also properties) and "changed" or
"value-changed", when you're ready.

=cut

=for apidoc value __hide__
=cut

=for apidoc lower __hide__
=cut

=for apidoc upper __hide__
=cut

=for apidoc step_increment __hide__
=cut

=for apidoc page_increment __hide__
=cut

=for apidoc page_size __hide__
=cut

gdouble
value (GtkAdjustment *adjustment, gdouble newval = 0)
    ALIAS:
	lower          = 1
	upper          = 2
	step_increment = 3
	page_increment = 4
	page_size      = 5
    CODE:
	switch (ix) {
	    case 0:
		RETVAL = adjustment->value;
		if (items > 1) adjustment->value = newval;
		break;
	    case 1:
		RETVAL = adjustment->lower;
		if (items > 1) adjustment->lower = newval;
		break;
	    case 2:
		RETVAL = adjustment->upper;
		if (items > 1) adjustment->upper = newval;
		break;
	    case 3:
		RETVAL = adjustment->step_increment;
		if (items > 1) adjustment->step_increment = newval;
		break;
	    case 4:
		RETVAL = adjustment->page_increment;
		if (items > 1) adjustment->page_increment = newval;
		break;
	    case 5:
		RETVAL = adjustment->page_size;
		if (items > 1) adjustment->page_size = newval;
		break;
	    default:
		RETVAL = 0.0;
		g_assert_not_reached ();
	}
    OUTPUT:
	RETVAL


GtkObject*
gtk_adjustment_new (class, value, lower, upper, step_increment, page_increment, page_size)
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

