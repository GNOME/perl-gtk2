/*
 * Copyright (c) 2003 by the gtk2-perl team (see the file AUTHORS)
 *
 * Licensed under the LGPL, see LICENSE file for more information.
 *
 * $Header$
 */

#include "gtk2perl.h"

MODULE = Gtk2::Calendar	PACKAGE = Gtk2::Calendar	PREFIX = gtk_calendar_

=for apidoc num_marked_dates
=for signature $widget->num_marked_dates ($value)
=for signature value = $widget->num_marked_dates
=cut

=for apidoc marked_date
=for signature $widget->marked_date ($value)
=for signature value = $widget->marked_date
=cut

=for apidoc year
=for signature $widget->year ($value)
=for signature value = $widget->year
=cut

=for apidoc month
=for signature $widget->month ($value)
=for signature value = $widget->month
=cut

=for apidoc selected_day
=for signature $widget->selected_day ($value)
=for signature value = $widget->selected_day
=cut

void
num_marked_dates (cal)
	GtkCalendar* cal
    ALIAS:
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

