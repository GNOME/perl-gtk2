#include "gtk2perl.h"

MODULE = Gtk2::Gdk::Pixbuf	PACKAGE = Gtk2::Gdk::Pixbuf	PREFIX = gdk_pixbuf_

 ## void gdk_pixbuf_render_to_drawable (GdkPixbuf *pixbuf, GdkDrawable *drawable, GdkGC *gc, int src_x, int src_y, int dest_x, int dest_y, int width, int height, GdkRgbDither dither, int x_dither, int y_dither)
void
gdk_pixbuf_render_to_drawable (pixbuf, drawable, gc, src_x, src_y, dest_x, dest_y, width, height, dither, x_dither, y_dither)
	GdkPixbuf *pixbuf
	GdkDrawable *drawable
	GdkGC *gc
	int src_x
	int src_y
	int dest_x
	int dest_y
	int width
	int height
	GdkRgbDither dither
	int x_dither
	int y_dither

 ## void gdk_pixbuf_render_to_drawable_alpha (GdkPixbuf *pixbuf, GdkDrawable *drawable, int src_x, int src_y, int dest_x, int dest_y, int width, int height, GdkPixbufAlphaMode alpha_mode, int alpha_threshold, GdkRgbDither dither, int x_dither, int y_dither)
void
gdk_pixbuf_render_to_drawable_alpha (pixbuf, drawable, src_x, src_y, dest_x, dest_y, width, height, alpha_mode, alpha_threshold, dither, x_dither, y_dither)
	GdkPixbuf *pixbuf
	GdkDrawable *drawable
	int src_x
	int src_y
	int dest_x
	int dest_y
	int width
	int height
	GdkPixbufAlphaMode alpha_mode
	int alpha_threshold
	GdkRgbDither dither
	int x_dither
	int y_dither

## ## void gdk_pixbuf_render_pixmap_and_mask_for_colormap (GdkPixbuf *pixbuf, GdkColormap *colormap, GdkPixmap **pixmap_return, GdkBitmap **mask_return, int alpha_threshold)
##void
##gdk_pixbuf_render_pixmap_and_mask_for_colormap (pixbuf, colormap, pixmap_return, mask_return, alpha_threshold)
##	GdkPixbuf *pixbuf
##	GdkColormap *colormap
##	GdkPixmap **pixmap_return
##	GdkBitmap **mask_return
##	int alpha_threshold
##
## ## void gdk_pixbuf_render_pixmap_and_mask (GdkPixbuf *pixbuf, GdkPixmap **pixmap_return, GdkBitmap **mask_return, int alpha_threshold)
##void
##gdk_pixbuf_render_pixmap_and_mask (pixbuf, pixmap_return, mask_return, alpha_threshold)
##	GdkPixbuf *pixbuf
##	GdkPixmap **pixmap_return
##	GdkBitmap **mask_return
##	int alpha_threshold
##
