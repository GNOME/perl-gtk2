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

/*

since the GdkEvent is a union, it behaves like a polymorphic structure.
gdk provides a couple of functions to return some common values regardless
of the type of event, but we need to provide access to pretty much all
of the members.

thus, i've created a bit of hierarchy within the GdkEvent itself.  specialized
event types inherit evreything else from Gtk2::Gdk::Event, but add their
own methods to provide access to the struct members.

by the way, we do everything as opaque types and methods instead of creating
a hash like gtk-perl in order to avoid the performance hit of always creating
a hash that maybe 20% of client code will ever actually use.

*/



static const char *
gdk_event_get_package (GType gtype,
                       GdkEvent * event)
{
	PERL_UNUSED_VAR (gtype);

	switch (event->type) {
	    default:
		warn ("unknown event type %d", event->type);
	    case GDK_NOTHING:
	    case GDK_DELETE:
	    case GDK_DESTROY:
	    case GDK_MAP:
	    case GDK_UNMAP:
		return "Gtk2::Gdk::Event";
	    case GDK_EXPOSE:
		return "Gtk2::Gdk::Event::Expose";
	    case GDK_MOTION_NOTIFY:
		return "Gtk2::Gdk::Event::Motion";
	    case GDK_BUTTON_PRESS:
	    case GDK_2BUTTON_PRESS:
	    case GDK_3BUTTON_PRESS:
	    case GDK_BUTTON_RELEASE:
		return "Gtk2::Gdk::Event::Button";
	    case GDK_KEY_PRESS:
	    case GDK_KEY_RELEASE:
		return "Gtk2::Gdk::Event::Key";
	    case GDK_ENTER_NOTIFY:
	    case GDK_LEAVE_NOTIFY:
		return "Gtk2::Gdk::Event::Crossing";
	    case GDK_FOCUS_CHANGE:
		return "Gtk2::Gdk::Event::Focus";
	    case GDK_CONFIGURE:
		return "Gtk2::Gdk::Event::Configure";
	    case GDK_PROPERTY_NOTIFY:
		return "Gtk2::Gdk::Event::Property";
	    case GDK_SELECTION_CLEAR:
	    case GDK_SELECTION_REQUEST:
	    case GDK_SELECTION_NOTIFY:
		return "Gtk2::Gdk::Event::Selection";
	    case GDK_PROXIMITY_IN:
	    case GDK_PROXIMITY_OUT:
		return "Gtk2::Gdk::Event::Proximity";
	    case GDK_DRAG_ENTER:
	    case GDK_DRAG_LEAVE:
	    case GDK_DRAG_MOTION:
	    case GDK_DRAG_STATUS:
	    case GDK_DROP_START:
	    case GDK_DROP_FINISHED:
		return "Gtk2::Gdk::Event::DND";
	    case GDK_CLIENT_EVENT:
		return "Gtk2::Gdk::Event::Client";
	    case GDK_VISIBILITY_NOTIFY:
		return "Gtk2::Gdk::Event::Visibility";
	    case GDK_NO_EXPOSE:
		return "Gtk2::Gdk::Event::NoExpose";
	    case GDK_SCROLL:
		return "Gtk2::Gdk::Event::Scroll";
	    case GDK_WINDOW_STATE:
		return "Gtk2::Gdk::Event::WindowState";
	    case GDK_SETTING:
		return "Gtk2::Gdk::Event::Setting";
	}
}

/* initialized in the boot section. */
static GPerlBoxedWrapperClass   gdk_event_wrapper_class;
static GPerlBoxedWrapperClass * default_wrapper_class;

static SV *
gdk_event_wrap (GType gtype,
                const char * package,
                GdkEvent * event,
		gboolean own)
{
	HV * stash;
	SV * sv;

	sv = default_wrapper_class->wrap (gtype, package, event, own);

	/* we don't really care about the registered package, override it. */
	package = gdk_event_get_package (gtype, event);
	stash = gv_stashpv (package, TRUE);
	return sv_bless (sv, stash);
}

static GdkEvent *
gdk_event_unwrap (GType gtype, const char * package, SV * sv)
{
	GdkEvent * event = default_wrapper_class->unwrap (gtype, package, sv);

	/* we don't really care about the registered package, override it. */
	package = gdk_event_get_package (gtype, event);

	if (!sv_derived_from (sv, package))
		croak ("variable is not of type %s", package);

	return event;
}



MODULE = Gtk2::Gdk::Event	PACKAGE = Gtk2::Gdk::Event	PREFIX = gdk_event_

BOOT:
	/* GdkEvent is a polymorphic structure, whose actual package
	 * depends on the type member's value.  instead of trying to make
	 * a perl developer know about this, we'll bless it into the proper
	 * subclass by overriding the default wrapper behavior.
	 *
	 * note that we expressly wish to keep the GdkEvent as an opaque
	 * type in gtk2-perl for efficiency; converting an event to a
	 * hash is an expensive operation that is usually wasted (based on
	 * experience with gtk-perl).
	 */ 
	default_wrapper_class = gperl_default_boxed_wrapper_class ();
	gdk_event_wrapper_class = * default_wrapper_class;
	gdk_event_wrapper_class.wrap = (GPerlBoxedWrapFunc)gdk_event_wrap;
	gdk_event_wrapper_class.unwrap = (GPerlBoxedUnwrapFunc)gdk_event_unwrap;
	gperl_register_boxed (GDK_TYPE_EVENT, "Gtk2::Gdk::Event",
	                      &gdk_event_wrapper_class);
	gperl_set_isa ("Gtk2::Gdk::Event", "Glib::Boxed");

 ## gboolean gdk_events_pending (void)
gboolean
gdk_events_pending (class)
    C_ARGS:
	/*void*/

 ## GdkEvent* gdk_event_get (void)
 ## GdkEvent* gdk_event_peek (void)
## caller must free
GdkEvent_own_ornull*
gdk_event_get (class)
    ALIAS:
	get = 0
	peek = 1
    C_ARGS:
	/*void*/
    CLEANUP:
	PERL_UNUSED_VAR (ix);

 ## GdkEvent* gdk_event_get_graphics_expose (GdkWindow *window)
GdkEvent_own_ornull*
gdk_event_get_graphics_expose (window)
	GdkWindow *window

 ## void gdk_event_put (GdkEvent *event)
## call as Gtk2::Gdk::Event->put ($event)
void
gdk_event_put (class, event)
	GdkEvent *event
    C_ARGS:
	event

#if GTK_CHECK_VERSION(2,2,0)

 ## GdkEvent* gdk_event_new (GdkEventType type)
## caller must free
GdkEvent_own*
gdk_event_new (class, type)
	GdkEventType type
    C_ARGS:
	type

#endif

 ## GdkEvent* gdk_event_copy (GdkEvent *event)
GdkEvent_own*
gdk_event_copy (event)
	GdkEvent *event

 # automatic
 ## void gdk_event_free (GdkEvent *event)

 ## guint32 gdk_event_get_time (GdkEvent *event)
guint
gdk_event_get_time (event)
	GdkEvent *event
    ALIAS:
	Gtk2::Gdk::Event::get_time = 0
	Gtk2::Gdk::Event::time = 1
    CLEANUP:
	PERL_UNUSED_VAR (ix);

 ## gboolean gdk_event_get_state (GdkEvent *event, GdkModifierType *state)
GdkModifierType
state (event)
	GdkEvent *event
    ALIAS:
	Gtk2::Gdk::Event::get_state = 0
	Gtk2::Gdk::Event::state = 1
    CODE:
	PERL_UNUSED_VAR (ix);
	if (!gdk_event_get_state (event, &RETVAL))
		XSRETURN_UNDEF;
    OUTPUT:
	RETVAL

=for apidoc Gtk2::Gdk::Event::get_coords
=signature ($x, $y) = $event->get_coords
=cut

=for apidoc Gtk2::Gdk::Event::coords
=signature ($x, $y) = $event->coords
=cut

=for apidoc Gtk2::Gdk::Event::x
=signature integer = $event->x
=cut

=for apidoc Gtk2::Gdk::Event::y
=signature integer = $event->y
=cut

 ## gboolean gdk_event_get_coords (GdkEvent *event, gdouble *x_win, gdouble *y_win)
void
gdk_event_get_coords (event)
	GdkEvent *event
    ALIAS:
	Gtk2::Gdk::Event::get_coords = 0
	Gtk2::Gdk::Event::coords = 1
	Gtk2::Gdk::Event::x = 2
	Gtk2::Gdk::Event::y = 3
    PREINIT:
	gdouble x;
	gdouble y;
    PPCODE:
	if (!gdk_event_get_coords (event, &x, &y))
		XSRETURN_EMPTY;
	switch (ix) {
		case 2: /* x */
			PUSHs (sv_2mortal (newSVnv (x)));
			break;
		case 3: /* y */
			PUSHs (sv_2mortal (newSVnv (y)));
			break;
		default:
			EXTEND (SP, 2);
			PUSHs (sv_2mortal (newSVnv (x)));
			PUSHs (sv_2mortal (newSVnv (y)));
	}

=for apidoc Gtk2::Gdk::Event::get_root_coords
=signature ($x_root, $y_root) = $event->get_root_coords
=cut

=for apidoc Gtk2::Gdk::Event::root_coords
=signature ($x_root, $y_root) = $event->root_coords
=cut

=for apidoc Gtk2::Gdk::Event::x_root
=signature integer = $event->x_root
=cut

=for apidoc Gtk2::Gdk::Event::y_root
=signature integer = $event->y_root
=cut

 ## gboolean gdk_event_get_root_coords (GdkEvent *event, gdouble *x_root, gdouble *y_root)
void
gdk_event_get_root_coords (event)
	GdkEvent *event
    ALIAS:
	Gtk2::Gdk::Event::get_root_coords = 0
	Gtk2::Gdk::Event::root_coords = 1
	Gtk2::Gdk::Event::x_root = 2
	Gtk2::Gdk::Event::y_root = 3
    PREINIT:
	gdouble x_root;
	gdouble y_root;
    PPCODE:
	if (!gdk_event_get_root_coords (event, &x_root, &y_root))
		XSRETURN_EMPTY;
	switch (ix) {
		case 2: /* x */
			PUSHs (sv_2mortal (newSVnv (x_root)));
			break;
		case 3: /* y */
			PUSHs (sv_2mortal (newSVnv (y_root)));
			break;
		default:
			EXTEND (SP, 2);
			PUSHs (sv_2mortal (newSVnv (x_root)));
			PUSHs (sv_2mortal (newSVnv (y_root)));
	}


 ## gboolean gdk_event_get_axis (GdkEvent *event, GdkAxisUse axis_use, gdouble *value)
gdouble
axis (event, axis_use)
	GdkEvent *event
	GdkAxisUse axis_use
    CODE:
	if (!gdk_event_get_axis (event, axis_use, &RETVAL))
		XSRETURN_UNDEF;
    OUTPUT:
	RETVAL

 # FIXME needs a callback... do we really want this from perl?
 ## void gdk_event_handler_set (GdkEventFunc func, gpointer data, GDestroyNotify notify)
 ##void
 ##gdk_event_handler_set (func, data, notify)
 ##	GdkEventFunc func
 ##	gpointer data
 ##	GDestroyNotify notify

#ifdef GDK_TYPE_SCREEN

void
gdk_event_set_screen (event, screen)
	GdkEvent * event
	GdkScreen * screen

GdkScreen *
gdk_event_get_screen (event)
	GdkEvent * event

#endif /* have GdkScreen */

 ## since we're overriding the package names, Glib::Boxed::DESTROY won't
 ## be able to find the right destructor, because these new names don't
 ## correspond to GTypes.  we'll have to explicitly tell perl what 
 ## destructor to use.
void
DESTROY (sv)
	SV * sv
    ALIAS:
	Gtk2::Gdk::Event::DESTROY              =  0
	Gtk2::Gdk::Event::Expose::DESTROY      =  1
	Gtk2::Gdk::Event::NoExpose::DESTROY    =  2
	Gtk2::Gdk::Event::Visibility::DESTROY  =  3
	Gtk2::Gdk::Event::Motion::DESTROY      =  4
	Gtk2::Gdk::Event::Button::DESTROY      =  5
	Gtk2::Gdk::Event::Scroll::DESTROY      =  6
	Gtk2::Gdk::Event::Key::DESTROY         =  7
	Gtk2::Gdk::Event::Crossing::DESTROY    =  8
	Gtk2::Gdk::Event::Focus::DESTROY       =  9
	Gtk2::Gdk::Event::Configure::DESTROY   = 10
	Gtk2::Gdk::Event::Property::DESTROY    = 11
	Gtk2::Gdk::Event::Selection::DESTROY   = 12
	Gtk2::Gdk::Event::Proximity::DESTROY   = 13
	Gtk2::Gdk::Event::Client::DESTROY      = 14
	Gtk2::Gdk::Event::Setting::DESTROY     = 15
	Gtk2::Gdk::Event::WindowState::DESTROY = 16
	Gtk2::Gdk::Event::DND::DESTROY         = 17
    CODE:
	PERL_UNUSED_VAR (ix);
	default_wrapper_class->destroy (sv);


## Event types.
##   Nothing: No event occurred.
##   Delete: A window delete event was sent by the window manager.
##	     The specified window should be deleted.
##   Destroy: A window has been destroyed.
##   Expose: Part of a window has been uncovered.
##   NoExpose: Same as expose, but no expose event was generated.
##   VisibilityNotify: A window has become fully/partially/not obscured.
##   MotionNotify: The mouse has moved.
##   ButtonPress: A mouse button was pressed.
##   ButtonRelease: A mouse button was release.
##   KeyPress: A key was pressed.
##   KeyRelease: A key was released.
##   EnterNotify: A window was entered.
##   LeaveNotify: A window was exited.
##   FocusChange: The focus window has changed. (The focus window gets
##		  keyboard events).
##   Resize: A window has been resized.
##   Map: A window has been mapped. (It is now visible on the screen).
##   Unmap: A window has been unmapped. (It is no longer visible on
##	    the screen).
##   Scroll: A mouse wheel was scrolled either up or down.


 # struct _GdkEventAny
 # {
 #   GdkEventType type;
 #   GdkWindow *window;
 #   gint8 send_event;
 # };

GdkEventType
type (event)
	GdkEvent * event
    CODE:
	RETVAL = event->any.type;
    OUTPUT:
	RETVAL

GdkWindow_ornull *
window (event)
	GdkEvent * event
    CODE:
	RETVAL = event->any.window;
    OUTPUT:
	RETVAL

gint8
send_event (event)
	GdkEvent * event
    CODE:
	RETVAL = event->any.send_event;
    OUTPUT:
	RETVAL

MODULE = Gtk2::Gdk::Event	PACKAGE = Gtk2::Gdk::Event::Expose

BOOT:
	gperl_set_isa ("Gtk2::Gdk::Event::Expose", "Gtk2::Gdk::Event");

=for object Gtk2::Gdk::Event
=cut

 #struct _GdkEventExpose
 #{
 #//  GdkEventType type;  <- GdkEventAny
 #//  GdkWindow *window;  <- GdkEventAny
 #//  gint8 send_event;  <- GdkEventAny
 #  GdkRectangle area;
 #  GdkRegion *region;
 #  gint count; /* If non-zero, how many more events follow. */
 #};

=for apidoc
=signature $rectangle = $eventexpose->area
=cut
GdkRectangle*
area (event)
	GdkEvent * event
    CODE:
	RETVAL = &(event->expose.area);
    OUTPUT:
	RETVAL

 # FIXME need GdkRegion
#GdkRegion_copy*
#region (event)
#	GdkEvent * event
#    CODE:
#	RETVAL = event->expose.region;
#    OUTPUT:
#	RETVAL

=for apidoc
=signature integer = $eventexpose->count
=cut
gint
count (event)
	GdkEvent * event
    CODE:
	RETVAL = event->expose.count;
    OUTPUT:
	RETVAL

MODULE = Gtk2::Gdk::Event	PACKAGE = Gtk2::Gdk::Event::NoExpose

BOOT:
	gperl_set_isa ("Gtk2::Gdk::Event::NoExpose", "Gtk2::Gdk::Event");

=for object Gtk2::Gdk::Event
=cut

 #struct _GdkEventNoExpose
 #{
 #//  GdkEventType type;  <- GdkEventAny
 #//  GdkWindow *window;  <- GdkEventAny
 #//  gint8 send_event;  <- GdkEventAny
 #};

MODULE = Gtk2::Gdk::Event	PACKAGE = Gtk2::Gdk::Event::Visibility

BOOT:
	gperl_set_isa ("Gtk2::Gdk::Event::Visibility", "Gtk2::Gdk::Event");

=for object Gtk2::Gdk::Event
=cut

 #struct _GdkEventVisibility
 #{
 #//  GdkEventType type;  <- GdkEventAny
 #//  GdkWindow *window;  <- GdkEventAny
 #//  gint8 send_event;  <- GdkEventAny
 #  GdkVisibilityState state;
 #};

=for apidoc
=signature $visibilitystate = $eventvisibility->state
=cut
# different return type, override Gtk2::Gdk::Event::state
GdkVisibilityState
state (event)
	GdkEvent * event
    CODE:
	RETVAL = event->visibility.state;
    OUTPUT:
	RETVAL

MODULE = Gtk2::Gdk::Event	PACKAGE = Gtk2::Gdk::Event::Motion

BOOT:
	gperl_set_isa ("Gtk2::Gdk::Event::Motion", "Gtk2::Gdk::Event");

=for object Gtk2::Gdk::Event
=cut

 #struct _GdkEventMotion
 #{
 #//  GdkEventType type;  <- GdkEventAny
 #//  GdkWindow *window;  <- GdkEventAny
 #//  gint8 send_event;  <- GdkEventAny
 #//  guint32 time;  <- gdk_event_get_time
 #//  gdouble x; <- get_coords
 #//  gdouble y; <- get_coords
 #//  gdouble *axes; <- get_axes
 #//  guint state; <- get_state
 #  gint16 is_hint;
 #  GdkDevice *device;
 #//  gdouble x_root, y_root; <- get_root_coords
 #};

=for apidoc
=signature unsigned = $eventmotion->is_hint
=cut
guint
is_hint (event)
	GdkEvent * event
    CODE:
	RETVAL = event->motion.is_hint;
    OUTPUT:
	RETVAL

=for apidoc
=signature $device = $eventmotion->device
=cut
GdkDevice_ornull *
device (GdkEvent * event)
    CODE:
	RETVAL = event->motion.device;
    OUTPUT:
	RETVAL

MODULE = Gtk2::Gdk::Event	PACKAGE = Gtk2::Gdk::Event::Button

BOOT:
	gperl_set_isa ("Gtk2::Gdk::Event::Button", "Gtk2::Gdk::Event");

=for object Gtk2::Gdk::Event
=cut

 #struct _GdkEventButton
 #{
 #//  GdkEventType type;  <- GdkEventAny
 #//  GdkWindow *window;  <- GdkEventAny
 #//  gint8 send_event;  <- GdkEventAny
 #//  guint32 time;  <- gdk_event_get_time
 #//  gdouble x; <- get_coords
 #//  gdouble y; <- get_coords
 #//  gdouble *axes; <- get_axes
 #//  guint state; <- get_state
 #  guint button;
 #  GdkDevice *device;
 #//  gdouble x_root, y_root; <- get_root_coords
 #};

=for apidoc
=signature unsigned = $eventbutton->button
=cut
guint
button (event)
	GdkEvent * event
    CODE:
	RETVAL = event->button.button;
    OUTPUT:
	RETVAL

=for apidoc
=signature $device = $eventbutton->device
=cut
GdkDevice_ornull *
device (GdkEvent * event)
    CODE:
	RETVAL = event->motion.device;
    OUTPUT:
	RETVAL

MODULE = Gtk2::Gdk::Event	PACKAGE = Gtk2::Gdk::Event::Scroll

BOOT:
	gperl_set_isa ("Gtk2::Gdk::Event::Scroll", "Gtk2::Gdk::Event");

=for object Gtk2::Gdk::Event
=cut

 #struct _GdkEventScroll
 #{
 #//  GdkEventType type;  <- GdkEventAny
 #//  GdkWindow *window;  <- GdkEventAny
 #//  gint8 send_event;  <- GdkEventAny
 #//  guint32 time;  <- gdk_event_get_time
 #//  gdouble x; <- get_coords
 #//  gdouble y; <- get_coords
 #//  guint state; <- get_state
 #  GdkScrollDirection direction;
 #  GdkDevice *device;
 #//  gdouble x_root, y_root; <- get_root_coords
 #};

=for apidoc
=signature $scrolldirection = $eventscroll->direction
=cut
GdkScrollDirection
direction (event)
	GdkEvent * event
    CODE:
	RETVAL = event->scroll.direction;
    OUTPUT:
	RETVAL

=for apidoc
=signature $device = $eventscroll->device
=cut
GdkDevice_ornull *
device (GdkEvent * event)
    CODE:
	RETVAL = event->scroll.device;
    OUTPUT:
	RETVAL


MODULE = Gtk2::Gdk::Event	PACKAGE = Gtk2::Gdk::Event::Key

BOOT:
	gperl_set_isa ("Gtk2::Gdk::Event::Key", "Gtk2::Gdk::Event");

=for object Gtk2::Gdk::Event
=cut

 #struct _GdkEventKey
 #{
 #//  GdkEventType type;  <- GdkEventAny
 #//  GdkWindow *window;  <- GdkEventAny
 #//  gint8 send_event;  <- GdkEventAny
 #//  guint32 time;  <- gdk_event_get_time
 #//  guint state; <- get_state
 #  guint keyval;
 #  gint length;
 #  gchar *string;
 #  guint16 hardware_keycode;
 #  guint8 group;
 #};

=for apidoc
=signature unsigned = $eventkey->keyval
=cut
guint
keyval (event)
	GdkEvent * event
    CODE:
	RETVAL = event->key.keyval;
    OUTPUT:
	RETVAL

=for apidoc
=signature integer = $eventkey->length
=cut
gint
length (event)
	GdkEvent * event
    CODE:
	RETVAL = event->key.length;
    OUTPUT:
	RETVAL

=for apidoc
=signature string = $eventkey->string
=cut
gchar *
string (event)
	GdkEvent * event
    CODE:
	RETVAL = event->key.string;
    OUTPUT:
	RETVAL

MODULE = Gtk2::Gdk::Event	PACKAGE = Gtk2::Gdk::Event::Crossing

BOOT:
	gperl_set_isa ("Gtk2::Gdk::Event::Crossing", "Gtk2::Gdk::Event");

=for object Gtk2::Gdk::Event
=cut

 #struct _GdkEventCrossing
 #{
 #//  GdkEventType type;  <- GdkEventAny
 #//  GdkWindow *window;  <- GdkEventAny
 #//  gint8 send_event;  <- GdkEventAny
 #  GdkWindow *subwindow;
 #//  guint32 time;  <- gdk_event_get_time
 #//  gdouble x; <- get_coords
 #//  gdouble y; <- get_coords
 #//  gdouble x_root; <- get_root_coords
 #//  gdouble y_root; <- get_root_coords
 #  GdkCrossingMode mode;
 #  GdkNotifyType detail;
 #  gboolean focus;
 #//  guint state; <- get_state
 #};

=for apidoc
=signature $crossingmode = $eventcrossing->mode
=cut
GdkCrossingMode
mode (event)
	GdkEvent * event
    CODE:
	RETVAL = event->crossing.mode;
    OUTPUT:
	RETVAL

=for apidoc
=signature $notifytype = $eventcrossing->detail
=cut
GdkNotifyType
detail (GdkEvent * event)
    CODE:
	RETVAL = event->crossing.detail;
    OUTPUT:
	RETVAL

=for apidoc
=signature boolean = $eventcrossing->focus
=cut
gboolean
focus (GdkEvent * event)
    CODE:
	RETVAL = event->crossing.focus;
    OUTPUT:
	RETVAL

MODULE = Gtk2::Gdk::Event	PACKAGE = Gtk2::Gdk::Event::Focus

BOOT:
	gperl_set_isa ("Gtk2::Gdk::Event::Focus", "Gtk2::Gdk::Event");

=for object Gtk2::Gdk::Event
=cut

 #struct _GdkEventFocus
 #{
 #//  GdkEventType type;  <- GdkEventAny
 #//  GdkWindow *window;  <- GdkEventAny
 #//  gint8 send_event;  <- GdkEventAny
 #  gint16 in;
 #};

=for apidoc
=signature integer = $eventfocus->in
=cut
gint16
in (event)
	GdkEvent * event
    CODE:
	RETVAL = event->focus_change.in;
    OUTPUT:
	RETVAL

MODULE = Gtk2::Gdk::Event	PACKAGE = Gtk2::Gdk::Event::Configure

BOOT:
	gperl_set_isa ("Gtk2::Gdk::Event::Configure", "Gtk2::Gdk::Event");

=for object Gtk2::Gdk::Event
=cut

 #struct _GdkEventConfigure
 #{
 #//  GdkEventType type;  <- GdkEventAny
 #//  GdkWindow *window;  <- GdkEventAny
 #//  gint8 send_event;  <- GdkEventAny
 #//  gint x, y; <- get_coords
 #  gint width;
 #  gint height;
 #};

=for apidoc Gtk2::Gdk::Event::Configure::width
=signature integer = $eventconfigure->width
=cut

=for apidoc Gtk2::Gdk::Event::Configure::height
=signature integer = $eventconfigure->height
=cut

gint
dim (event)
	GdkEvent * event
    ALIAS:
	Gtk2::Gdk::Event::Configure::width  = 0
	Gtk2::Gdk::Event::Configure::height = 1
    CODE:
	RETVAL = ix ? event->configure.height : event->configure.width;
    OUTPUT:
	RETVAL

MODULE = Gtk2::Gdk::Event	PACKAGE = Gtk2::Gdk::Event::Property

BOOT:
	gperl_set_isa ("Gtk2::Gdk::Event::Property", "Gtk2::Gdk::Event");

=for object Gtk2::Gdk::Event
=cut

 #struct _GdkEventProperty
 #{
 #//  GdkEventType type;  <- GdkEventAny
 #//  GdkWindow *window;  <- GdkEventAny
 #//  gint8 send_event;  <- GdkEventAny
 #  GdkAtom atom;
 #//  guint32 time;  <- gdk_event_get_time
 #  guint state;
 #};

MODULE = Gtk2::Gdk::Event	PACKAGE = Gtk2::Gdk::Event::Selection

BOOT:
	gperl_set_isa ("Gtk2::Gdk::Event::Selection", "Gtk2::Gdk::Event");

=for object Gtk2::Gdk::Event
=cut

 #struct _GdkEventSelection
 #{
 #//  GdkEventType type;  <- GdkEventAny
 #//  GdkWindow *window;  <- GdkEventAny
 #//  gint8 send_event;  <- GdkEventAny
 #  GdkAtom selection;
 #  GdkAtom target;
 #  GdkAtom property;
 #//  guint32 time;  <- gdk_event_get_time
 #  GdkNativeWindow requestor;
 #};

MODULE = Gtk2::Gdk::Event	PACKAGE = Gtk2::Gdk::Event::Proximity

BOOT:
	gperl_set_isa ("Gtk2::Gdk::Event::Proximity", "Gtk2::Gdk::Event");

=for object Gtk2::Gdk::Event
=cut

 #/* This event type will be used pretty rarely. It only is important
 #   for XInput aware programs that are drawing their own cursor */

 #struct _GdkEventProximity
 #{
 #//  GdkEventType type;  <- GdkEventAny
 #//  GdkWindow *window;  <- GdkEventAny
 #//  gint8 send_event;  <- GdkEventAny
 #//  guint32 time;  <- gdk_event_get_time
 #  GdkDevice *device;
 #};

=for apidoc
=signature $device = $eventproximity->device
=cut
GdkDevice_ornull *
device (GdkEvent * event)
    CODE:
	RETVAL = event->motion.device;
    OUTPUT:
	RETVAL

MODULE = Gtk2::Gdk::Event	PACKAGE = Gtk2::Gdk::Event::Client

BOOT:
	gperl_set_isa ("Gtk2::Gdk::Event::Client", "Gtk2::Gdk::Event");

=for object Gtk2::Gdk::Event
=cut

 #struct _GdkEventClient
 #{
 #//  GdkEventType type;  <- GdkEventAny
 #//  GdkWindow *window;  <- GdkEventAny
 #//  gint8 send_event;  <- GdkEventAny
 #  GdkAtom message_type;
 #  gushort data_format;
 #  union {
 #    char b[20];
 #    short s[10];
 #    long l[5];
 #  } data;
 #};

MODULE = Gtk2::Gdk::Event	PACKAGE = Gtk2::Gdk::Event::Setting

BOOT:
	gperl_set_isa ("Gtk2::Gdk::Event::Setting", "Gtk2::Gdk::Event");

=for object Gtk2::Gdk::Event
=cut

 #struct _GdkEventSetting
 #{
 #//  GdkEventType type;  <- GdkEventAny
 #//  GdkWindow *window;  <- GdkEventAny
 #//  gint8 send_event;  <- GdkEventAny
 #  GdkSettingAction action;
 #  char *name;
 #};

=for apidoc
=signature $settingaction = $eventsetting->action
=cut
GdkSettingAction
action (GdkEvent * event)
    CODE:
	RETVAL = event->setting.action;
    OUTPUT:
	RETVAL

=for apidoc
=signature string = $eventsetting->name
=cut
char *
name (GdkEvent * event)
    CODE:
	RETVAL = event->setting.name;
    OUTPUT:
	RETVAL

MODULE = Gtk2::Gdk::Event	PACKAGE = Gtk2::Gdk::Event::WindowState

BOOT:
	gperl_set_isa ("Gtk2::Gdk::Event::WindowState", "Gtk2::Gdk::Event");

=for object Gtk2::Gdk::Event
=cut

 #struct _GdkEventWindowState
 #{
 #//  GdkEventType type;  <- GdkEventAny
 #//  GdkWindow *window;  <- GdkEventAny
 #//  gint8 send_event;  <- GdkEventAny
 #  GdkWindowState changed_mask;
 #  GdkWindowState new_window_state;
 #};

=for apidoc
=signature $windowstate = $eventwindowstate->changed_mask
=cut
GdkWindowState
changed_mask (event)
	GdkEvent * event
    CODE:
	RETVAL = event->window_state.changed_mask;
    OUTPUT:
	RETVAL

=for apidoc
=signature $windowstate = $eventwindowstate->new_window_state
=cut
GdkWindowState
new_window_state (event)
	GdkEvent * event
    CODE:
	RETVAL = event->window_state.new_window_state;
    OUTPUT:
	RETVAL

MODULE = Gtk2::Gdk::Event	PACKAGE = Gtk2::Gdk::Event::DND

BOOT:
	gperl_set_isa ("Gtk2::Gdk::Event::DND", "Gtk2::Gdk::Event");

=for object Gtk2::Gdk::Event
=cut

 #/* Event types for DND */

 #struct _GdkEventDND {
 #//  GdkEventType type;  <- GdkEventAny
 #//  GdkWindow *window;  <- GdkEventAny
 #//  gint8 send_event;  <- GdkEventAny
 #  GdkDragContext *context;

 #//  guint32 time;  <- gdk_event_get_time
 #//  gshort x_root, y_root; <- get_root_coords
 #};

=for apidoc
=signature $dragcontext = $eventdnd->context
=cut
GdkDragContext *
context (event)
	GdkEvent * event
    CODE:
	RETVAL = event->dnd.context;
    OUTPUT:
	RETVAL

 #union _GdkEvent
 #{
 #  GdkEventType		    type;
 #  GdkEventAny		    any;
 #  GdkEventExpose	    expose;
 #  GdkEventNoExpose	    no_expose;
 #  GdkEventVisibility	    visibility;
 #  GdkEventMotion	    motion;
 #  GdkEventButton	    button;
 #  GdkEventScroll            scroll;
 #  GdkEventKey		    key;
 #  GdkEventCrossing	    crossing;
 #  GdkEventFocus		    focus_change;
 #  GdkEventConfigure	    configure;
 #  GdkEventProperty	    property;
 #  GdkEventSelection	    selection;
 #  GdkEventProximity	    proximity;
 #  GdkEventClient	    client;
 #  GdkEventDND               dnd;
 #  GdkEventWindowState       window_state;
 #  GdkEventSetting           setting;
 #};


MODULE = Gtk2::Gdk::Event	PACKAGE = Gtk2::Gdk	PREFIX = gdk_

# these are of limited usefulness, as you must have compiled GTK+ 
# with debugging turned on.

void
gdk_set_show_events (class, show_events)
	gboolean show_events
    C_ARGS:
	show_events

gboolean
gdk_get_show_events (class)
    C_ARGS:
	/*void*/

 # FIXME needs a callback
 ## void gdk_add_client_message_filter (GdkAtom message_type, GdkFilterFunc func, gpointer data)
 ##void
 ##gdk_add_client_message_filter (message_type, func, data)
 ##	GdkAtom message_type
 ##	GdkFilterFunc func
 ##	gpointer data

 ## gboolean gdk_setting_get (const gchar *name, GValue *value)
SV *
gdk_setting_get (class, name)
	const gchar *name
    PREINIT:
	GValue value = {0,};
    CODE:
	g_value_init (&value, G_TYPE_INT);
	if (!gdk_setting_get (name, &value))
		XSRETURN_UNDEF;
	RETVAL = gperl_sv_from_value (&value);
	g_value_unset (&value);
    OUTPUT:
	RETVAL

MODULE = Gtk2::Gdk::Event	PACKAGE = Gtk2::Gdk::Event	PREFIX = gdk_event_
