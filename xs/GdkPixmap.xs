#include "gtk2perl.h"

SV *
newSVGdkBitmap_noinc (GdkBitmap * bitmap)
{
	if (!bitmap)
		return &PL_sv_undef;
	return sv_bless (gperl_new_object (G_OBJECT (bitmap), TRUE),
			 gv_stashpv ("Gtk2::Gdk::Bitmap", TRUE));
}


MODULE = Gtk2::Gdk::Pixmap	PACKAGE = Gtk2::Gdk::Pixmap	PREFIX = gdk_pixmap_

BOOT:
	gperl_set_isa ("Gtk2::Gdk::Bitmap", "Gtk2::Gdk::Drawable");

GdkPixmap_noinc *
gdk_pixmap_new (class, drawable, width, height, depth)
	SV * class
	GdkDrawable * drawable
	gint width
	gint height
	gint depth
    C_ARGS:
	drawable, width, height, depth

## ## GdkBitmap* gdk_bitmap_create_from_data (GdkDrawable *drawable, const gchar *data, gint width, gint height)
##GdkBitmap*
##gdk_bitmap_create_from_data (drawable, data, width, height)
##	GdkDrawable *drawable
##	const gchar *data
##	gint width
##	gint height
##
## ## GdkPixmap* gdk_pixmap_create_from_data (GdkDrawable *drawable, const gchar *data, gint width, gint height, gint depth, GdkColor *fg, GdkColor *bg)
##GdkPixmap*
##gdk_pixmap_create_from_data (drawable, data, width, height, depth, fg, bg)
##	GdkDrawable *drawable
##	const gchar *data
##	gint width
##	gint height
##	gint depth
##	GdkColor *fg
##	GdkColor *bg

 ## GdkPixmap* gdk_pixmap_create_from_xpm (GdkDrawable *drawable, GdkBitmap **mask, GdkColor *transparent_color, const gchar *filename)
void
gdk_pixmap_create_from_xpm (class, drawable, transparent_color, filename)
	SV * class
	GdkDrawable *drawable
	GdkColor_ornull *transparent_color
	const gchar *filename
    PREINIT:
	GdkPixmap * pixmap;
	GdkBitmap * mask;
    PPCODE:
	pixmap = gdk_pixmap_create_from_xpm (drawable, &mask,
					     transparent_color, filename);
	EXTEND (SP, 2);
	PUSHs (sv_2mortal (newSVGdkPixmap_noinc (pixmap)));
	PUSHs (sv_2mortal (newSVGdkBitmap_noinc (mask)));

 ## GdkPixmap* gdk_pixmap_colormap_create_from_xpm (GdkDrawable *drawable, GdkColormap *colormap, GdkBitmap **mask, GdkColor *transparent_color, const gchar *filename)
void
gdk_pixmap_colormap_create_from_xpm (class, drawable, colormap, transparent_color, filename)
	SV * class
	GdkDrawable *drawable
	GdkColormap *colormap
	GdkColor_ornull *transparent_color
	const gchar *filename
    PREINIT:
	GdkPixmap * pixmap;
	GdkBitmap * mask;
    PPCODE:
	pixmap = gdk_pixmap_colormap_create_from_xpm (drawable, colormap,
					&mask, transparent_color, filename);
	EXTEND (SP, 2);
	PUSHs (sv_2mortal (newSVGdkPixmap_noinc (pixmap)));
	PUSHs (sv_2mortal (newSVGdkBitmap_noinc (mask)));

## ## GdkPixmap* gdk_pixmap_create_from_xpm_d (GdkDrawable *drawable, GdkBitmap **mask, GdkColor *transparent_color, gchar **data)
##GdkPixmap*
##gdk_pixmap_create_from_xpm_d (drawable, mask, transparent_color, data)
##	GdkDrawable *drawable
##	GdkBitmap **mask
##	GdkColor *transparent_color
##	gchar **data

## ## GdkPixmap* gdk_pixmap_colormap_create_from_xpm_d (GdkDrawable *drawable, GdkColormap *colormap, GdkBitmap **mask, GdkColor *transparent_color, gchar **data)
##GdkPixmap*
##gdk_pixmap_colormap_create_from_xpm_d (drawable, colormap, mask, transparent_color, data)
##	GdkDrawable *drawable
##	GdkColormap *colormap
##	GdkBitmap **mask
##	GdkColor *transparent_color
##	gchar **data

## ## GdkPixmap* gdk_pixmap_lookup (GdkNativeWindow anid)
##GdkPixmap*
##gdk_pixmap_lookup (anid)
##	GdkNativeWindow anid
##
## ## GdkPixmap* gdk_pixmap_foreign_new_for_display (GdkDisplay *display, GdkNativeWindow anid)
##GdkPixmap*
##gdk_pixmap_foreign_new_for_display (display, anid)
##	GdkDisplay *display
##	GdkNativeWindow anid
##
## ## GdkPixmap* gdk_pixmap_lookup_for_display (GdkDisplay *display, GdkNativeWindow anid)
##GdkPixmap*
##gdk_pixmap_lookup_for_display (display, anid)
##	GdkDisplay *display
##	GdkNativeWindow anid
##
