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

	sv_bless (r, gv_stashpv ("Gtk2::Gdk::Rectangle", TRUE));

	return r;
}

GdkRectangle *
SvGdkRectangle (SV * sv)
{
	AV * av;
	GdkRectangle * rect = NULL;

	if ((!sv) || (!SvOK(sv)) || (!SvRV(sv)) ||
	    SvTYPE(SvRV(sv)) != SVt_PVAV)
		return NULL;
	
	av = (AV*) SvRV (sv);

	if (av_len (av) != 3)
		croak ("rectangle array must have four elements");

	rect = gperl_alloc_temp (sizeof (GdkRectangle));
	
	rect->x      = SvIV (*av_fetch (av, 0, 0));
	rect->y      = SvIV (*av_fetch (av, 1, 0));
	rect->width  = SvIV (*av_fetch (av, 2, 0));
	rect->height = SvIV (*av_fetch (av, 3, 0));

	return rect;
}


MODULE = Gtk2::Gdk::Types	PACKAGE = Gtk2::Gdk::Rectangle

GdkRectangle *
new (class, x, y, width, height)
	SV * class
	gint x
	gint y
	gint width
	gint height
    PREINIT:
	GdkRectangle rect;
    CODE:
	rect.x = x;
	rect.y = y;
	rect.width = width;
	rect.height = height;
	RETVAL = &rect;
    OUTPUT:
	RETVAL

#if 0

##gint
##members (rectangle)
##	GdkRectangle * rectangle
##    ALIAS:
##	Gtk2::Gdk::Rectangle::x = 0
##	Gtk2::Gdk::Rectangle::y = 1
##	Gtk2::Gdk::Rectangle::width = 2
##	Gtk2::Gdk::Rectangle::height = 3
##    CODE:
##	switch (ix) {
##		case 0: RETVAL = rectangle->x; break;
##		case 1: RETVAL = rectangle->y; break;
##		case 2: RETVAL = rectangle->width; break;
##		case 3: RETVAL = rectangle->height; break;
##	}
##    OUTPUT:
##	RETVAL

#endif
