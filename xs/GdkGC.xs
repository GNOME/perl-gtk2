/*
 * $Header$
 */

#include "gtk2perl.h"

MODULE = Gtk2::Gdk::GC	PACKAGE = Gtk2::Gdk::GC	PREFIX = gdk_gc_

 ## taken care of by typemaps
 ## void gdk_gc_unref (GdkGC *gc)

 ##GdkGC * gdk_gc_new (GdkDrawable * drawable);
GdkGC_noinc*
gdk_gc_new (class, drawable)
	SV * class
	GdkDrawable * drawable
    C_ARGS:
	drawable

 ##GdkGC * gdk_gc_new_with_values (GdkDrawable * drawable, GdkGCValues * values);
##  implement this with an optional values arg to ->new
 ##GdkScreen * gdk_gc_get_screen (GdkGC * gc);

# ## void gdk_gc_get_values (GdkGC *gc, GdkGCValues *values)
#void
#gdk_gc_get_values (gc, values)
#	GdkGC *gc
#	GdkGCValues *values
#
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

# FIXME get dash list from perl stack
# ## void gdk_gc_set_dashes (GdkGC *gc, gint dash_offset, gint8 dash_list[], gint n)
#void
#gdk_gc_set_dashes (gc, dash_offset, a, n)
#	GdkGC *gc
#	gint dash_offset
#	gint8 dash_list[]
#	gint n

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

# ## GdkScreen * gdk_gc_get_screen (GdkGC *gc)
#GdkScreen *
#gdk_gc_get_screen (gc)
#	GdkGC *gc
#
