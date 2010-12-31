/*
 * Copyright (c) 2005 by the gtk2-perl team (see the file AUTHORS)
 *
 * Licensed under the LGPL, see LICENSE file for more information.
 *
 * $Id$
 */

#include "gtk2perl.h"
#include <cairo-perl.h>

MODULE = Gtk2::Gdk::Cairo	PACKAGE = Gtk2::Gdk::Cairo::Context	PREFIX = gdk_cairo_

BOOT:
	gperl_set_isa ("Gtk2::Gdk::Cairo::Context", "Cairo::Context");

# cairo_t *gdk_cairo_create (GdkDrawable *drawable);
SV *
gdk_cairo_create (class, GdkDrawable *drawable)
    PREINIT:
	cairo_t *cr;
    CODE:
	/* We own cr. */
	cr = gdk_cairo_create (drawable);
	RETVAL = newSV (0);
	sv_setref_pv (RETVAL, "Gtk2::Gdk::Cairo::Context", (void *) cr);
    OUTPUT:
	RETVAL

void gdk_cairo_set_source_color (cairo_t *cr, GdkColor *color);

void gdk_cairo_set_source_pixbuf (cairo_t *cr, GdkPixbuf *pixbuf, double pixbuf_x, double pixbuf_y);

=for apidoc
=for signature $cr->rectangle ($rectangle)
=for arg rectangle (Gtk2::Gdk::Rectangle)
=for arg ... (__hide__)
=cut
# void gdk_cairo_rectangle (cairo_t *cr, GdkRectangle *rectangle);
void
gdk_cairo_rectangle (cairo_t *cr, ...)
    CODE:
	if (items == 2) {
		GdkRectangle *rect = SvGdkRectangle (ST (1));
		gdk_cairo_rectangle (cr, rect);
	} else if (items == 5) {
		double x = SvNV (ST(1));
		double y = SvNV (ST(2));
		double width = SvNV (ST(3));
		double height = SvNV (ST(4));
		cairo_rectangle (cr, x, y, width, height);
	} else {
		croak ("Usage: Gtk2::Gdk::Cairo::Context::rectangle (cr, rectangle)");
	}

void gdk_cairo_region (cairo_t *cr, GdkRegion *region);

#if GTK_CHECK_VERSION (2, 10, 0)

void gdk_cairo_set_source_pixmap (cairo_t *cr, GdkPixmap *pixmap, double pixmap_x, double pixmap_y);

#endif

#if GTK_CHECK_VERSION (2, 18, 0)

void gdk_cairo_reset_clip (cairo_t *cr, GdkDrawable *drawable);

#endif

# ---------------------------------------------------------------------------- #

#if GTK_CHECK_VERSION (2, 10, 0)

MODULE = Gtk2::Gdk::Cairo	PACKAGE = Gtk2::Gdk::Screen	PREFIX = gdk_screen_

const cairo_font_options_t_ornull* gdk_screen_get_font_options (GdkScreen *screen);

void gdk_screen_set_font_options (GdkScreen *screen, const cairo_font_options_t_ornull *options);

#endif

# ---------------------------------------------------------------------------- #

MODULE = Gtk2::Gdk::Cairo	PACKAGE = Gtk2::Gdk::Window	PREFIX = gdk_window_

#if GTK_CHECK_VERSION (2, 22, 0)

cairo_surface_t * gdk_window_create_similar_surface (GdkWindow *window, cairo_content_t content, int width, int height);

cairo_pattern_t * gdk_window_get_background_pattern (GdkWindow *window);

#endif
