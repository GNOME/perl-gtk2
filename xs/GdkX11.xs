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
#ifdef GDK_WINDOWING_X11
# include <gdk/gdkx.h>
#endif /* GDK_WINDOWING_X11 */

/* 
 * anything marked broken or deprecated in gdk/gdkx.h has been omitted here.
 * this binding is not complete, because i think most of the functions are
 * of interest maybe to 1% of developers, and we'd be best off adding them
 * as needed to avoid bloat.
 *
 * there is no typemap for Display*, Screen*, etc, and indeed no perl-side
 * functions to manipulate them, so they are out for the time being.
 *
 * XID/XWINDOW is treated as UV.
 *
 * all XS blocks are wrapped in #ifdef GDK_WINDOWING_X11 to make sure this
 * stuff doesn't exist when wrapping gdk compiled for other backends.
 */


MODULE = Gtk2::Gdk::X11	PACKAGE = Gtk2::Gdk::Drawable	PREFIX = gdk_x11_drawable_

#ifdef GDK_WINDOWING_X11

 ## no typemap for Display*
###define GDK_WINDOW_XDISPLAY(win)      (gdk_x11_drawable_get_xdisplay (((GdkWindowObject *)win)->impl))
###define GDK_PIXMAP_XDISPLAY(win)      (gdk_x11_drawable_get_xdisplay (((GdkPixmapObject *)win)->impl))
###define GDK_DRAWABLE_XDISPLAY(win)    (gdk_x11_drawable_get_xdisplay (win))
##Display *gdk_x11_drawable_get_xdisplay    (GdkDrawable *drawable);


###define GDK_WINDOW_XID(win)           (gdk_x11_drawable_get_xid (win))
###define GDK_WINDOW_XWINDOW(win)       (gdk_x11_drawable_get_xid (win))
###define GDK_PIXMAP_XID(win)           (gdk_x11_drawable_get_xid (win))
###define GDK_DRAWABLE_XID(win)         (gdk_x11_drawable_get_xid (win))
##XID      gdk_x11_drawable_get_xid         (GdkDrawable *drawable);
UV gdk_x11_drawable_get_xid (GdkDrawable *drawable);
    ALIAS:
	get_xid = 0
	XID     = 1
        XWINDOW = 2

#endif /* GDK_WINDOWING_X11 */

 ## there are no typemaps for most of these.
###define GDK_IMAGE_XDISPLAY(image) (gdk_x11_image_get_xdisplay (image))
##Display *gdk_x11_image_get_xdisplay (GdkImage *image);
###define GDK_IMAGE_XIMAGE(image) (gdk_x11_image_get_ximage (image))
##XImage *gdk_x11_image_get_ximage (GdkImage *image);
##
###define GDK_COLORMAP_XDISPLAY(cmap) (gdk_x11_colormap_get_xdisplay (cmap))
##Display *gdk_x11_colormap_get_xdisplay (GdkColormap *colormap);
###define GDK_COLORMAP_XCOLORMAP(cmap) (gdk_x11_colormap_get_xcolormap (cmap))
##Colormap gdk_x11_colormap_get_xcolormap (GdkColormap *colormap);
##
###define GDK_CURSOR_XDISPLAY(cursor) (gdk_x11_cursor_get_xdisplay (cursor))
##Display *gdk_x11_cursor_get_xdisplay (GdkCursor *cursor);
###define GDK_CURSOR_XCURSOR(cursor) (gdk_x11_cursor_get_xcursor (cursor))
##Cursor gdk_x11_cursor_get_xcursor (GdkCursor *cursor);
##
###define GDK_DISPLAY_XDISPLAY(display) (gdk_x11_display_get_xdisplay (display))
##Display *gdk_x11_display_get_xdisplay (GdkDisplay *display);
##
###define GDK_VISUAL_XVISUAL(visual) (gdk_x11_visual_get_xvisual (visual))
##Visual * gdk_x11_visual_get_xvisual (GdkVisual *visual);
##
###define GDK_GC_XDISPLAY(gc) (gdk_x11_gc_get_xdisplay (gc))
##Display *gdk_x11_gc_get_xdisplay (GdkGC *gc);
###define GDK_GC_XGC(gc) (gdk_x11_gc_get_xgc (gc))
##GC gdk_x11_gc_get_xgc (GdkGC *gc);
##
###define GDK_SCREEN_XDISPLAY(screen) (gdk_x11_display_get_xdisplay (gdk_screen_get_display (screen)))
###define GDK_SCREEN_XSCREEN(screen) (gdk_x11_screen_get_xscreen (screen))
##Screen * gdk_x11_screen_get_xscreen (GdkScreen *screen);
###define GDK_SCREEN_XNUMBER(screen) (gdk_x11_screen_get_screen_number (screen))
##int gdk_x11_screen_get_screen_number (GdkScreen *screen);
##const char* gdk_x11_screen_get_window_manager_name (GdkScreen *screen);
##GdkVisual* gdk_x11_screen_lookup_visual (GdkScreen *screen, VisualID xvisualid);

MODULE = Gtk2::Gdk::X11	PACKAGE = Gtk2::Gdk::X11	PREFIX = gdk_x11_

#if defined(GDK_WINDOWING_X11) && !defined(GDK_MULTIHEAD_SAFE)

###ifndef GDK_MULTIHEAD_SAFE

##Window gdk_x11_get_default_root_xwindow (void);

##Display *gdk_x11_get_default_xdisplay (void);
##gint gdk_x11_get_default_screen (void);
##extern Display *gdk_display;
###define GDK_DISPLAY() gdk_display
###define GDK_ROOT_WINDOW() (gdk_x11_get_default_root_xwindow ())
##GdkVisual* gdkx_visual_get (VisualID xvisualid);
###endif
##
##GdkColormap *gdk_x11_colormap_foreign_new (GdkVisual *visual,	Colormap xcolormap);
##
##     /* Return the Gdk* for a particular XID */
##gpointer gdk_xid_table_lookup_for_display (GdkDisplay *display, XID xid);
##guint32 gdk_x11_get_server_time (GdkWindow *window);
##
##/* returns TRUE if we support the given WM spec feature */
##gboolean gdk_x11_screen_supports_net_wm_hint (GdkScreen *screen, GdkAtom property);
##
###ifndef GDK_MULTIHEAD_SAFE
##gpointer gdk_xid_table_lookup (XID xid);
##gboolean gdk_net_wm_supports (GdkAtom property);
##void gdk_x11_grab_server (void);
##void gdk_x11_ungrab_server (void);
###endif
##
##GdkDisplay *gdk_x11_lookup_xdisplay (Display *xdisplay);
##
##
##/* Functions to get the X Atom equivalent to the GdkAtom */
##Atomgdk_x11_atom_to_xatom_for_display (GdkDisplay *display, GdkAtom atom);
##GdkAtom gdk_x11_xatom_to_atom_for_display (GdkDisplay *display, Atom xatom);
##Atom gdk_x11_get_xatom_by_name_for_display (GdkDisplay *display, const gchar *atom_name);
##G_CONST_RETURN gchar *gdk_x11_get_xatom_name_for_display (GdkDisplay *display, Atom xatom);
###ifndef GDK_MULTIHEAD_SAFE
##Atom gdk_x11_atom_to_xatom (GdkAtom atom);
##GdkAtom gdk_x11_xatom_to_atom (Atom xatom);
##Atom gdk_x11_get_xatom_by_name (const gchar *atom_name);
##G_CONST_RETURN gchar *gdk_x11_get_xatom_name (Atom xatom);
###endif

#endif

MODULE = Gtk2::Gdk::X11	PACKAGE = Gtk2::Gdk::Display	PREFIX = gdk_x11_display_

#### GdkDisplay didn't exist before 2.2.x

#if defined(GDK_WINDOWING_X11) && defined(GDK_TYPE_DISPLAY)

void gdk_x11_display_grab (GdkDisplay *display);

void gdk_x11_display_ungrab (GdkDisplay *display);

#endif
