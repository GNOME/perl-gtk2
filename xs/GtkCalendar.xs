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

MODULE = Gtk2::Calendar	PACKAGE = Gtk2::Calendar	PREFIX = gtk_calendar_

void
members (cal)
	GtkCalendar* cal
    ALIAS:
	num_marked_dates  = 0
	marked_date       = 1
	year              = 2
	month             = 3
	selected_day      = 4
    PPCODE:
	switch (ix) {
	    case 0:
		PUSHs (sv_2mortal (newSViv (cal->num_marked_dates)));
		break;
 	    case 1:
		{
		int i;
		EXTEND (SP, 31);
		for (i = 0; i < 31; i++) {
			PUSHs (sv_2mortal (newSViv (cal->marked_date[i])));
		}
		}
		break;
	    case 2:
		PUSHs (sv_2mortal (newSViv (cal->year)));
		break;
	    case 3:
		PUSHs (sv_2mortal (newSViv (cal->month)));
		break;
	    case 4:
		PUSHs (sv_2mortal (newSViv (cal->selected_day)));
		break;
	}

## GtkWidget* gtk_calendar_new (void)
GtkWidget*
gtk_calendar_new (class)
    C_ARGS:
	/*void*/

## gboolean gtk_calendar_select_month (GtkCalendar *calendar, guint month, guint year)
gboolean
gtk_calendar_select_month (calendar, month, year)
	GtkCalendar * calendar
	guint         month
	guint         year

## void gtk_calendar_select_day (GtkCalendar *calendar, guint day)
void
gtk_calendar_select_day (calendar, day)
	GtkCalendar * calendar
	guint         day

## gboolean gtk_calendar_mark_day (GtkCalendar *calendar, guint day)
gboolean
gtk_calendar_mark_day (calendar, day)
	GtkCalendar * calendar
	guint         day

## gboolean gtk_calendar_unmark_day (GtkCalendar *calendar, guint day)
gboolean
gtk_calendar_unmark_day (calendar, day)
	GtkCalendar * calendar
	guint         day

## void gtk_calendar_clear_marks (GtkCalendar *calendar)
void
gtk_calendar_clear_marks (calendar)
	GtkCalendar * calendar

## void gtk_calendar_display_options (GtkCalendar *calendar, GtkCalendarDisplayOptions flags)
void
gtk_calendar_display_options (calendar, flags)
	GtkCalendar               * calendar
	GtkCalendarDisplayOptions   flags

## void gtk_calendar_get_date (GtkCalendar *calendar, guint *year, guint *month, guint *day)
void
gtk_calendar_get_date (GtkCalendar * calendar, OUTLIST guint year, OUTLIST guint month, OUTLIST guint day)

## void gtk_calendar_freeze (GtkCalendar *calendar)
void
gtk_calendar_freeze (calendar)
	GtkCalendar * calendar

## void gtk_calendar_thaw (GtkCalendar *calendar)
void
gtk_calendar_thaw (calendar)
	GtkCalendar * calendar

