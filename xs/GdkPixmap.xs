/*
 * $Header$
 */

#include "gtk2perl.h"

static SV *
new_gdk_bitmap (GdkBitmap * bitmap, gboolean noinc)
{
	if (!bitmap)
		return &PL_sv_undef;
	return sv_bless (gperl_new_object (G_OBJECT (bitmap), noinc),
			 gv_stashpv ("Gtk2::Gdk::Bitmap", TRUE));
}

SV *
newSVGdkBitmap (GdkBitmap * bitmap)
{
	return new_gdk_bitmap (bitmap, FALSE);
}

SV *
newSVGdkBitmap_noinc (GdkBitmap * bitmap)
{
	return new_gdk_bitmap (bitmap, TRUE);
}


MODULE = Gtk2::Gdk::Pixmap	PACKAGE = Gtk2::Gdk::Bitmap	PREFIX = gdk_bitmap_

BOOT:
	gperl_set_isa ("Gtk2::Gdk::Bitmap", "Gtk2::Gdk::Drawable");

 ## GdkBitmap* gdk_bitmap_create_from_data (class, GdkDrawable *drawable, const gchar *data, gint width, gint height)
### intentionally switched to char instead of gchar
GdkBitmap_noinc *
gdk_bitmap_create_from_data (class, drawable, data, width, height)
	SV * class
	GdkDrawable_ornull *drawable
	const char *data
	gint width
	gint height
    C_ARGS:
	drawable, data, width, height

MODULE = Gtk2::Gdk::Pixmap	PACKAGE = Gtk2::Gdk::Pixmap	PREFIX = gdk_pixmap_

GdkPixmap_noinc *
gdk_pixmap_new (class, drawable, width, height, depth)
	SV * class
	GdkDrawable_ornull * drawable
	gint width
	gint height
	gint depth
    C_ARGS:
	drawable, width, height, depth

 ## GdkPixmap* gdk_pixmap_create_from_data (GdkDrawable *drawable, const gchar *data, gint width, gint height, gint depth, GdkColor *fg, GdkColor *bg)
### intentionally switched to char instead of gchar
GdkPixmap_noinc *
gdk_pixmap_create_from_data (class, drawable, data, width, height, depth, fg, bg)
	SV * class
	GdkDrawable *drawable
	const char *data
	gint width
	gint height
	gint depth
	GdkColor *fg
	GdkColor *bg
    C_ARGS:
	drawable, data, width, height, depth, fg, bg

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
##void
##gdk_pixmap_create_from_xpm_d (class, drawable, transparent_color, data)
##	SV * class
##	GdkDrawable *drawable
##	GdkColor_ornull *transparent_color
##	gchar **data
##    PREINIT:
##	GdkBitmap * mask;
##	GdkPixmap * pixmap;
##    PPCODE:
##	EXTEND (SP, 2);
##	PUSHs (sv_2mortal (newSVGdkPixmap_noinc (pixmap)));
##	PUSHs (sv_2mortal (newSVGdkBitmap_noinc (mask)));

## ## GdkPixmap* gdk_pixmap_colormap_create_from_xpm_d (GdkDrawable *drawable, GdkColormap *colormap, GdkBitmap **mask, GdkColor *transparent_color, gchar **data)
##void
##gdk_pixmap_colormap_create_from_xpm_d (class, drawable, colormap, transparent_color, data)
##	SV * class
##	GdkDrawable_ornull *drawable
##	GdkColormap_ornull *colormap
##	GdkColor_ornull *transparent_color
##	gchar **data
##    PREINIT:
##	GdkBitmap * mask;
##	GdkPixmap * pixmap;
##    PPCODE:
##	EXTEND (SP, 2);
##	PUSHs (sv_2mortal (newSVGdkPixmap_noinc (pixmap)));
##	PUSHs (sv_2mortal (newSVGdkBitmap_noinc (mask)));

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
