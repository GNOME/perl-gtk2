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



MODULE = Gtk2::Gdk::Types	PACKAGE = Gtk2::Gdk::Rectangle

GdkRectangle_copy *
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

gint
members (rectangle)
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
	}
    OUTPUT:
	RETVAL

void
values (rectangle)
	GdkRectangle * rectangle
    PPCODE:
	EXTEND (SP, 4);
	PUSHs (sv_2mortal (newSViv (rectangle->x)));
	PUSHs (sv_2mortal (newSViv (rectangle->y)));
	PUSHs (sv_2mortal (newSViv (rectangle->width)));
	PUSHs (sv_2mortal (newSViv (rectangle->height)));
