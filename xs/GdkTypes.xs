/*
 * $Header$
 */

#include "gtk2perl.h"

/***  GAH!!  copied code!!!  crap...  ***/

SV *
newSVGdkModifierType (GdkModifierType val)
{
	GFlagsValue * vals = gtk_type_flags_get_values (GDK_TYPE_MODIFIER_TYPE);
	AV * flags = newAV ();
	while (vals && vals->value_nick && vals->value_name) {
		if ((vals->value != GDK_MODIFIER_MASK) &&
		    (vals->value & val))
			av_push (flags, newSVpv (vals->value_nick, 0));
		vals++;
	}
	return newRV_noinc ((SV*) flags);
}



SV *
newSVGdkRectangle (GdkRectangle * rect)
{
	AV * av;
	SV * r;
	
	if (!rect)
		return newSVsv (&PL_sv_undef);
		
	av = newAV ();
	r = newRV_noinc ((SV*) av);
	
	av_push (av, newSViv (rect->x));
	av_push (av, newSViv (rect->y));
	av_push (av, newSViv (rect->width));
	av_push (av, newSViv (rect->height));
	
	return r;
}

GdkRectangle *
SvGdkRectangle (SV * sv)
{
	AV * av;
	GdkRectangle * rect;

	if ((!sv) || (!SvOK(sv)) ||
	    (!SvRV(sv)) || (SvTYPE(SvRV(sv)) != SVt_PVAV))
		return NULL;
		
	av = (AV*) SvRV (sv);

	if (av_len (av) != 3)
		croak ("rectangle must have four elements");

	rect = gperl_alloc_temp (sizeof (GdkRectangle));
	
	rect->x      = SvIV (*av_fetch (av, 0, 0));
	rect->y      = SvIV (*av_fetch (av, 1, 0));
	rect->width  = SvIV (*av_fetch (av, 2, 0));
	rect->height = SvIV (*av_fetch (av, 3, 0));
	
	return rect;
}



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

#if 0

///MODULE = Gtk2::Gdk::Types	PACKAGE = Gtk2::Gdk::Rectangle

gint
members (rectangle)
	GdkRectangle * rectangle
	SV * newval
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

#endif
