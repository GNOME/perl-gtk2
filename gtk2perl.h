/*
 * Copyright (c) 2003 by the gtk2-perl team (see the file AUTHORS)
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Library General Public
 * License as published by the Free Software Foundation; either
 * version 2 of the License, or (at your option) any later version.
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

#ifndef _GTK2PERL_H_
#define _GTK2PERL_H_

#include <gperl.h>
#include <gtk/gtk.h>
#include "gtk2perl-autogen.h"

/**
 * gtk2perl_new_gtkobject:
 * @object: object to wrap.
 * 
 * create a new or return an existing wrapper around a C object descended 
 * from $GtkObject.  calls gtk_object_sink() after calling gperl_new_object().
 *
 * #GtkObjects are created with an initial refcount of 0, and a "floating"
 * flag set.  code which wishes to assume ownership of a new #GtkObject
 * sinks the floating ref by calling gtk_object_sink(); this converts the
 * floating ref into a "real" ref.
 *
 * since the perl code which called a #GtkObject-constructing function
 * owns the object, at least until it's taken over by something else,
 * gtk2perl_new_gtkobject() *always* refs (via gperl_new_object()) and sinks
 * (via gtk_object_sink()) the object.  if the object was owned by someone
 * else it simply gets a second ref which is removed by Glib::Object::DESTROY.
 *
 * returns: scalar wrapper for @object.
 *
 * in xs/GtkObject.xs 
 */
SV * gtk2perl_new_gtkobject (GtkObject * object);


/*
custom handling for GdkBitmaps, since there are no typemacros for them.
*/
/* GObject derivative GdkBitmap */
#define SvGdkBitmap(sv)       ((GdkBitmap*)gperl_get_object_check (sv, GDK_TYPE_DRAWABLE))
typedef GdkBitmap GdkBitmap_ornull;
#define SvGdkBitmap_ornull(sv)        (((sv) == &PL_sv_undef) ? NULL : SvGdkBitmap(sv))
typedef GdkBitmap GdkBitmap_noinc;
/* these are real functions, rather than macros, because there's some extra
 * work involved in making sure it's blessed into Gtk2::Gdk::Bitmap when no
 * GType exists for GdkBitmap. */
SV * newSVGdkBitmap (GdkBitmap * bitmap);
SV * newSVGdkBitmap_noinc (GdkBitmap * bitmap);


/*
 * override the autogen stuff for GdkModifierType, so we can make sure
 * that GDK_MODIFIER_MASK doesn't get in there and mess things up.
 * (it has multiple bits set and therefore matches everything!)
 */
#undef newSVGdkModifierType
SV * newSVGdkModifierType (GdkModifierType mods);

#endif /* _GTK2PERL_H_ */
