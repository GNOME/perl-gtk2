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
newSVGdkAtom (GdkAtom atom)
{
	SV * sv = newSV(0);
	sv_setref_pv (sv, "Gtk2::Gdk::Atom", (void*)atom);
	return sv;
}

GdkAtom
SvGdkAtom (SV * sv)
{
	if (!sv || !SvOK (sv))
		return (GdkAtom)NULL;
	else if (sv_derived_from (sv, "Gtk2::Gdk::Atom"))
                return (GdkAtom) SvIV ((SV*)SvRV (sv));
        else
                croak ("variable is not of type Gtk2::Gdk::Atom");
	return (GdkAtom)NULL; /* not reached */
}


MODULE = Gtk2::Gdk::Types	PACKAGE = Gtk2::Gdk::Rectangle

GdkRectangle_copy *
new (class, x, y, width, height)
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
	RETVAL = 0;
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
