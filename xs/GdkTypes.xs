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

=for apidoc Gtk2::Gdk::Rectangle::x
=for signature integer = $rectangle->x
=for signature oldvalue = $rectangle->x ($newvalue)
=for arg newvalue (integer)
=cut

=for apidoc y
=for signature integer = $rectangle->y
=for signature oldvalue = $rectangle->y ($newvalue)
=for arg newvalue (integer)
=cut

=for apidoc width
=for signature integer = $rectangle->width
=for signature oldvalue = $rectangle->width ($newvalue)
=for arg newvalue (integer)
=cut

=for apidoc height
=for signature integer = $rectangle->height
=for signature oldvalue = $rectangle->height ($newvalue)
=for arg newvalue (integer)
=cut

gint
x (GdkRectangle *rectangle, SV *newvalue = 0)
    ALIAS:
	y = 1
	width = 2
	height = 3
    CODE:
	RETVAL = 0;
	switch (ix) {
		case 0: RETVAL = rectangle->x; break;
		case 1: RETVAL = rectangle->y; break;
		case 2: RETVAL = rectangle->width; break;
		case 3: RETVAL = rectangle->height; break;
	}
        if (newvalue) {
                switch (ix) {
                        case 0: rectangle->x      = SvIV (newvalue); break;
                        case 1: rectangle->y      = SvIV (newvalue); break;
                        case 2: rectangle->width  = SvIV (newvalue); break;
                        case 3: rectangle->height = SvIV (newvalue); break;
                }
        }
    OUTPUT:
	RETVAL

=for apidoc
=for signature (x, y, width, height) = $rectangle->values
=cut
void
values (rectangle)
	GdkRectangle * rectangle
    PPCODE:
	EXTEND (SP, 4);
	PUSHs (sv_2mortal (newSViv (rectangle->x)));
	PUSHs (sv_2mortal (newSViv (rectangle->y)));
	PUSHs (sv_2mortal (newSViv (rectangle->width)));
	PUSHs (sv_2mortal (newSViv (rectangle->height)));

MODULE = Gtk2::Gdk::Types	PACKAGE = Gtk2::Gdk::Geometry

GdkGeometry *
new (class)
	SV *class
    PREINIT:
	GdkGeometry geometry;
    CODE:
        memset (&geometry, 0, sizeof (geometry));
	RETVAL = &geometry;
    OUTPUT:
	RETVAL

gint
min_width (GdkGeometry *geometry, gint newvalue = 0)
    ALIAS:
        min_height = 1
        max_width = 2
        max_height = 3
        base_width = 4
        base_height = 5
        width_inc = 6
        height_inc = 7
    CODE:
	switch (ix) {
                case 0: RETVAL = geometry->min_width;   break;
                case 1: RETVAL = geometry->min_height;  break;
                case 2: RETVAL = geometry->max_width;   break;
                case 3: RETVAL = geometry->max_height;  break;
                case 4: RETVAL = geometry->base_width;  break;
                case 5: RETVAL = geometry->base_height; break;
                case 6: RETVAL = geometry->width_inc;   break;
                case 7: RETVAL = geometry->height_inc;  break;
        }
	if (items > 1) {
                switch (ix) {
                        case 0: geometry->min_width   = newvalue; break;
                        case 1: geometry->min_height  = newvalue; break;
                        case 2: geometry->max_width   = newvalue; break;
                        case 3: geometry->max_height  = newvalue; break;
                        case 4: geometry->base_width  = newvalue; break;
                        case 5: geometry->base_height = newvalue; break;
                        case 6: geometry->width_inc   = newvalue; break;
                        case 7: geometry->height_inc  = newvalue; break;
                }
        }
    OUTPUT:
	RETVAL

gdouble
min_aspect (GdkGeometry *geometry, gdouble newvalue = 0)
    ALIAS:
        max_aspect = 1
    CODE:
	switch (ix) {
                case 0: RETVAL = geometry->min_aspect; break;
                case 1: RETVAL = geometry->max_aspect; break;
        }
	if (items > 1) {
                switch (ix) {
                        case 0: geometry->min_aspect = newvalue; break;
                        case 1: geometry->max_aspect = newvalue; break;
                }
        }
    OUTPUT:
	RETVAL

GdkGravity
gravity (GdkGeometry *geometry, GdkGravity newvalue = 0)
    CODE:
        RETVAL = geometry->win_gravity;
        if (items > 1)
  		geometry->win_gravity = newvalue;
    OUTPUT:
        RETVAL

## moved here because it makes plain sense
## need to document it...
## ## void gdk_window_constrain_size (GdkGeometry *geometry, guint flags, gint width, gint height, gint *new_width, gint *new_height)
=for apidoc
=signature (new_width, new_height) = $geometry->constrain_size ($flags, $width, $height)
=cut
void
constrain_size (geometry, flags, width, height)
	GdkGeometry *geometry
	GdkWindowHints flags
	gint width
	gint height
    PREINIT:
	gint new_width;
	gint new_height;
    PPCODE:
	gdk_window_constrain_size (geometry, flags, width, height, &new_width, &new_height);
	EXTEND (SP, 2);
	PUSHs (sv_2mortal (newSViv (new_width)));
	PUSHs (sv_2mortal (newSViv (new_height)));

