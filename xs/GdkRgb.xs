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
 #include "gtk2perl.h"

/*
####MODULE = Gtk2::Gdk::Rgb	PACKAGE = Gtk2::Gdk::Drawable	PREFIX = gdk_

 ## no longer does anything, no need to bind it
##  void gdk_rgb_init (void) 

 ## deprecated
##  gulong gdk_rgb_xpixel_from_rgb (guint32 rgb) G_GNUC_CONST 
*/

guchar *
SvImageDataPointer (SV * sv)
{
	if (SvIOK (sv))
		return (guchar*) SvUV (sv);
	else if (SvPOK (sv))
		return SvPV_nolen (sv);
	else
		croak ("expecting either a string containing pixel data or "
		       "an integer pointing to the underlying C image data "
		       "buffer");
}

MODULE = Gtk2::Gdk::Rgb	PACKAGE = Gtk2::Gdk::GC	PREFIX = gdk_

##  void gdk_rgb_gc_set_foreground (GdkGC *gc, guint32 rgb) 
void gdk_rgb_gc_set_foreground (GdkGC * gc, guint32 rgb)
    ALIAS:
	Gtk2::Gdk::GC::rgb_gc_set_foreground = 0
	Gtk2::Gdk::GC::set_rgb_foreground = 1

##  void gdk_rgb_gc_set_background (GdkGC *gc, guint32 rgb) 
void gdk_rgb_gc_set_background (GdkGC * gc, guint32 rgb)
    ALIAS:
	Gtk2::Gdk::GC::rgb_gc_set_background = 0
	Gtk2::Gdk::GC::set_rgb_background = 1

MODULE = Gtk2::Gdk::Rgb	PACKAGE = Gtk2::Gdk::Colormap	PREFIX = gdk_

##  void gdk_rgb_find_color (GdkColormap *colormap, GdkColor *color) 
void gdk_rgb_find_color (GdkColormap *colormap, GdkColor *color)

MODULE = Gtk2::Gdk::Rgb	PACKAGE = Gtk2::Gdk::Drawable	PREFIX = gdk_

##  void gdk_draw_rgb_image (GdkDrawable *drawable, GdkGC *gc, gint x, gint y, gint width, gint height, GdkRgbDither dith, guchar *rgb_buf, gint rowstride) 
##  void gdk_draw_rgb_32_image (GdkDrawable *drawable, GdkGC *gc, gint x, gint y, gint width, gint height, GdkRgbDither dith, guchar *buf, gint rowstride) 
##  void gdk_draw_gray_image (GdkDrawable *drawable, GdkGC *gc, gint x, gint y, gint width, gint height, GdkRgbDither dith, guchar *buf, gint rowstride) 
void
gdk_draw_rgb_image (drawable, gc, x, y, width, height, dith, buf, rowstride)
	GdkDrawable *drawable
	GdkGC *gc
	gint x
	gint y
	gint width
	gint height
	GdkRgbDither dith
	SV * buf
	gint rowstride
    ALIAS:
	draw_rgb_image = 0
	draw_rgb_32_image = 1
	draw_gray_image = 2
    CODE:
	switch (ix) {
	    case 0:
		gdk_draw_rgb_image (drawable, gc, x, y, width, height,
		                    dith, SvImageDataPointer(buf),
		                    rowstride);
		break;
	    case 1:
		gdk_draw_rgb_32_image (drawable, gc, x, y, width, height,
		                       dith, SvImageDataPointer(buf),
		                       rowstride);
		break;
	    case 2:
		gdk_draw_gray_image (drawable, gc, x, y, width, height,
		                     dith, SvImageDataPointer(buf),
		                     rowstride);
		break;
	}

##  void gdk_draw_rgb_image_dithalign (GdkDrawable *drawable, GdkGC *gc, gint x, gint y, gint width, gint height, GdkRgbDither dith, guchar *rgb_buf, gint rowstride, gint xdith, gint ydith) 
##  void gdk_draw_rgb_32_image_dithalign (GdkDrawable *drawable, GdkGC *gc, gint x, gint y, gint width, gint height, GdkRgbDither dith, guchar *buf, gint rowstride, gint xdith, gint ydith) 
void
gdk_draw_rgb_image_dithalign (drawable, gc, x, y, width, height, dith, rgb_buf, rowstride, xdith, ydith)
	GdkDrawable *drawable
	GdkGC *gc
	gint x
	gint y
	gint width
	gint height
	GdkRgbDither dith
	SV *rgb_buf
	gint rowstride
	gint xdith
	gint ydith
    ALIAS:
	draw_rgb_image_dithalign = 0
	draw_rgb_32_image_dithalign = 1
    CODE:
	if (ix == 1)
		gdk_draw_rgb_32_image_dithalign (drawable, gc, x, y,
		                                 width, height, dith,
		                                 SvImageDataPointer (rgb_buf),
		                                 rowstride, xdith, ydith);
	else
		gdk_draw_rgb_image_dithalign (drawable, gc, x, y,
		                              width, height, dith,
		                              SvImageDataPointer(rgb_buf),
		                              rowstride, xdith, ydith);

# FIXME no typemap for GdkRgbCmap
####  void gdk_draw_indexed_image (GdkDrawable *drawable, GdkGC *gc, gint x, gint y, gint width, gint height, GdkRgbDither dith, guchar *buf, gint rowstride, GdkRgbCmap *cmap) 
##void
##gdk_draw_indexed_image (drawable, gc, x, y, width, height, dith, buf, rowstride, cmap)
##	GdkDrawable *drawable
##	GdkGC *gc
##	gint x
##	gint y
##	gint width
##	gint height
##	GdkRgbDither dith
##	guchar *buf
##	gint rowstride
##	GdkRgbCmap *cmap

##MODULE = Gtk2::Gdk::Rgb	PACKAGE = Gtk2::Gdk::Cmap	PREFIX = gdk_rgb_cmap_
##
# FIXME no typemap for GdkRgbCmap
####  GdkRgbCmap *gdk_rgb_cmap_new (guint32 *colors, gint n_colors) 
##GdkRgbCmap *
##gdk_rgb_cmap_new (class, color, ...)
##	SV * class
##	guint32 color
##    PREINIT:
##	guint32 *colors;
##	gint n_colors;
##	int i;
##    CODE:
##	n_colors = items - 1;
##	colors = g_new (sizeof (guint32) * n_colors);
##	for (i = 1 ; i < items ; i++)
##		colors[i-1] = SvIV (ST (i));
##	RETVAL = gdk_rgb_cmap_new (colors, n_colors);
##	g_free (colors);
##    OUTPUT:
##	RETVAL
##
####  void gdk_rgb_cmap_free (GdkRgbCmap *cmap) 

MODULE = Gtk2::Gdk::Rgb	PACKAGE = Gtk2::Gdk::Rgb	PREFIX = gdk_rgb_

##  void gdk_rgb_set_verbose (gboolean verbose) 
void
gdk_rgb_set_verbose (class, verbose)
	SV * class
	gboolean verbose
    C_ARGS:
	verbose

##  void gdk_rgb_set_install (gboolean install) 
void
gdk_rgb_set_install (class, install)
	SV * class
	gboolean install
    C_ARGS:
	install

##  void gdk_rgb_set_min_colors (gint min_colors) 
void
gdk_rgb_set_min_colors (class, min_colors)
	SV * class
	gint min_colors
    C_ARGS:
	min_colors

 ## no longer needed
##  GdkColormap *gdk_rgb_get_colormap (void) 
##  GdkVisual * gdk_rgb_get_visual (void) 

##  gboolean gdk_rgb_ditherable (void) 
gboolean
gdk_rgb_ditherable (class)
	SV *class
    C_ARGS:
	/*void*/

