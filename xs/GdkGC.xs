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


MODULE = Gtk2::Gdk::GC	PACKAGE = Gtk2::Gdk::GC	PREFIX = gdk_gc_

BOOT:
	/* the gdk backends override the public GdkGC with private,
	 * back-end-specific types.  tell gperl_get_object not to 
	 * complain about them.  */
	gperl_object_set_no_warn_unreg_subclass (GDK_TYPE_GC, TRUE);



 ## taken care of by typemaps
 ## void gdk_gc_unref (GdkGC *gc)

 ##GdkGC * gdk_gc_new (GdkDrawable * drawable);
GdkGC_noinc*
gdk_gc_new (class, drawable)
	GdkDrawable * drawable
    C_ARGS:
	drawable

# FIXME need GdkGCValues
 ##GdkGC * gdk_gc_new_with_values (GdkDrawable * drawable, GdkGCValues * values);
##  implement this with an optional values arg to ->new
 ##GdkScreen * gdk_gc_get_screen (GdkGC * gc);

# FIXME need GdkGCValues
# ## void gdk_gc_get_values (GdkGC *gc, GdkGCValues *values)
#void
#gdk_gc_get_values (gc, values)
#	GdkGC *gc
#	GdkGCValues *values
#
# FIXME need GdkGCValues
# ## void gdk_gc_set_values (GdkGC *gc, GdkGCValues *values, GdkGCValuesMask values_mask)
#void
#gdk_gc_set_values (gc, values, values_mask)
#	GdkGC *gc
#	GdkGCValues *values
#	GdkGCValuesMask values_mask

 ## void gdk_gc_set_foreground (GdkGC *gc, GdkColor *color)
void
gdk_gc_set_foreground (gc, color)
	GdkGC *gc
	GdkColor *color

 ## void gdk_gc_set_background (GdkGC *gc, GdkColor *color)
void
gdk_gc_set_background (gc, color)
	GdkGC *gc
	GdkColor *color

 ## void gdk_gc_set_font (GdkGC *gc, GdkFont *font)
void
gdk_gc_set_font (gc, font)
	GdkGC *gc
	GdkFont *font

 ## void gdk_gc_set_function (GdkGC *gc, GdkFunction function)
void
gdk_gc_set_function (gc, function)
	GdkGC *gc
	GdkFunction function

 ## void gdk_gc_set_fill (GdkGC *gc, GdkFill fill)
void
gdk_gc_set_fill (gc, fill)
	GdkGC *gc
	GdkFill fill

 ## void gdk_gc_set_tile (GdkGC *gc, GdkPixmap *tile)
void
gdk_gc_set_tile (gc, tile)
	GdkGC *gc
	GdkPixmap *tile

 ## void gdk_gc_set_stipple (GdkGC *gc, GdkPixmap *stipple)
void
gdk_gc_set_stipple (gc, stipple)
	GdkGC *gc
	GdkPixmap *stipple

 ## void gdk_gc_set_ts_origin (GdkGC *gc, gint x, gint y)
void
gdk_gc_set_ts_origin (gc, x, y)
	GdkGC *gc
	gint x
	gint y

 ## void gdk_gc_set_clip_origin (GdkGC *gc, gint x, gint y)
void
gdk_gc_set_clip_origin (gc, x, y)
	GdkGC *gc
	gint x
	gint y

 ## void gdk_gc_set_clip_mask (GdkGC *gc, GdkBitmap *mask)
void
gdk_gc_set_clip_mask (gc, mask)
	GdkGC *gc
	SV *mask
    CODE:
	gdk_gc_set_clip_mask (gc, SvGdkBitmap (mask));

 ## void gdk_gc_set_clip_rectangle (GdkGC *gc, GdkRectangle *rectangle)
void
gdk_gc_set_clip_rectangle (gc, rectangle)
	GdkGC *gc
	GdkRectangle *rectangle

# FIXME needs GdkRegion
# ## void gdk_gc_set_clip_region (GdkGC *gc, GdkRegion *region)
#void
#gdk_gc_set_clip_region (gc, region)
#	GdkGC *gc
#	GdkRegion *region

 ## void gdk_gc_set_subwindow (GdkGC *gc, GdkSubwindowMode mode)
void
gdk_gc_set_subwindow (gc, mode)
	GdkGC *gc
	GdkSubwindowMode mode

 ## void gdk_gc_set_exposures (GdkGC *gc, gboolean exposures)
void
gdk_gc_set_exposures (gc, exposures)
	GdkGC *gc
	gboolean exposures

 ## void gdk_gc_set_line_attributes (GdkGC *gc, gint line_width, GdkLineStyle line_style, GdkCapStyle cap_style, GdkJoinStyle join_style)
void
gdk_gc_set_line_attributes (gc, line_width, line_style, cap_style, join_style)
	GdkGC *gc
	gint line_width
	GdkLineStyle line_style
	GdkCapStyle cap_style
	GdkJoinStyle join_style

 ## void gdk_gc_set_dashes (GdkGC *gc, gint dash_offset, gint8 dash_list[], gint n)
void
gdk_gc_set_dashes (gc, dash_offset, ...)
	GdkGC * gc
	gint    dash_offset
    PREINIT:
	gint8 * dash_list;
	gint    n;
    CODE:
	n = --items-1;
	dash_list = g_new(gint8, n);
	g_printerr("n: %d\n", n);
	for( ; items > 1; items-- )
		dash_list[items-2] = (gint8) SvIV(ST(items));
	gdk_gc_set_dashes(gc, dash_offset, dash_list, n);
	g_free(dash_list);

 ## void gdk_gc_offset (GdkGC *gc, gint x_offset, gint y_offset)
void
gdk_gc_offset (gc, x_offset, y_offset)
	GdkGC *gc
	gint x_offset
	gint y_offset

 ## void gdk_gc_copy (GdkGC *dst_gc, GdkGC *src_gc)
void
gdk_gc_copy (dst_gc, src_gc)
	GdkGC *dst_gc
	GdkGC *src_gc

 ## void gdk_gc_set_colormap (GdkGC *gc, GdkColormap *colormap)
void
gdk_gc_set_colormap (gc, colormap)
	GdkGC *gc
	GdkColormap *colormap

 ## void gdk_gc_set_rgb_fg_color (GdkGC *gc, GdkColor *color)
void
gdk_gc_set_rgb_fg_color (gc, color)
	GdkGC *gc
	GdkColor *color

 ## void gdk_gc_set_rgb_bg_color (GdkGC *gc, GdkColor *color)
void
gdk_gc_set_rgb_bg_color (gc, color)
	GdkGC *gc
	GdkColor *color

#ifdef GDK_TYPE_SCREEN

 ## GdkScreen * gdk_gc_get_screen (GdkGC *gc)
GdkScreen *
gdk_gc_get_screen (gc)
	GdkGC *gc

#endif /* have GdkScreen */
