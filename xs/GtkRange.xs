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
 * $Header$
 */

#include "gtk2perl.h"

MODULE = Gtk2::Range	PACKAGE = Gtk2::Range	PREFIX = gtk_range_

## void gtk_range_set_update_policy (GtkRange *range, GtkUpdateType policy)
void
gtk_range_set_update_policy (range, policy)
	GtkRange      * range
	GtkUpdateType   policy

## GtkUpdateType gtk_range_get_update_policy (GtkRange *range)
GtkUpdateType
gtk_range_get_update_policy (range)
	GtkRange * range

## void gtk_range_set_adjustment (GtkRange *range, GtkAdjustment *adjustment)
void
gtk_range_set_adjustment (range, adjustment)
	GtkRange      * range
	GtkAdjustment * adjustment

## GtkAdjustment* gtk_range_get_adjustment (GtkRange *range)
GtkAdjustment*
gtk_range_get_adjustment (range)
	GtkRange * range

## void gtk_range_set_inverted (GtkRange *range, gboolean setting)
void
gtk_range_set_inverted (range, setting)
	GtkRange * range
	gboolean   setting

## gboolean gtk_range_get_inverted (GtkRange *range)
gboolean
gtk_range_get_inverted (range)
	GtkRange * range

## void gtk_range_set_increments (GtkRange *range, gdouble step, gdouble page)
void
gtk_range_set_increments (range, step, page)
	GtkRange * range
	gdouble    step
	gdouble    page

## void gtk_range_set_range (GtkRange *range, gdouble min, gdouble max)
void
gtk_range_set_range (range, min, max)
	GtkRange * range
	gdouble    min
	gdouble    max

## void gtk_range_set_value (GtkRange *range, gdouble value)
void
gtk_range_set_value (range, value)
	GtkRange * range
	gdouble    value

## gdouble gtk_range_get_value (GtkRange *range)
gdouble
gtk_range_get_value (range)
	GtkRange * range

