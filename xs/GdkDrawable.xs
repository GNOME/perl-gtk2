/*
 * $Header$
 */

#include "gtk2perl.h"

/*
NOTE:
GdkDrawable descends directly from GObject, so be sure to use GdkDrawable_own
for functions that return brand-new objects!  (i don't think there are any,
but there are several functions in other modules returning GdkDrawable
subclasses)
*/

MODULE = Gtk2::Gdk::Drawable	PACKAGE = Gtk2::Gdk::Drawable	PREFIX = gdk_drawable_

 ## deprecated
 ## GdkDrawable* gdk_drawable_ref (GdkDrawable *drawable)
 ## deprecated
 ## void gdk_drawable_unref (GdkDrawable *drawable)
 ## deprecated
 ## gpointer gdk_drawable_get_data (GdkDrawable *drawable, const gchar *key)

 ## void gdk_drawable_get_size (GdkDrawable *drawable, gint *width, gint *height)
void gdk_drawable_get_size (GdkDrawable *drawable, OUTLIST gint width, OUTLIST gint height)

 ## void gdk_drawable_set_colormap (GdkDrawable *drawable, GdkColormap *colormap)
void
gdk_drawable_set_colormap (drawable, colormap)
	GdkDrawable *drawable
	GdkColormap *colormap

 ## GdkColormap* gdk_drawable_get_colormap (GdkDrawable *drawable)
GdkColormap*
gdk_drawable_get_colormap (drawable)
	GdkDrawable *drawable

 ## GdkVisual* gdk_drawable_get_visual (GdkDrawable *drawable)
GdkVisual*
gdk_drawable_get_visual (drawable)
	GdkDrawable *drawable

 ## gint gdk_drawable_get_depth (GdkDrawable *drawable)
gint
gdk_drawable_get_depth (drawable)
	GdkDrawable *drawable

#if GTK_CHECK_VERSION(2,2,0)

## GdkScreen* gdk_drawable_get_screen (GdkDrawable *drawable)
GdkScreen*
gdk_drawable_get_screen (drawable)
	GdkDrawable *drawable

## GdkDisplay* gdk_drawable_get_display (GdkDrawable *drawable)
GdkDisplay*
gdk_drawable_get_display (drawable)
	GdkDrawable *drawable

#endif

MODULE = Gtk2::Gdk::Drawable	PACKAGE = Gtk2::Gdk::Drawable	PREFIX = gdk_

 ## void gdk_draw_line (GdkDrawable *drawable, GdkGC *gc, gint x1_, gint y1_, gint x2_, gint y2_)
void
gdk_draw_line (drawable, gc, x1_, y1_, x2_, y2_)
	GdkDrawable *drawable
	GdkGC *gc
	gint x1_
	gint y1_
	gint x2_
	gint y2_

 ## void gdk_draw_rectangle (GdkDrawable *drawable, GdkGC *gc, gboolean filled, gint x, gint y, gint width, gint height)
void
gdk_draw_rectangle (drawable, gc, filled, x, y, width, height)
	GdkDrawable *drawable
	GdkGC *gc
	gboolean filled
	gint x
	gint y
	gint width
	gint height

 ## void gdk_draw_arc (GdkDrawable *drawable, GdkGC *gc, gboolean filled, gint x, gint y, gint width, gint height, gint angle1, gint angle2)
void
gdk_draw_arc (drawable, gc, filled, x, y, width, height, angle1, angle2)
	GdkDrawable *drawable
	GdkGC *gc
	gboolean filled
	gint x
	gint y
	gint width
	gint height
	gint angle1
	gint angle2

 ## FIXME do custom perl stack handling to read the points
 ## void gdk_draw_polygon (GdkDrawable *drawable, GdkGC *gc, gboolean filled, GdkPoint *points, gint npoints)
 ##void
 ##gdk_draw_polygon (drawable, gc, filled, points, npoints)
 ##	GdkDrawable *drawable
 ##	GdkGC *gc
 ##	gboolean filled
 ##	GdkPoint *points
 ##	gint npoints

 ## void gdk_draw_drawable (GdkDrawable *drawable, GdkGC *gc, GdkDrawable *src, gint xsrc, gint ysrc, gint xdest, gint ydest, gint width, gint height)
void
gdk_draw_drawable (drawable, gc, src, xsrc, ysrc, xdest, ydest, width, height)
	GdkDrawable *drawable
	GdkGC *gc
	GdkDrawable *src
	gint xsrc
	gint ysrc
	gint xdest
	gint ydest
	gint width
	gint height

 ## void gdk_draw_image (GdkDrawable *drawable, GdkGC *gc, GdkImage *image, gint xsrc, gint ysrc, gint xdest, gint ydest, gint width, gint height)
void
gdk_draw_image (drawable, gc, image, xsrc, ysrc, xdest, ydest, width, height)
	GdkDrawable *drawable
	GdkGC *gc
	GdkImage *image
	gint xsrc
	gint ysrc
	gint xdest
	gint ydest
	gint width
	gint height

 ## FIXME do custom perl stack handling to read the points
 #### void gdk_draw_points (GdkDrawable *drawable, GdkGC *gc, GdkPoint *points, gint npoints)
 ##void
 ##gdk_draw_points (drawable, gc, points, npoints)
 ##       GdkDrawable *drawable
 ##       GdkGC *gc
 ##       GdkPoint *points
 ##       gint npoints
 ##
 ## FIXME do custom perl stack handling to read the segments
 #### void gdk_draw_segments (GdkDrawable *drawable, GdkGC *gc, GdkSegment *segs, gint nsegs)
 ##void
 ##gdk_draw_segments (drawable, gc, segs, nsegs)
 ##	GdkDrawable *drawable
 ##	GdkGC *gc
 ##	GdkSegment *segs
 ##	gint nsegs
 ##
 ## FIXME do custom perl stack handling to read the points
 ## ## void gdk_draw_lines (GdkDrawable *drawable, GdkGC *gc, GdkPoint *points, gint npoints)
 ##void
 ##gdk_draw_lines (drawable, gc, points, npoints)
 ##	GdkDrawable *drawable
 ##	GdkGC *gc
 ##	GdkPoint *points
 ##	gint npoints

#if GTK_CHECK_VERSION(2,2,0)

 ## void gdk_draw_pixbuf (GdkDrawable *drawable, GdkGC *gc, GdkPixbuf *pixbuf, gint src_x, gint src_y, gint dest_x, gint dest_y, gint width, gint height, GdkRgbDither dither, gint x_dither, gint y_dither)
void
gdk_draw_pixbuf (drawable, gc, pixbuf, src_x, src_y, dest_x, dest_y, width, height, dither, x_dither, y_dither)
	GdkDrawable *drawable
	GdkGC *gc
	GdkPixbuf *pixbuf
	gint src_x
	gint src_y
	gint dest_x
	gint dest_y
	gint width
	gint height
	GdkRgbDither dither
	gint x_dither
	gint y_dither

#endif

## ## void gdk_draw_glyphs (GdkDrawable *drawable, GdkGC *gc, PangoFont *font, gint x, gint y, PangoGlyphString *glyphs)
##void
##gdk_draw_glyphs (drawable, gc, font, x, y, glyphs)
##	GdkDrawable *drawable
##	GdkGC *gc
##	PangoFont *font
##	gint x
##	gint y
##	PangoGlyphString *glyphs
##
## ## void gdk_draw_layout_line (GdkDrawable *drawable, GdkGC *gc, gint x, gint y, PangoLayoutLine *line)
##void
##gdk_draw_layout_line (drawable, gc, x, y, line)
##	GdkDrawable *drawable
##	GdkGC *gc
##	gint x
##	gint y
##	PangoLayoutLine *line
##
## ## void gdk_draw_layout (GdkDrawable *drawable, GdkGC *gc, gint x, gint y, PangoLayout *layout)
##void
##gdk_draw_layout (drawable, gc, x, y, layout)
##	GdkDrawable *drawable
##	GdkGC *gc
##	gint x
##	gint y
##	PangoLayout *layout
##
## ## void gdk_draw_layout_line_with_colors (GdkDrawable *drawable, GdkGC *gc, gint x, gint y, PangoLayoutLine *line, GdkColor *foreground, GdkColor *background)
##void
##gdk_draw_layout_line_with_colors (drawable, gc, x, y, line, foreground, background)
##	GdkDrawable *drawable
##	GdkGC *gc
##	gint x
##	gint y
##	PangoLayoutLine *line
##	GdkColor *foreground
##	GdkColor *background
##
## ## void gdk_draw_layout_with_colors (GdkDrawable *drawable, GdkGC *gc, gint x, gint y, PangoLayout *layout, GdkColor *foreground, GdkColor *background)
##void
##gdk_draw_layout_with_colors (drawable, gc, x, y, layout, foreground, background)
##	GdkDrawable *drawable
##	GdkGC *gc
##	gint x
##	gint y
##	PangoLayout *layout
##	GdkColor *foreground
##	GdkColor *background

 ## GdkImage* gdk_drawable_get_image (GdkDrawable *drawable, gint x, gint y, gint width, gint height)
GdkImage*
gdk_drawable_get_image (drawable, x, y, width, height)
	GdkDrawable *drawable
	gint x
	gint y
	gint width
	gint height

