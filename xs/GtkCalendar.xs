/*
 * $Header$
 */

#include "gtk2perl.h"

MODULE = Gtk2::Calendar	PACKAGE = Gtk2::Calendar	PREFIX = gtk_calendar_

## GtkWidget* gtk_calendar_new (void)
GtkWidget*
gtk_calendar_new (class)
	SV * class
    C_ARGS:

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

