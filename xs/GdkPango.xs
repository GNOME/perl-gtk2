/*
 * Copyright (c) 2005 by the gtk2-perl team (see the file AUTHORS)
 *
 * Licensed under the LGPL, see LICENSE file for more information.
 *
 * $Header$
 */
#include "gtk2perl.h"

MODULE = Gtk2::Gdk::Pango	PACKAGE = Gtk2::Gdk::PangoRenderer	PREFIX = gdk_pango_renderer_

# We own the reference.
# PangoRenderer *gdk_pango_renderer_new (GdkScreen *screen);
PangoRenderer_noinc *
gdk_pango_renderer_new (class, screen)
	GdkScreen *screen
    C_ARGS:
	screen

# gtk+ owns the reference.
# PangoRenderer *gdk_pango_renderer_get_default (GdkScreen *screen);
PangoRenderer *
gdk_pango_renderer_get_default (class, screen)
	GdkScreen *screen
    C_ARGS:
	screen

void gdk_pango_renderer_set_drawable (GdkPangoRenderer *gdk_renderer, GdkDrawable_ornull *drawable);

void gdk_pango_renderer_set_gc (GdkPangoRenderer *gdk_renderer, GdkGC_ornull *gc);

void gdk_pango_renderer_set_stipple (GdkPangoRenderer *gdk_renderer, PangoRenderPart part, GdkBitmap_ornull *stipple);

void gdk_pango_renderer_set_override_color (GdkPangoRenderer *gdk_renderer, PangoRenderPart part, const GdkColor_ornull *color);

# FIXME: Do we need this?  The docs say to use gtk_widget_get_pango_context()
#        instead.
# PangoContext *gdk_pango_context_get_for_screen (GdkScreen *screen);

# FIXME: Bind these if/when we get PangoAttribute bindings.
# PangoAttribute *gdk_pango_attr_stipple_new  (GdkBitmap *stipple);
# PangoAttribute *gdk_pango_attr_embossed_new (gboolean embossed);

# FIXME: How to bind these?  Class static method or function?
# GdkRegion *gdk_pango_layout_line_get_clip_region (PangoLayoutLine *line, gint x_origin, gint y_origin, gint *index_ranges, gint n_ranges);
# GdkRegion *gdk_pango_layout_get_clip_region (PangoLayout *layout, gint x_origin, gint y_origin, gint *index_ranges, gint n_ranges);
