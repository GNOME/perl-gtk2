/*
 * Copyright (c) 2003 by the gtk2-perl team (see the file AUTHORS)
 *
 * Licensed under the LGPL, see LICENSE file for more information.
 *
 * $Header$
 */

#include "gtk2perl.h"

MODULE = Gtk2::GC	PACKAGE = Gtk2::GC	PREFIX = gtk_gc_

=for position DESCRIPTION

=head1 DESCRIPTION

These functions provide access to a shared pool of L<Gtk2::Gdk::GC>
objects. When a new L<Gtk2::Gdk::GC> is needed, I<Gtk2::Gdk::GC::get> is called
with the required depth, colormap and I<Gtk2::Gdk::GCValues>. If a
L<Gtk2::Gdk::GC> with the required properties already exists then that is
returned. If not, a new L<Gtk2::Gdk::GC> is created. When the L<Gtk2::Gdk::GC>
is no longer needed, I<Gtk2::Gdk::GC::release> should be called.

[From: L<http://developer.gnome.org/doc/API/2.0/gtk/gtk-Graphics-Contexts.html>]

=cut

## GdkGC * gtk_gc_get (gint depth, GdkColormap *colormap, GdkGCValues *values, GdkGCValuesMask values_mask)
GdkGC *
gtk_gc_get (class, depth, colormap, values)
	gint depth
	GdkColormap *colormap
	SV *values
    PREINIT:
	GdkGCValues v;
	GdkGCValuesMask m;
    CODE:
	SvGdkGCValues (values, &v, &m);
	RETVAL = gtk_gc_get (depth, colormap, &v, m);
    OUTPUT:
	RETVAL

## void gtk_gc_release (GdkGC *gc)
void
gtk_gc_release (class, gc)
	GdkGC *gc
    C_ARGS:
	gc
