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

MODULE = Gtk2::Gdk::Dnd	PACKAGE = Gtk2::Gdk::DragContext	PREFIX = gdk_drag_context_

SV *
members (dc)
	GdkDragContext * dc
    ALIAS:
	Gtk2::Gdk::DragContext::protocol = 0
	Gtk2::Gdk::DragContext::is_source = 1
	Gtk2::Gdk::DragContext::source_window = 2
	Gtk2::Gdk::DragContext::dest_window = 3
	Gtk2::Gdk::DragContext::actions = 5
	Gtk2::Gdk::DragContext::suggested_action = 6
	Gtk2::Gdk::DragContext::action = 7
	Gtk2::Gdk::DragContext::start_time = 8
    CODE:
	RETVAL = NULL;
	switch (ix) {
	    case 0: RETVAL = newSVGdkDragProtocol (dc->protocol); break;
	    case 1: RETVAL = newSViv (dc->is_source); break;
	    case 2: RETVAL = newSVGdkWindow (dc->source_window); break;
	    case 3: RETVAL = newSVGdkWindow (dc->dest_window); break;
	    /* must use get_targets to access targets */
	    case 5: RETVAL = newSVGdkDragAction (dc->actions); break;
	    case 6: RETVAL = newSVGdkDragAction (dc->suggested_action); break;
	    case 7: RETVAL = newSVGdkDragAction (dc->action); break;
	    case 8: RETVAL = newSVuv (dc->start_time); break;
	}
    OUTPUT:
	RETVAL

=for apidoc
Returns a list of Gtk2::Gdk::Atom's, the targets.
=cut
void
targets (dc)
	GdkDragContext * dc
    PREINIT:
	GList * i;
    PPCODE:
	for (i = dc->targets; i != NULL ; i = i->next)
		XPUSHs (sv_2mortal (newSVGdkAtom ((GdkAtom)i->data)));

##  GdkDragContext * gdk_drag_context_new (void) 
GdkDragContext_noinc *
gdk_drag_context_new (class)
    C_ARGS:
	/* void */
	
 # deprecated
##  void gdk_drag_context_ref (GdkDragContext *context) 
##  void gdk_drag_context_unref (GdkDragContext *context) 

MODULE = Gtk2::Gdk::Dnd	PACKAGE = Gtk2::Gdk::DragContext	PREFIX = gdk_drag_

##  void gdk_drag_status (GdkDragContext *context, GdkDragAction action, guint32 time_) 
void
gdk_drag_status (context, action, time_=GDK_CURRENT_TIME)
	GdkDragContext *context
	GdkDragAction action
	guint32 time_

##  void gdk_drop_reply (GdkDragContext *context, gboolean ok, guint32 time_) 
void
gdk_drop_reply (context, ok, time_=GDK_CURRENT_TIME)
	GdkDragContext *context
	gboolean ok
	guint32 time_

##  void gdk_drop_finish (GdkDragContext *context, gboolean success, guint32 time_) 
void
gdk_drop_finish (context, success, time_=GDK_CURRENT_TIME)
	GdkDragContext *context
	gboolean success
	guint32 time_

##  GdkAtom gdk_drag_get_selection (GdkDragContext *context) 
GdkAtom
gdk_drag_get_selection (context)
	GdkDragContext *context

##  GdkDragContext * gdk_drag_begin (GdkWindow *window, GList *targets) 
=for apidoc
=for arg target1 (Gtk2::Gdk::Atom) the first atom
=for arg ... (__hide__)
=cut
GdkDragContext_noinc *
gdk_drag_begin (class, window, target1, ...)
	GdkWindow *window
    PREINIT:
	GList *targets = NULL;
	int i;
    CODE:
	for (i = items - 1 ; i >= 2 ; i--)
		targets = g_list_prepend (targets,
		                        GUINT_TO_POINTER (SvGdkAtom (ST (i))));
	RETVAL = gdk_drag_begin (window, targets);
    OUTPUT:
	RETVAL
    CLEANUP:
	g_list_free (targets);

#if GTK_CHECK_VERSION(2,2,0)

##  guint32 gdk_drag_get_protocol_for_display (GdkDisplay *display, guint32 xid, GdkDragProtocol *protocol) 
=for apidoc
=signature (ret, protocol) = Gtk2::Gdk::DragContext->get_protocol_for_display ($display, $xid)
=cut
void
gdk_drag_get_protocol_for_display (class, display, xid)
	GdkDisplay *display
	guint32 xid
    PREINIT:
	GdkDragProtocol protocol;
	guint32 ret;
    PPCODE:
	ret = gdk_drag_get_protocol_for_display (display, xid, &protocol);
	XPUSHs (sv_2mortal (newSVuv (ret)));
	XPUSHs (sv_2mortal (newSVGdkDragProtocol (protocol)));

##  void gdk_drag_find_window_for_screen (GdkDragContext *context, GdkWindow *drag_window, GdkScreen *screen, gint x_root, gint y_root, GdkWindow **dest_window, GdkDragProtocol *protocol) 
=for apidoc
=signature (dest_window, protocol) = $context->find_window_for_screen ($drag_window, $screen, $x_root, $y_root)
=cut
void
gdk_drag_find_window_for_screen (context, drag_window, screen, x_root, y_root)
	GdkDragContext *context
	GdkWindow *drag_window
	GdkScreen *screen
	gint x_root
	gint y_root
    PREINIT:
	GdkWindow *dest_window;
	GdkDragProtocol protocol;
    PPCODE:
	gdk_drag_find_window_for_screen (context, drag_window, screen, 
	                                 x_root, y_root, 
	                                 &dest_window, &protocol);
	XPUSHs (sv_2mortal (newSVGdkWindow (dest_window)));
	XPUSHs (sv_2mortal (newSVGdkDragProtocol (protocol)));

#endif /* >= 2.2.0 */

##  guint32 gdk_drag_get_protocol (guint32 xid, GdkDragProtocol *protocol) 
=for apidoc
=signature (ret, protocol) = Gtk2::Gdk::DragContext->get_protocol ($xid)
=cut
void
gdk_drag_get_protocol (class, xid)
	guint32 xid
    PREINIT:
	GdkDragProtocol protocol;
	guint32 ret;
    PPCODE:
	ret = gdk_drag_get_protocol (xid, &protocol);
	XPUSHs (sv_2mortal (newSVuv (ret)));
	XPUSHs (sv_2mortal (newSVGdkDragProtocol (protocol)));
	

##  void gdk_drag_find_window (GdkDragContext *context, GdkWindow *drag_window, gint x_root, gint y_root, GdkWindow **dest_window, GdkDragProtocol *protocol) 
=for apidoc
=signature (dest_window, protocol) = $context->find_window ($drag_window, $x_root, $y_root)
=cut
void
gdk_drag_find_window (context, drag_window, x_root, y_root)
	GdkDragContext *context
	GdkWindow *drag_window
	gint x_root
	gint y_root
    PREINIT:
	GdkWindow *dest_window;
	GdkDragProtocol protocol;
    PPCODE:
	gdk_drag_find_window (context, drag_window, x_root, y_root, 
	                      &dest_window, &protocol);
	XPUSHs (sv_2mortal (newSVGdkWindow (dest_window)));
	XPUSHs (sv_2mortal (newSVGdkDragProtocol (protocol)));


##  gboolean gdk_drag_motion (GdkDragContext *context, GdkWindow *dest_window, GdkDragProtocol protocol, gint x_root, gint y_root, GdkDragAction suggested_action, GdkDragAction possible_actions, guint32 time_) 
gboolean
gdk_drag_motion (context, dest_window, protocol, x_root, y_root, suggested_action, possible_actions, time_)
	GdkDragContext *context
	GdkWindow *dest_window
	GdkDragProtocol protocol
	gint x_root
	gint y_root
	GdkDragAction suggested_action
	GdkDragAction possible_actions
	guint32 time_

##  void gdk_drag_drop (GdkDragContext *context, guint32 time_) 
void
gdk_drag_drop (context, time_)
	GdkDragContext *context
	guint32 time_

##  void gdk_drag_abort (GdkDragContext *context, guint32 time_) 
void
gdk_drag_abort (context, time_)
	GdkDragContext *context
	guint32 time_

