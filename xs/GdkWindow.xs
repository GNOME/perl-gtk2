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

/* ------------------------------------------------------------------------- */

SV *
newSVGdkWindowAttr (GdkWindowAttr *attr)
{
	HV *object = newHV ();

	if (attr && attr->x && attr->y) {
		hv_store (object, "title", 5, newSVGChar (attr->title), 0);
		hv_store (object, "event_mask", 10, newSVGdkEventMask (attr->event_mask), 0);
		hv_store (object, "x", 1, newSViv (attr->x), 0);
		hv_store (object, "y", 1, newSViv (attr->y), 0);
		hv_store (object, "width", 5, newSViv (attr->width), 0);
		hv_store (object, "height", 6, newSViv (attr->height), 0);
		hv_store (object, "wclass", 6, newSVGdkWindowClass (attr->wclass), 0);
		hv_store (object, "visual", 6, newSVGdkVisual (attr->visual), 0);
		hv_store (object, "colormap", 8, newSVGdkColormap (attr->colormap), 0);
		hv_store (object, "window_type", 11, newSVGdkWindowType (attr->window_type), 0);
		hv_store (object, "cursor", 6, newSVGdkCursor (attr->cursor), 0);
		hv_store (object, "wmclass_name", 12, newSVGChar (attr->wmclass_name), 0);
		hv_store (object, "wmclass_class", 13, newSVGChar (attr->wmclass_class), 0);
		hv_store (object, "override_redirect", 17, newSVuv (attr->override_redirect), 0);
	}

	return sv_bless (newRV_noinc ((SV *) object),
	                 gv_stashpv ("Gtk2::Gdk::Window::Attr", 1));
}

#define GTK2PERL_WINDOW_ATTR_FETCH(member, key, type) \
	member = hv_fetch (hv, key, strlen (key), FALSE); \
	if (member) attr->member = type (*member);

GdkWindowAttr *
SvGdkWindowAttrReal (SV *object, GdkWindowAttributesType *mask)
{
	HV *hv = (HV *) SvRV (object);
	SV **title, **event_mask, **x, **y, **width, **height, **wclass,
	   **visual, **colormap, **window_type, **cursor, **wmclass_name,
	   **wmclass_class, **override_redirect;

	GdkWindowAttr *attr = gperl_alloc_temp (sizeof (GdkWindowAttr));

	if (object && SvOK (object) && SvROK (object) && SvTYPE (SvRV (object)) == SVt_PVHV) {
		GTK2PERL_WINDOW_ATTR_FETCH (title, "title", SvGChar);
		GTK2PERL_WINDOW_ATTR_FETCH (event_mask, "event_mask", SvGdkEventMask);
		GTK2PERL_WINDOW_ATTR_FETCH (x, "x", SvIV);
		GTK2PERL_WINDOW_ATTR_FETCH (y, "y", SvIV);
		GTK2PERL_WINDOW_ATTR_FETCH (width, "width", SvIV);
		GTK2PERL_WINDOW_ATTR_FETCH (height, "height", SvIV);
		GTK2PERL_WINDOW_ATTR_FETCH (wclass, "wclass", SvGdkWindowClass);
		GTK2PERL_WINDOW_ATTR_FETCH (visual, "visual", SvGdkVisual);
		GTK2PERL_WINDOW_ATTR_FETCH (colormap, "colormap", SvGdkColormap);
		GTK2PERL_WINDOW_ATTR_FETCH (window_type, "window_type", SvGdkWindowType);
		GTK2PERL_WINDOW_ATTR_FETCH (cursor, "cursor", SvGdkCursor);
		GTK2PERL_WINDOW_ATTR_FETCH (wmclass_name, "wmclass_name", SvGChar);
		GTK2PERL_WINDOW_ATTR_FETCH (wmclass_class, "wmclass_class", SvGChar);
		GTK2PERL_WINDOW_ATTR_FETCH (override_redirect, "override_redirect", SvUV);

		if (mask) {
			if (title) *mask |= GDK_WA_TITLE;
			if (x) *mask |= GDK_WA_X;
			if (y) *mask |= GDK_WA_Y;
			if (wmclass_name && wmclass_class) *mask |= GDK_WA_WMCLASS;
			if (visual) *mask |= GDK_WA_VISUAL;
			if (colormap) *mask |= GDK_WA_COLORMAP;
			if (cursor) *mask |= GDK_WA_CURSOR;
			if (override_redirect) *mask |= GDK_WA_NOREDIR;
		}
	}

	return attr;
}

GdkWindowAttr *
SvGdkWindowAttr (SV *object)
{
	return SvGdkWindowAttrReal (object, NULL);
}

/* ------------------------------------------------------------------------- */

static GPerlCallback *
gtk2perl_gdk_window_invalidate_maybe_recurse_func_create (SV * func, SV * data)
{
	GType param_types [] = {
		GDK_TYPE_WINDOW,
	};
	return gperl_callback_new (func, data, G_N_ELEMENTS (param_types),
				   param_types, G_TYPE_BOOLEAN);
}

static gboolean
gtk2perl_gdk_window_invalidate_maybe_recurse_func (GdkWindow *window,
			                           gpointer data)
{
	GPerlCallback * callback = (GPerlCallback*)data;
	GValue value = {0,};
	gboolean retval;

	g_value_init (&value, callback->return_type);
	gperl_callback_invoke (callback, &value, window);
	retval = g_value_get_boolean (&value);
	g_value_unset (&value);

	return retval;
}

/* ------------------------------------------------------------------------- */

MODULE = Gtk2::Gdk::Window	PACKAGE = Gtk2::Gdk::Window	PREFIX = gdk_window_

# FIXME: this leaks.
 ## GdkWindow* gdk_window_new (GdkWindow *parent, GdkWindowAttr *attributes, gint attributes_mask)
GdkWindow_noinc *
gdk_window_new (class, parent, attributes_ref)
	GdkWindow_ornull *parent
	SV *attributes_ref
    PREINIT:
	GdkWindowAttr *attributes;
	GdkWindowAttributesType attributes_mask;
    CODE:
	attributes = SvGdkWindowAttrReal (attributes_ref, &attributes_mask);
	RETVAL = gdk_window_new (parent, attributes, attributes_mask);
    OUTPUT:
	RETVAL

 ## void gdk_window_destroy (GdkWindow *window)
void
gdk_window_destroy (window)
	GdkWindow *window

 ## GdkWindowType gdk_window_get_window_type (GdkWindow *window)
GdkWindowType
gdk_window_get_window_type (window)
	GdkWindow *window

 ## GdkWindow* gdk_window_at_pointer (gint *win_x, gint *win_y)
=for apidoc
=for signature (window, win_x, win_y) = Gtk2::Gdk::Window->at_pointer
Returns window, a Gtk2::Gdk::Window and win_x and win_y, integers.
=cut
void
gdk_window_at_pointer (class)
    PREINIT:
	GdkWindow * window;
	gint win_x, win_y;
    PPCODE:
	window = gdk_window_at_pointer (&win_x, &win_y);
	EXTEND (SP, 3);
	PUSHs (sv_2mortal (newSVGdkWindow (window)));
	PUSHs (sv_2mortal (newSViv (win_x)));
	PUSHs (sv_2mortal (newSViv (win_y)));
	PERL_UNUSED_VAR (ax);

 ## void gdk_window_show (GdkWindow *window)
void
gdk_window_show (window)
	GdkWindow *window

 ## void gdk_window_hide (GdkWindow *window)
void
gdk_window_hide (window)
	GdkWindow *window

 ## void gdk_window_withdraw (GdkWindow *window)
void
gdk_window_withdraw (window)
	GdkWindow *window

 ## void gdk_window_show_unraised (GdkWindow *window)
void
gdk_window_show_unraised (window)
	GdkWindow *window

 ## void gdk_window_move (GdkWindow *window, gint x, gint y)
void
gdk_window_move (window, x, y)
	GdkWindow *window
	gint x
	gint y

 ## void gdk_window_resize (GdkWindow *window, gint width, gint height)
void
gdk_window_resize (window, width, height)
	GdkWindow *window
	gint width
	gint height

 ## void gdk_window_move_resize (GdkWindow *window, gint x, gint y, gint width, gint height)
void
gdk_window_move_resize (window, x, y, width, height)
	GdkWindow *window
	gint x
	gint y
	gint width
	gint height

 ## void gdk_window_reparent (GdkWindow *window, GdkWindow *new_parent, gint x, gint y)
void
gdk_window_reparent (window, new_parent, x, y)
	GdkWindow *window
	GdkWindow *new_parent
	gint x
	gint y

 ## void gdk_window_clear (GdkWindow *window)
void
gdk_window_clear (window)
	GdkWindow *window

 ## void gdk_window_clear_area (GdkWindow *window, gint x, gint y, gint width, gint height)
void
gdk_window_clear_area (window, x, y, width, height)
	GdkWindow *window
	gint x
	gint y
	gint width
	gint height

 ## void gdk_window_clear_area_e (GdkWindow *window, gint x, gint y, gint width, gint height)
void
gdk_window_clear_area_e (window, x, y, width, height)
	GdkWindow *window
	gint x
	gint y
	gint width
	gint height

 ## void gdk_window_raise (GdkWindow *window)
void
gdk_window_raise (window)
	GdkWindow *window

 ## void gdk_window_lower (GdkWindow *window)
void
gdk_window_lower (window)
	GdkWindow *window

 ## void gdk_window_focus (GdkWindow *window, guint32 timestamp)
void
gdk_window_focus (window, timestamp)
	GdkWindow *window
	guint32 timestamp

 ## use object data instead
 ## void gdk_window_set_user_data (GdkWindow *window, gpointer user_data)
void
gdk_window_set_user_data (window, user_data)
	GdkWindow *window
	gulong user_data
    C_ARGS:
	window, (gpointer) user_data

 ## void gdk_window_set_override_redirect (GdkWindow *window, gboolean override_redirect)
void
gdk_window_set_override_redirect (window, override_redirect)
	GdkWindow *window
	gboolean override_redirect

# FIXME needs a callback
 ## void gdk_window_add_filter (GdkWindow *window, GdkFilterFunc function, gpointer data)
 ##void
 ##gdk_window_add_filter (window, function, data)
 ##	GdkWindow_ornull *window
 ##	GdkFilterFunc function
 ##	gpointer data

# FIXME whoa!  we'd have to cache the callbacks to do this.
 ## void gdk_window_remove_filter (GdkWindow *window, GdkFilterFunc function, gpointer data)
 ##void
 ##gdk_window_remove_filter (window, function, data)
 ##	GdkWindow_ornull *window
 ##	GdkFilterFunc function
 ##	gpointer data

 ## void gdk_window_scroll (GdkWindow *window, gint dx, gint dy)
void
gdk_window_scroll (window, dx, dy)
	GdkWindow *window
	gint dx
	gint dy

void gdk_window_shape_combine_mask (GdkWindow * window, GdkBitmap * mask, gint x, gint y);

 ## void gdk_window_shape_combine_region (GdkWindow *window, GdkRegion *shape_region, gint offset_x, gint offset_y)
void
gdk_window_shape_combine_region (window, shape_region, offset_x, offset_y)
	GdkWindow *window
	GdkRegion *shape_region
	gint offset_x
	gint offset_y

 ## void gdk_window_set_child_shapes (GdkWindow *window)
void
gdk_window_set_child_shapes (window)
	GdkWindow *window

 ## void gdk_window_merge_child_shapes (GdkWindow *window)
void
gdk_window_merge_child_shapes (window)
	GdkWindow *window

 ## gboolean gdk_window_set_static_gravities (GdkWindow *window, gboolean use_static)
gboolean
gdk_window_set_static_gravities (window, use_static)
	GdkWindow *window
	gboolean use_static

 ## gboolean gdk_window_is_visible (GdkWindow *window)
gboolean
gdk_window_is_visible (window)
	GdkWindow *window

 ## gboolean gdk_window_is_viewable (GdkWindow *window)
gboolean
gdk_window_is_viewable (window)
	GdkWindow *window

 ## GdkWindowState gdk_window_get_state (GdkWindow *window)
GdkWindowState
gdk_window_get_state (window)
	GdkWindow *window

#ifndef GDK_MULTIHEAD_SAFE

GdkWindow* gdk_window_foreign_new (class, GdkNativeWindow anid);
    C_ARGS:
	anid

GdkWindow* gdk_window_lookup (class, GdkNativeWindow anid);
    C_ARGS:
	anid

#endif
 
#ifdef GDK_TYPE_DISPLAY
 
GdkWindow *gdk_window_foreign_new_for_display (class, GdkDisplay *display, GdkNativeWindow  anid);
    C_ARGS:
	display, anid

GdkWindow* gdk_window_lookup_for_display (class, GdkDisplay *display, GdkNativeWindow anid)
    C_ARGS:
	display, anid

#endif /* have GdkDisplay */

 ## void gdk_window_set_type_hint (GdkWindow *window, GdkWindowTypeHint hint)
void
gdk_window_set_type_hint (window, hint)
	GdkWindow *window
	GdkWindowTypeHint hint

 ## void gdk_window_set_modal_hint (GdkWindow *window, gboolean modal)
void
gdk_window_set_modal_hint (window, modal)
	GdkWindow *window
	gboolean modal

#if GTK_CHECK_VERSION(2,2,0)

 ## void gdk_window_set_skip_taskbar_hint (GdkWindow *window, gboolean skips_taskbar)
void
gdk_window_set_skip_taskbar_hint (window, skips_taskbar)
	GdkWindow *window
	gboolean skips_taskbar

 ## void gdk_window_set_skip_pager_hint (GdkWindow *window, gboolean skips_pager)
void
gdk_window_set_skip_pager_hint (window, skips_pager)
	GdkWindow *window
	gboolean skips_pager

#endif

=for apidoc

=for signature $window->set_geometry_hints ($geometry)
=for signature $window->set_geometry_hints ($geometry, $geom_mask)

=for arg geometry (Gtk2::Gdk::Geometry)
=for arg geom_mask (Gtk2::Gdk::WindowHints) optional, usually inferred from I<$geometry>

The geom_mask argument, describing which fields in the geometry are valid, is
optional.  If omitted it will be inferred from the geometry itself.

=cut
## void gdk_window_set_geometry_hints (GdkWindow *window, GdkGeometry *geometry, GdkWindowHints geom_mask)
void
gdk_window_set_geometry_hints (window, geometry_ref, geom_mask_sv=NULL)
	GdkWindow *window
	SV *geometry_ref
	SV *geom_mask_sv
    PREINIT:
	GdkGeometry *geometry;
	GdkWindowHints geom_mask;
    CODE:
	if (! (geom_mask_sv && SvOK (geom_mask_sv))) {
		geometry = SvGdkGeometryReal (geometry_ref, &geom_mask);
	} else {
		geometry = SvGdkGeometry (geometry_ref);
		geom_mask = SvGdkWindowHints (geom_mask_sv);
	}

	gdk_window_set_geometry_hints (window, geometry, geom_mask);

## void gdk_set_sm_client_id (const gchar *sm_client_id)
void
gdk_set_sm_client_id (sm_client_id)
	const gchar *sm_client_id

 ## void gdk_window_begin_paint_rect (GdkWindow *window, GdkRectangle *rectangle)
void
gdk_window_begin_paint_rect (window, rectangle)
	GdkWindow *window
	GdkRectangle *rectangle

 ## void gdk_window_begin_paint_region (GdkWindow *window, GdkRegion *region)
void
gdk_window_begin_paint_region (window, region)
	GdkWindow *window
	GdkRegion *region

 ## void gdk_window_end_paint (GdkWindow *window)
void
gdk_window_end_paint (window)
	GdkWindow *window

 ## void gdk_window_set_title (GdkWindow *window, const gchar *title)
void
gdk_window_set_title (window, title)
	GdkWindow *window
	const gchar *title

 ## void gdk_window_set_role (GdkWindow *window, const gchar *role)
void
gdk_window_set_role (window, role)
	GdkWindow *window
	const gchar *role

 ## void gdk_window_set_transient_for (GdkWindow *window, GdkWindow *parent)
void
gdk_window_set_transient_for (window, parent)
	GdkWindow *window
	GdkWindow *parent

 ## void gdk_window_set_background (GdkWindow *window, GdkColor *color)
void
gdk_window_set_background (window, color)
	GdkWindow *window
	GdkColor *color

 ## void gdk_window_set_back_pixmap (GdkWindow *window, GdkPixmap *pixmap, gboolean parent_relative)
void
gdk_window_set_back_pixmap (window, pixmap, parent_relative = 0)
	GdkWindow *window
	GdkPixmap_ornull *pixmap
	gboolean parent_relative

 ## void gdk_window_set_cursor (GdkWindow *window, GdkCursor *cursor)
void
gdk_window_set_cursor (window, cursor)
	GdkWindow * window
	GdkCursor_ornull * cursor

 ## void gdk_window_get_user_data (GdkWindow *window, gpointer *data)
gulong
gdk_window_get_user_data (window)
	GdkWindow * window
    CODE:
	gdk_window_get_user_data (window, (gpointer*)&RETVAL);
	if( !RETVAL )
		XSRETURN_UNDEF;
    OUTPUT:
	RETVAL

 ## void gdk_window_get_geometry (GdkWindow *window, gint *x, gint *y, gint *width, gint *height, gint *depth)
void gdk_window_get_geometry (GdkWindow *window, OUTLIST gint x, OUTLIST gint y, OUTLIST gint width, OUTLIST gint height, OUTLIST gint depth)

 ## void gdk_window_get_position (GdkWindow *window, gint *x, gint *y)
void gdk_window_get_position (GdkWindow *window, OUTLIST gint x, OUTLIST gint y)

  ## docs say return type is not meaningful, ignore
 ## gint gdk_window_get_origin (GdkWindow *window, gint *x, gint *y)
void gdk_window_get_origin (GdkWindow *window, OUTLIST gint x, OUTLIST gint y)

 ## void gdk_window_get_root_origin (GdkWindow *window, gint *x, gint *y)
void gdk_window_get_root_origin (GdkWindow *window, OUTLIST gint x, OUTLIST gint y)

 ## void gdk_window_get_frame_extents (GdkWindow *window, GdkRectangle *rect)
GdkRectangle *
gdk_window_get_frame_extents (window)
	GdkWindow *window
    CODE:
	RETVAL = g_new0 (GdkRectangle, 1);
	gdk_window_get_frame_extents (window, RETVAL);
    OUTPUT:
	RETVAL

=for apidoc
=for signature (window_at_pointer, x, y, mask) = $window->get_pointer
Returns window_at_pointer, a Gtk2::Gdk::Window or undef, x and y, integers, and
mask, a Gtk2::Gdk::ModifierType.
=cut
##GdkWindow_ornull* gdk_window_get_pointer (GdkWindow *window, OUTLIST gint x, OUTLIST gint y, OUTLIST GdkModifierType mask)
void
gdk_window_get_pointer (GdkWindow *window)
    PREINIT:
	GdkWindow       * win;
	gint              x;
	gint              y;
	GdkModifierType   mask;
    PPCODE:
	win = gdk_window_get_pointer (window, &x, &y, &mask);
	EXTEND (SP, 4);
	PUSHs (sv_2mortal (newSVGdkWindow_ornull (win)));
	PUSHs (sv_2mortal (newSViv (x)));
	PUSHs (sv_2mortal (newSViv (y)));
	PUSHs (sv_2mortal (newSVGdkModifierType (mask)));


 ## GdkWindow * gdk_window_get_parent (GdkWindow *window)
GdkWindow *
gdk_window_get_parent (window)
	GdkWindow *window

 ## GdkWindow * gdk_window_get_toplevel (GdkWindow *window)
GdkWindow *
gdk_window_get_toplevel (window)
	GdkWindow *window

## GList * gdk_window_get_children (GdkWindow *window)
## GList * gdk_window_peek_children (GdkWindow *window)
## we use ALIAS here b/c we're cheating and using peek_children all of the time 
## since we're going to make a copy of the list anyway there's no need for gdk to
=for apidoc Gtk2::Gdk::Window::peek_children
An alias for get_children
=cut
=for apidoc
Returns the list of children (Gtk2::Gdk::Window's) known to gdk.
=cut
void
gdk_window_get_children (window)
	GdkWindow *window
    ALIAS:
	Gtk2::Gdk::Window::peek_children = 1
    PREINIT:
	GList *windows = NULL, *i;
    PPCODE:
	PERL_UNUSED_VAR (ix);
	windows = gdk_window_peek_children (window);
	for (i = windows; i != NULL; i = i->next)
		XPUSHs (sv_2mortal (newSVGdkWindow (i->data)));

 ## GdkEventMask gdk_window_get_events (GdkWindow *window)
GdkEventMask
gdk_window_get_events (window)
	GdkWindow *window

 ## void gdk_window_set_events (GdkWindow *window, GdkEventMask event_mask)
void
gdk_window_set_events (window, event_mask)
	GdkWindow *window
	GdkEventMask event_mask

=for apidoc

=for arg ... of GdkPixbuf's

=cut
 ## void gdk_window_set_icon_list (GdkWindow *window, GList *pixbufs)
void
gdk_window_set_icon_list (window, ...)
	GdkWindow *window
    PREINIT:
	int i;
	GList *pixbufs = NULL;
    CODE:
	for (i = 1; i < items; i++)
		pixbufs = g_list_append (pixbufs, SvGdkPixbuf (ST (i)));
	gdk_window_set_icon_list (window, pixbufs);
	g_list_free (pixbufs);

 ## void gdk_window_set_icon (GdkWindow *window, GdkWindow *icon_window, GdkPixmap *pixmap, GdkBitmap *mask)
void
gdk_window_set_icon (window, icon_window, pixmap, mask)
	GdkWindow *window
	GdkWindow_ornull *icon_window
	GdkPixmap_ornull *pixmap
	GdkBitmap_ornull *mask

 ## void gdk_window_set_icon_name (GdkWindow *window, const gchar *name)
void
gdk_window_set_icon_name (window, name)
	GdkWindow *window
	const gchar *name

 ## void gdk_window_set_group (GdkWindow *window, GdkWindow *leader)
void
gdk_window_set_group (window, leader)
	GdkWindow *window
	GdkWindow *leader

 ## void gdk_window_set_decorations (GdkWindow *window, GdkWMDecoration decorations)
void
gdk_window_set_decorations (window, decorations)
	GdkWindow *window
	GdkWMDecoration decorations

gboolean gdk_window_get_decorations (GdkWindow *window, OUTLIST GdkWMDecoration decorations)

 ## void gdk_window_set_functions (GdkWindow *window, GdkWMFunction functions)
void
gdk_window_set_functions (window, functions)
	GdkWindow *window
	GdkWMFunction functions

 ## GList * gdk_window_get_toplevels (void)
=for apidoc
Returns a list of top level windows (Gtk2::Gdk::Window's) known to gdk, on the 
default screen. A toplevel window is a child of the root window.
=cut
void
gdk_window_get_toplevels (class)
    PREINIT:
	GList *windows = NULL, *i;
    PPCODE:
	windows = gdk_window_get_toplevels ();

	for (i = windows; i != NULL; i = i->next)
		XPUSHs (sv_2mortal (newSVGdkWindow (i->data)));

	g_list_free (windows);
	PERL_UNUSED_VAR (ax);

 ## void gdk_window_iconify (GdkWindow *window)
void
gdk_window_iconify (window)
	GdkWindow *window

 ## void gdk_window_deiconify (GdkWindow *window)
void
gdk_window_deiconify (window)
	GdkWindow *window

 ## void gdk_window_stick (GdkWindow *window)
void
gdk_window_stick (window)
	GdkWindow *window

 ## void gdk_window_unstick (GdkWindow *window)
void
gdk_window_unstick (window)
	GdkWindow *window

 ## void gdk_window_maximize (GdkWindow *window)
void
gdk_window_maximize (window)
	GdkWindow *window

 ## void gdk_window_unmaximize (GdkWindow *window)
void
gdk_window_unmaximize (window)
	GdkWindow *window

#if GTK_CHECK_VERSION(2,2,0)

 ## void gdk_window_fullscreen (GdkWindow *window)
void
gdk_window_fullscreen (window)
	GdkWindow *window

 ## void gdk_window_unfullscreen (GdkWindow *window)
void
gdk_window_unfullscreen (window)
	GdkWindow *window

#endif

 ## void gdk_window_register_dnd (GdkWindow *window)
void
gdk_window_register_dnd (window)
	GdkWindow *window

 ## void gdk_window_begin_resize_drag (GdkWindow *window, GdkWindowEdge edge, gint button, gint root_x, gint root_y, guint32 timestamp)
void
gdk_window_begin_resize_drag (window, edge, button, root_x, root_y, timestamp)
	GdkWindow *window
	GdkWindowEdge edge
	gint button
	gint root_x
	gint root_y
	guint32 timestamp

 ## void gdk_window_begin_move_drag (GdkWindow *window, gint button, gint root_x, gint root_y, guint32 timestamp)
void
gdk_window_begin_move_drag (window, button, root_x, root_y, timestamp)
	GdkWindow *window
	gint button
	gint root_x
	gint root_y
	guint32 timestamp

void
gdk_window_invalidate_rect (window, rectangle, invalidate_children)
	GdkWindow * window
	GdkRectangle * rectangle
	gboolean invalidate_children

 ## void gdk_window_invalidate_region (GdkWindow *window, GdkRegion *region, gboolean invalidate_children)
void
gdk_window_invalidate_region (window, region, invalidate_children)
	GdkWindow *window
	GdkRegion *region
	gboolean invalidate_children

 ## void gdk_window_invalidate_maybe_recurse (GdkWindow *window, GdkRegion *region, gboolean (*child_func) (GdkWindow *, gpointer), gpointer user_data)
void
gdk_window_invalidate_maybe_recurse (window, region, func, data=NULL)
	GdkWindow *window
	GdkRegion *region
	SV *func
	SV *data
    PREINIT:
	GPerlCallback *callback;
    CODE:
	callback = gtk2perl_gdk_window_invalidate_maybe_recurse_func_create (func, data);
	gdk_window_invalidate_maybe_recurse (window,
	                                     region,
	                                     gtk2perl_gdk_window_invalidate_maybe_recurse_func,
	                                     callback);
	gperl_callback_destroy (callback);

 ## GdkRegion* gdk_window_get_update_area (GdkWindow *window)
GdkRegion_own_ornull *
gdk_window_get_update_area (window)
	GdkWindow *window

## void gdk_window_freeze_updates (GdkWindow *window)
void
gdk_window_freeze_updates (window)
	GdkWindow * window
 
## void gdk_window_thaw_updates (GdkWindow *window)
void
gdk_window_thaw_updates (window)
	GdkWindow * window

=for apidoc
=for signature Gtk2::Gdk::Window->process_all_updates
=for signature $window->process_all_updates
=cut
void gdk_window_process_all_updates (class_or_instance)
    C_ARGS: /*void*/

=for apidoc
=for signature Gtk2::Gdk::Window->set_debug_updates ($enable)
=for signature $window->set_debug_updates ($enable)
=cut
void gdk_window_set_debug_updates (class_or_instance, gboolean enable)
    C_ARGS: enable

 ## void gdk_window_process_updates (GdkWindow *window, gboolean update_children)
void
gdk_window_process_updates (GdkWindow * window, gboolean update_children)

 ## void gdk_window_get_internal_paint_info (GdkWindow *window, GdkDrawable **real_drawable, gint *x_offset, gint *y_offset)
void gdk_window_get_internal_paint_info (GdkWindow *window, OUTLIST GdkDrawable *real_drawable, OUTLIST gint x_offset, OUTLIST gint y_offset)


MODULE = Gtk2::Gdk::Window	PACKAGE = Gtk2::Gdk	PREFIX = gdk_

GdkWindow *gdk_get_default_root_window (class)
    C_ARGS:
	/*void*/

