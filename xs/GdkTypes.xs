/*
 * $Header$
 */

#include "gtk2perl.h"

#if 0

##MODULE = Gtk2::Gdk::Types	PACKAGE = Gtk2::Gdk::Point
##
##gint
##x (point)
##	GdkPoint * point
##    ALIAS:
##	Gtk2::Gdk::Point::x = 0
##	Gtk2::Gdk::Point::y = 1
##    CODE:
##	RETVAL = ix == 1 ? point->y : point->x;
##    OUTPUT:
##	RETVAL
##
##
##MODULE = Gtk2::Gdk::Types	PACKAGE = Gtk2::Gdk::Segment
##
##gint
##x1 (segment)
##	GdkSegment * segment
##    ALIAS:
##	Gtk2::Gdk::Rectangle::x1 = 0
##	Gtk2::Gdk::Rectangle::y1 = 1
##	Gtk2::Gdk::Rectangle::x2 = 2
##	Gtk2::Gdk::Rectangle::y2 = 3
##    CODE:
##	switch (ix) {
##		case 0: RETVAL = rectangle->x1; break;
##		case 1: RETVAL = rectangle->y2; break;
##		case 2: RETVAL = rectangle->x2; break;
##		case 3: RETVAL = rectangle->y2; break;
##		default: croak ("shouldn't reach this");
##	}
##    OUTPUT:
##	RETVAL
##
##MODULE = Gtk2::Gdk::Types	PACKAGE = Gtk2::Gdk::Span
##
##gint
##x (span)
##	GdkSpan * span
##    ALIAS:
##	Gtk2::Gdk::Rectangle::x = 0
##	Gtk2::Gdk::Rectangle::y = 1
##	Gtk2::Gdk::Rectangle::width = 2
##    CODE:
##	switch (ix) {
##		case 0: RETVAL = rectangle->x; break;
##		case 1: RETVAL = rectangle->y; break;
##		case 2: RETVAL = rectangle->width; break;
##		default: croak ("shouldn't reach this");
##	}
##    OUTPUT:
##	RETVAL

#endif

MODULE = Gtk2::Gdk::Types	PACKAGE = Gtk2::Gdk::Rectangle

gint
x (rectangle)
	GdkRectangle * rectangle
    ALIAS:
	Gtk2::Gdk::Rectangle::x = 0
	Gtk2::Gdk::Rectangle::y = 1
	Gtk2::Gdk::Rectangle::width = 2
	Gtk2::Gdk::Rectangle::height = 3
    CODE:
	switch (ix) {
		case 0: RETVAL = rectangle->x; break;
		case 1: RETVAL = rectangle->y; break;
		case 2: RETVAL = rectangle->width; break;
		case 3: RETVAL = rectangle->height; break;
		default: croak ("shouldn't reach this");
	}
    OUTPUT:
	RETVAL
