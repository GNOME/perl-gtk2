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

MODULE = Gtk2::Gdk::Display	PACKAGE = Gtk2::Gdk::Display	PREFIX = gdk_display_

#if GTK_CHECK_VERSION(2,2,0)

BOOT:
	/* the various gdk backends will provide private subclasses of
	 * GdkDisplay; we shouldn't complain about them. */
	gperl_object_set_no_warn_unreg_subclass (GDK_TYPE_DISPLAY, TRUE);

##  gint (*get_n_screens) (GdkDisplay *display) 
##  void (*closed) (GdkDisplay *display, gboolean is_error) 

##  GdkDisplay *gdk_display_open (const gchar *display_name) 
GdkDisplay_ornull *
gdk_display_open (class, const gchar * display_name)
    C_ARGS:
	display_name

const gchar * gdk_display_get_name (GdkDisplay * display)

gint gdk_display_get_n_screens (GdkDisplay *display) 

GdkScreen * gdk_display_get_screen (GdkDisplay *display, gint screen_num) 

GdkScreen * gdk_display_get_default_screen (GdkDisplay *display) 

void gdk_display_pointer_ungrab (GdkDisplay *display, guint32 time_) 

void gdk_display_keyboard_ungrab (GdkDisplay *display, guint32 time_) 

gboolean gdk_display_pointer_is_grabbed (GdkDisplay *display) 

void gdk_display_beep (GdkDisplay *display) 

void gdk_display_sync (GdkDisplay *display) 

void gdk_display_close (GdkDisplay *display) 

##  GList * gdk_display_list_devices (GdkDisplay *display) 
=forapi
Returns a list of Gtk2::Gdk::Devices
=cut
void
gdk_display_list_devices (display)
	GdkDisplay *display
    PREINIT:
	GList * devices, * i;
    PPCODE:
	devices = gdk_display_list_devices (display);
	for (i = devices ; i != NULL ; i = i->next)
		XPUSHs (sv_2mortal (newSVGdkDevice (i->data)));
	g_list_free (devices);
	

GdkEvent* gdk_display_get_event (GdkDisplay *display) 

GdkEvent* gdk_display_peek_event (GdkDisplay *display) 

void gdk_display_put_event (GdkDisplay *display, GdkEvent *event) 

 # FIXME
###  void gdk_display_add_client_message_filter (GdkDisplay *display, GdkAtom message_type, GdkFilterFunc func, gpointer data) 
#void
#gdk_display_add_client_message_filter (display, message_type, func, data)
#	GdkDisplay *display
#	GdkAtom message_type
#	GdkFilterFunc func
#	gpointer data

void gdk_display_set_double_click_time (GdkDisplay *display, guint msec) 

##  GdkDisplay *gdk_display_get_default (void) 
GdkDisplay_ornull *
gdk_display_get_default (class)
    C_ARGS:
	/*void*/

##  GdkDevice *gdk_display_get_core_pointer (GdkDisplay *display) 
GdkDevice *
gdk_display_get_core_pointer (display)
	GdkDisplay *display

##  void gdk_display_get_pointer (GdkDisplay *display, GdkScreen **screen, gint *x, gint *y, GdkModifierType *mask) 
void gdk_display_get_pointer (GdkDisplay *display, OUTLIST GdkScreen *screen, OUTLIST gint x, OUTLIST gint y, OUTLIST GdkModifierType mask) 

##  GdkWindow * gdk_display_get_window_at_pointer (GdkDisplay *display, gint *win_x, gint *win_y) 
###GdkWindow * gdk_display_get_window_at_pointer (GdkDisplay *display, OUTLIST gint win_x, OUTLIST gint win_y) 
=for apidoc
=signature (window, win_x, win_y) = $display->get_window_at_pointer ($display)
=cut
void
gdk_display_get_window_at_pointer (GdkDisplay *display) 
    PREINIT:
	GdkWindow * window;
	gint win_x = 0, win_y = 0;
    PPCODE:
	window = gdk_display_get_window_at_pointer (display, &win_x, &win_y);
	if (!window)
		XSRETURN_EMPTY;
	EXTEND (SP, 3);
	PUSHs (sv_2mortal (newSVGdkWindow (window)));
	PUSHs (sv_2mortal (newSViv (win_x)));
	PUSHs (sv_2mortal (newSViv (win_y)));


 # API reference says this shouldn't be used by apps, and is only useful for
 # event recorders.  would a perl event recorder be usable?
##  GdkDisplayPointerHooks *gdk_display_set_pointer_hooks (GdkDisplay *display, const GdkDisplayPointerHooks *new_hooks) 
 # not documented
##  GdkDisplay *gdk_display_open_default_libgtk_only (void) 

#endif /* >= 2.2.0 */
