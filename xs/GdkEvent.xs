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

#if !GTK_CHECK_VERSION (2, 2, 0)
# define gdk_event_new	gtk2perl_gdk_event_new
static GdkEvent *
gtk2perl_gdk_event_new (GdkEventType type)
{
	GdkEvent ev;
	memset (&ev, 0, sizeof (GdkEvent));
	ev.any.type = type;
	return gdk_event_copy (&ev);
}
#endif

MODULE = Gtk2::Gdk::Event	PACKAGE = Gtk2::Gdk	PREFIX = gdk_

 ## gboolean gdk_events_pending (void)
gboolean
gdk_events_pending (class)
    C_ARGS:
	/*void*/

MODULE = Gtk2::Gdk::Event	PACKAGE = Gtk2::Gdk::Event	PREFIX = gdk_event_

=head1 EVENT TYPES

=over

=item * L<Gtk2::Gdk::Event::Button>

=item * L<Gtk2::Gdk::Event::Client>

=item * L<Gtk2::Gdk::Event::Configure>

=item * L<Gtk2::Gdk::Event::Crossing>

=item * L<Gtk2::Gdk::Event::DND>

=item * L<Gtk2::Gdk::Event::Expose>

=item * L<Gtk2::Gdk::Event::Focus>

=item * L<Gtk2::Gdk::Event::Key>

=item * L<Gtk2::Gdk::Event::Motion>

=item * L<Gtk2::Gdk::Event::NoExpose>

=item * L<Gtk2::Gdk::Event::Property>

=item * L<Gtk2::Gdk::Event::Proximity>

=item * L<Gtk2::Gdk::Event::Scroll>

=item * L<Gtk2::Gdk::Event::Selection>

=item * L<Gtk2::Gdk::Event::Setting>

=item * L<Gtk2::Gdk::Event::Visibility>

=item * L<Gtk2::Gdk::Event::WindowState>

=back

=cut

=for enum GdkEventType
=cut

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

 ## GdkEvent* gdk_event_get (void)
 ## GdkEvent* gdk_event_peek (void)
## caller must free
GdkEvent_own_ornull*
gdk_event_get (class)
    ALIAS:
	peek = 1
    C_ARGS:
	/*void*/
    CLEANUP:
	PERL_UNUSED_VAR (ix);

 ## GdkEvent* gdk_event_get_graphics_expose (GdkWindow *window)
GdkEvent_own_ornull*
gdk_event_get_graphics_expose (class, window)
	GdkWindow *window
    C_ARGS:
	window

 ## void gdk_event_put (GdkEvent *event)
## call as Gtk2::Gdk::Event->put ($event)
void
gdk_event_put (class, event)
	GdkEvent *event
    C_ARGS:
	event

 # this didn't actually exist until 2.2.0, when there were some private
 # things added in Gdk; we provide a custom one on 2.0.x, because we're
 # nice guys.
 ## GdkEvent* gdk_event_new (GdkEventType type)
## caller must free
GdkEvent_own*
gdk_event_new (class, type)
	GdkEventType type
    C_ARGS:
	type

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
	Gtk2::Gdk::Event::time = 1
    CLEANUP:
	PERL_UNUSED_VAR (ix);

 ## gboolean gdk_event_get_state (GdkEvent *event, GdkModifierType *state)
GdkModifierType
gdk_event_get_state (event)
	GdkEvent *event
    ALIAS:
	Gtk2::Gdk::Event::state = 1
    CODE:
	PERL_UNUSED_VAR (ix);
	if (!gdk_event_get_state (event, &RETVAL))
		XSRETURN_UNDEF;
    OUTPUT:
	RETVAL

=for apidoc Gtk2::Gdk::Event::get_coords
=for signature ($x, $y) = $event->get_coords
=cut

=for apidoc Gtk2::Gdk::Event::coords
=for signature ($x, $y) = $event->coords
=cut

 ## gboolean gdk_event_get_coords (GdkEvent *event, gdouble *x_win, gdouble *y_win)
void
gdk_event_get_coords (event)
	GdkEvent *event
    ALIAS:
	Gtk2::Gdk::Event::coords = 1
    PREINIT:
	gdouble x;
	gdouble y;
    PPCODE:
	if (!gdk_event_get_coords (event, &x, &y))
		XSRETURN_EMPTY;
	PERL_UNUSED_VAR (ix);
	EXTEND (SP, 2);
	PUSHs (sv_2mortal (newSVnv (x)));
	PUSHs (sv_2mortal (newSVnv (y)));

=for apidoc Gtk2::Gdk::Event::get_root_coords
=for signature ($x_root, $y_root) = $event->get_root_coords
=cut

=for apidoc Gtk2::Gdk::Event::root_coords
=for signature ($x_root, $y_root) = $event->root_coords
=cut

=for apidoc Gtk2::Gdk::Event::x_root
=for signature integer = $event->x_root
=cut

=for apidoc Gtk2::Gdk::Event::y_root
=for signature integer = $event->y_root
=cut

 ## gboolean gdk_event_get_root_coords (GdkEvent *event, gdouble *x_root, gdouble *y_root)
void
gdk_event_get_root_coords (event)
	GdkEvent *event
    ALIAS:
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
gdk_event_get_axis (event, axis_use)
	GdkEvent *event
	GdkAxisUse axis_use
    ALIAS:
	Gtk2::Gdk::Event::axis = 1
    CODE:
	PERL_UNUSED_VAR (ix);
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
window (GdkEvent * event, GdkWindow_ornull * newvalue=NULL)
    CODE:
	RETVAL = event->any.window;
	if (items == 2 && newvalue != event->any.window)
	{
		if (event->any.window)
			g_object_unref (event->any.window);
		g_object_ref (newvalue);
		event->any.window = newvalue;
	}
    OUTPUT:
	RETVAL

gint8
send_event (GdkEvent * event, gint8 newvalue=0)
    CODE:
	RETVAL = event->any.send_event;
	if (items == 2)
		event->any.send_event = newvalue;
    OUTPUT:
	RETVAL

MODULE = Gtk2::Gdk::Event	PACKAGE = Gtk2::Gdk::Event::Expose

=head1 HIERARCHY

  Gtk2::Gdk::Event
  +----Gtk2::Gdk::Event::Expose

=cut

BOOT:
	gperl_set_isa ("Gtk2::Gdk::Event::Expose", "Gtk2::Gdk::Event");

 #struct _GdkEventExpose
 #{
 #//  GdkEventType type;  <- GdkEventAny
 #//  GdkWindow *window;  <- GdkEventAny
 #//  gint8 send_event;  <- GdkEventAny
 #  GdkRectangle area;
 #  GdkRegion *region;
 #  gint count; /* If non-zero, how many more events follow. */
 #};

GdkRectangle*
area (GdkEvent * eventexpose, GdkRectangle * newvalue=NULL)
    CODE:
	RETVAL = &(eventexpose->expose.area);
	if (items == 2)
	{
		eventexpose->expose.area.x = newvalue->x;
		eventexpose->expose.area.y = newvalue->y;
		eventexpose->expose.area.width = newvalue->width;
		eventexpose->expose.area.height = newvalue->height;
	}
    OUTPUT:
	RETVAL

GdkRegion_own_ornull *
region (GdkEvent * eventexpose, GdkRegion_ornull * newvalue=NULL)
    CODE:
	RETVAL = NULL;
	if (eventexpose->expose.region)
		RETVAL = gdk_region_copy (eventexpose->expose.region);
	if (items == 2 && newvalue != eventexpose->expose.region)
	{
		if (eventexpose->expose.region)
			gdk_region_destroy (eventexpose->expose.region);
		if (newvalue)
			eventexpose->expose.region = gdk_region_copy (newvalue);
		else
			eventexpose->expose.region = NULL;
	}
    OUTPUT:
	RETVAL

gint
count (GdkEvent * eventexpose, guint newvalue=0)
    CODE:
	RETVAL = eventexpose->expose.count;
	if (items == 2)
		eventexpose->expose.count = newvalue;
    OUTPUT:
	RETVAL

MODULE = Gtk2::Gdk::Event	PACKAGE = Gtk2::Gdk::Event::NoExpose

=head1 HIERARCHY

  Gtk2::Gdk::Event
  +----Gtk2::Gdk::Event::NoExpose

=cut

BOOT:
	gperl_set_isa ("Gtk2::Gdk::Event::NoExpose", "Gtk2::Gdk::Event");

 #struct _GdkEventNoExpose
 #{
 #//  GdkEventType type;  <- GdkEventAny
 #//  GdkWindow *window;  <- GdkEventAny
 #//  gint8 send_event;  <- GdkEventAny
 #};

MODULE = Gtk2::Gdk::Event	PACKAGE = Gtk2::Gdk::Event::Visibility

=head1 HIERARCHY

  Gtk2::Gdk::Event
  +----Gtk2::Gdk::Event::Visibility

=cut

BOOT:
	gperl_set_isa ("Gtk2::Gdk::Event::Visibility", "Gtk2::Gdk::Event");

 #struct _GdkEventVisibility
 #{
 #//  GdkEventType type;  <- GdkEventAny
 #//  GdkWindow *window;  <- GdkEventAny
 #//  gint8 send_event;  <- GdkEventAny
 #  GdkVisibilityState state;
 #};

# different return type, override Gtk2::Gdk::Event::state
GdkVisibilityState
state (GdkEvent * eventvisibility, GdkVisibilityState newvalue=0)
    CODE:
	RETVAL = eventvisibility->visibility.state;
	if (items == 2)
		eventvisibility->visibility.state = newvalue;
    OUTPUT:
	RETVAL

MODULE = Gtk2::Gdk::Event	PACKAGE = Gtk2::Gdk::Event::Motion

=head1 HIERARCHY

  Gtk2::Gdk::Event
  +----Gtk2::Gdk::Event::Motion

=cut

BOOT:
	gperl_set_isa ("Gtk2::Gdk::Event::Motion", "Gtk2::Gdk::Event");

 #struct _GdkEventMotion
 #{
 #//  GdkEventType type;  <- GdkEventAny
 #//  GdkWindow *window;  <- GdkEventAny
 #//  gint8 send_event;  <- GdkEventAny
 #//  guint32 time;  <- gdk_event_get_time
 #  gdouble x;
 #  gdouble y;
 #//  gdouble *axes; <- get_axes
 #//  guint state; <- get_state
 #  gint16 is_hint;
 #  GdkDevice *device;
 #//  gdouble x_root, y_root; <- get_root_coords
 #};

guint
is_hint (GdkEvent * eventmotion, guint newvalue=0)
    CODE:
	RETVAL = eventmotion->motion.is_hint;
	if (items == 2)
		eventmotion->motion.is_hint = newvalue;
    OUTPUT:
	RETVAL

## TODO/FIXME: how would this be set
GdkDevice_ornull *
device (GdkEvent * eventmotion)
    CODE:
	RETVAL = eventmotion->motion.device;
    OUTPUT:
	RETVAL

gdouble
x (GdkEvent * event, gdouble newvalue=0.0)
    CODE:
	RETVAL = event->motion.x;
	if (items == 2)
		event->motion.x = newvalue;
    OUTPUT:
	RETVAL

gdouble
y (GdkEvent * event, gdouble newvalue=0.0)
    CODE:
	RETVAL = event->motion.y;
	if (items == 2)
		event->motion.y = newvalue;
    OUTPUT:
	RETVAL

MODULE = Gtk2::Gdk::Event	PACKAGE = Gtk2::Gdk::Event::Button

=head1 HIERARCHY

  Gtk2::Gdk::Event
  +----Gtk2::Gdk::Event::Button

=cut

BOOT:
	gperl_set_isa ("Gtk2::Gdk::Event::Button", "Gtk2::Gdk::Event");

 #struct _GdkEventButton
 #{
 #//  GdkEventType type;  <- GdkEventAny
 #//  GdkWindow *window;  <- GdkEventAny
 #//  gint8 send_event;  <- GdkEventAny
 #//  guint32 time;  <- gdk_event_get_time
 #  gdouble x;
 #  gdouble y;
 #//  gdouble *axes; <- get_axes
 #//  guint state; <- get_state
 #  guint button;
 #  GdkDevice *device;
 #//  gdouble x_root, y_root; <- get_root_coords
 #};

guint
button (GdkEvent * eventbutton, guint newvalue=0)
    CODE:
	RETVAL = eventbutton->button.button;
	if (items == 2)
		eventbutton->button.button = newvalue;
    OUTPUT:
	RETVAL

## TODO/FIXME: how would this be set
GdkDevice_ornull *
device (GdkEvent * eventbutton)
    CODE:
	RETVAL = eventbutton->button.device;
    OUTPUT:
	RETVAL

gdouble
x (GdkEvent * event, gdouble newvalue=0.0)
    CODE:
	RETVAL = event->button.x;
	if (items == 2)
		event->button.x = newvalue;
    OUTPUT:
	RETVAL

gdouble
y (GdkEvent * event, gdouble newvalue=0.0)
    CODE:
	RETVAL = event->button.y;
	if (items == 2)
		event->button.y = newvalue;
    OUTPUT:
	RETVAL

MODULE = Gtk2::Gdk::Event	PACKAGE = Gtk2::Gdk::Event::Scroll

=head1 HIERARCHY

  Gtk2::Gdk::Event
  +----Gtk2::Gdk::Event::Scroll

=cut

BOOT:
	gperl_set_isa ("Gtk2::Gdk::Event::Scroll", "Gtk2::Gdk::Event");

 #struct _GdkEventScroll
 #{
 #//  GdkEventType type;  <- GdkEventAny
 #//  GdkWindow *window;  <- GdkEventAny
 #//  gint8 send_event;  <- GdkEventAny
 #//  guint32 time;  <- gdk_event_get_time
 #  gdouble x;
 #  gdouble y;
 #//  guint state; <- get_state
 #  GdkScrollDirection direction;
 #  GdkDevice *device;
 #//  gdouble x_root, y_root; <- get_root_coords
 #};

GdkScrollDirection
direction (GdkEvent * eventscroll, GdkScrollDirection newvalue=0)
    CODE:
	RETVAL = eventscroll->scroll.direction;
	if (items == 2)
		eventscroll->scroll.direction = newvalue;
    OUTPUT:
	RETVAL

## TODO/FIXME: how would this be set
GdkDevice_ornull *
device (GdkEvent * eventscroll)
    CODE:
	RETVAL = eventscroll->scroll.device;
    OUTPUT:
	RETVAL

gdouble
x (GdkEvent * event, gdouble newvalue=0.0)
    CODE:
	RETVAL = event->scroll.x;
	if (items == 2)
		event->scroll.x = newvalue;
    OUTPUT:
	RETVAL

gdouble
y (GdkEvent * event, gdouble newvalue=0.0)
    CODE:
	RETVAL = event->scroll.y;
	if (items == 2)
		event->scroll.y = newvalue;
    OUTPUT:
	RETVAL

MODULE = Gtk2::Gdk::Event	PACKAGE = Gtk2::Gdk::Event::Key

=head1 HIERARCHY

  Gtk2::Gdk::Event
  +----Gtk2::Gdk::Event::Key

=cut

BOOT:
	gperl_set_isa ("Gtk2::Gdk::Event::Key", "Gtk2::Gdk::Event");

 #struct _GdkEventKey
 #{
 #//  GdkEventType type;  <- GdkEventAny
 #//  GdkWindow *window;  <- GdkEventAny
 #//  gint8 send_event;  <- GdkEventAny
 #//  guint32 time;  <- gdk_event_get_time
 #//  guint state; <- get_state
 #  guint keyval;
 #//  gint length; 	deprecated
 #//  gchar *string; 	deprecated
 #  guint16 hardware_keycode;
 #  guint8 group;
 #};

guint
keyval (GdkEvent * eventkey, guint newvalue=0)
    CODE:
	RETVAL = eventkey->key.keyval;
	if (items == 2)
		eventkey->key.keyval = newvalue;
    OUTPUT:
	RETVAL

guint16
hardware_keycode (GdkEvent * eventkey, guint16 newvalue=0)
    CODE:
	RETVAL = eventkey->key.hardware_keycode;
	if (items == 2)
		eventkey->key.hardware_keycode = newvalue;
    OUTPUT:
	RETVAL

guint8
group (GdkEvent * eventkey, guint8 newvalue=0)
    CODE:
	RETVAL = eventkey->key.group;
	if (items == 2)
		eventkey->key.group = newvalue;
    OUTPUT:
	RETVAL


## TODO/FIXME: remove altogether???
##gint
##length (GdkEvent * eventkey, guint newvalue=0)
##    CODE:
##	RETVAL = eventkey->key.length;
##	if (items == 2)
##		eventkey->key.length = newvalue;
##    OUTPUT:
##	RETVAL
##
##gchar *
##string (GdkEvent * eventkey, gchar * newvalue=NULL)
##    CODE:
##	RETVAL = eventkey->key.string;
##	if (items == 2)
##	{
##		g_free (eventkey->key.string);
##		if (newvalue)
##			eventkey->key.string = g_strdup (newvalue);
##		else
##			eventkey->key.string = NULL;
##	}
##    OUTPUT:
##	RETVAL

MODULE = Gtk2::Gdk::Event	PACKAGE = Gtk2::Gdk::Event::Crossing

=head1 HIERARCHY

  Gtk2::Gdk::Event
  +----Gtk2::Gdk::Event::Crossing

=cut

BOOT:
	gperl_set_isa ("Gtk2::Gdk::Event::Crossing", "Gtk2::Gdk::Event");

 #struct _GdkEventCrossing
 #{
 #//  GdkEventType type;  <- GdkEventAny
 #//  GdkWindow *window;  <- GdkEventAny
 #//  gint8 send_event;  <- GdkEventAny
 #  GdkWindow *subwindow;
 #//  guint32 time;  <- gdk_event_get_time
 #  gdouble x;
 #  gdouble y;
 #//  gdouble x_root; <- get_root_coords
 #//  gdouble y_root; <- get_root_coords
 #  GdkCrossingMode mode;
 #  GdkNotifyType detail;
 #  gboolean focus;
 #//  guint state; <- get_state
 #};

GdkWindow_ornull *
subwindow (GdkEvent * event, GdkWindow_ornull * newvalue=NULL)
    CODE:
	RETVAL = event->crossing.subwindow;
	if (items == 2 && newvalue != event->crossing.subwindow)
	{
		if (event->crossing.subwindow)
			g_object_unref (event->crossing.subwindow);
		g_object_ref (newvalue);
		event->crossing.subwindow = newvalue;
	}
    OUTPUT:
	RETVAL

GdkCrossingMode
mode (GdkEvent * eventcrossing, GdkCrossingMode newvalue=0)
    CODE:
	RETVAL = eventcrossing->crossing.mode;
	if (items == 2)
		eventcrossing->crossing.mode = newvalue;
    OUTPUT:
	RETVAL

GdkNotifyType
detail (GdkEvent * eventcrossing, GdkNotifyType newvalue=0)
    CODE:
	RETVAL = eventcrossing->crossing.detail;
	if (items == 2)
		eventcrossing->crossing.detail = newvalue;
    OUTPUT:
	RETVAL

gboolean
focus (GdkEvent * eventcrossing, gboolean newvalue=0)
    CODE:
	RETVAL = eventcrossing->crossing.focus;
	if (items == 2)
		eventcrossing->crossing.focus = newvalue;
    OUTPUT:
	RETVAL

gdouble
x (GdkEvent * event, gdouble newvalue=0.0)
    CODE:
	RETVAL = event->crossing.x;
	if (items == 2)
		event->crossing.x = newvalue;
    OUTPUT:
	RETVAL

gdouble
y (GdkEvent * event, gdouble newvalue=0.0)
    CODE:
	RETVAL = event->crossing.y;
	if (items == 2)
		event->crossing.y = newvalue;
    OUTPUT:
	RETVAL

MODULE = Gtk2::Gdk::Event	PACKAGE = Gtk2::Gdk::Event::Focus

=head1 HIERARCHY

  Gtk2::Gdk::Event
  +----Gtk2::Gdk::Event::Focus

=cut

BOOT:
	gperl_set_isa ("Gtk2::Gdk::Event::Focus", "Gtk2::Gdk::Event");

 #struct _GdkEventFocus
 #{
 #//  GdkEventType type;  <- GdkEventAny
 #//  GdkWindow *window;  <- GdkEventAny
 #//  gint8 send_event;  <- GdkEventAny
 #  gint16 in;
 #};

gint16
in (GdkEvent * eventfocus, gint16 newvalue=0)
    CODE:
	RETVAL = eventfocus->focus_change.in;
	if (items == 2)
		eventfocus->focus_change.in = newvalue;
    OUTPUT:
	RETVAL

MODULE = Gtk2::Gdk::Event	PACKAGE = Gtk2::Gdk::Event::Configure

=head1 HIERARCHY

  Gtk2::Gdk::Event
  +----Gtk2::Gdk::Event::Configure

=cut

BOOT:
	gperl_set_isa ("Gtk2::Gdk::Event::Configure", "Gtk2::Gdk::Event");

 #struct _GdkEventConfigure
 #{
 #//  GdkEventType type;  <- GdkEventAny
 #//  GdkWindow *window;  <- GdkEventAny
 #//  gint8 send_event;  <- GdkEventAny
 #  gint x, y;
 #  gint width;
 #  gint height;
 #};

gint
width (GdkEvent * eventconfigure, gint newvalue=0)
    ALIAS:
	Gtk2::Gdk::Event::Configure::height = 1
    CODE:
	RETVAL = -1;
	switch (ix) {
		case 0:
			RETVAL = eventconfigure->configure.width;
			break;
		case 1:
			RETVAL = eventconfigure->configure.height;
			break;
	}
	if (items == 2)
	{
		switch (ix) {
			case 0:
				eventconfigure->configure.width = newvalue;
				break;
			case 1:
				eventconfigure->configure.height = newvalue;
				break;
		}
	}
    OUTPUT:
	RETVAL

gint
x (GdkEvent * event, gint newvalue=0)
    CODE:
	RETVAL = event->configure.x;
	if (items == 2)
		event->configure.x = newvalue;
    OUTPUT:
	RETVAL

gint
y (GdkEvent * event, gint newvalue=0)
    CODE:
	RETVAL = event->configure.y;
	if (items == 2)
		event->configure.y = newvalue;
    OUTPUT:
	RETVAL

MODULE = Gtk2::Gdk::Event	PACKAGE = Gtk2::Gdk::Event::Property

=head1 HIERARCHY

  Gtk2::Gdk::Event
  +----Gtk2::Gdk::Event::Property

=cut

BOOT:
	gperl_set_isa ("Gtk2::Gdk::Event::Property", "Gtk2::Gdk::Event");

 #struct _GdkEventProperty
 #{
 #//  GdkEventType type;  <- GdkEventAny
 #//  GdkWindow *window;  <- GdkEventAny
 #//  gint8 send_event;  <- GdkEventAny
 #  GdkAtom atom;
 #//  guint32 time;  <- gdk_event_get_time
 #  guint state;
 #};

GdkAtom
atom (GdkEvent * eventproperty, GdkAtom newvalue=0)
    CODE:
	RETVAL = eventproperty->property.atom;
	if (items == 2)
		eventproperty->property.atom = newvalue;
    OUTPUT:
	RETVAL

guint
state (GdkEvent * eventproperty, guint newvalue=0)
    CODE:
	RETVAL = eventproperty->property.state;
	if (items == 2)
		eventproperty->property.state = newvalue;
    OUTPUT:
	RETVAL

MODULE = Gtk2::Gdk::Event	PACKAGE = Gtk2::Gdk::Event::Selection

=head1 HIERARCHY

  Gtk2::Gdk::Event
  +----Gtk2::Gdk::Event::Selection

=cut

BOOT:
	gperl_set_isa ("Gtk2::Gdk::Event::Selection", "Gtk2::Gdk::Event");

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

GdkAtom
selection (GdkEvent * eventselection, GdkAtom newvalue=0)
    CODE:
	RETVAL = eventselection->selection.selection;
	if (items == 2)
		eventselection->selection.selection = newvalue;
    OUTPUT:
	RETVAL

GdkAtom
target (GdkEvent * eventselection, GdkAtom newvalue=0)
    CODE:
	RETVAL = eventselection->selection.target;
	if (items == 2)
		eventselection->selection.target = newvalue;
    OUTPUT:
	RETVAL

GdkAtom
property (GdkEvent * eventselection, GdkAtom newvalue=0)
    CODE:
	RETVAL = eventselection->selection.property;
	if (items == 2)
		eventselection->selection.property = newvalue;
    OUTPUT:
	RETVAL

GdkNativeWindow
requestor (GdkEvent * eventselection, GdkNativeWindow newvalue=0)
    CODE:
	RETVAL = eventselection->selection.requestor;
	if (items == 2)
		eventselection->selection.requestor = newvalue;
    OUTPUT:
	RETVAL

MODULE = Gtk2::Gdk::Event	PACKAGE = Gtk2::Gdk::Event::Proximity

=head1 HIERARCHY

  Gtk2::Gdk::Event
  +----Gtk2::Gdk::Event::Proximity

=cut

BOOT:
	gperl_set_isa ("Gtk2::Gdk::Event::Proximity", "Gtk2::Gdk::Event");

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

## TODO/FIXME: how do we set this
GdkDevice_ornull *
device (GdkEvent * eventproximity)
    CODE:
	RETVAL = eventproximity->motion.device;
    OUTPUT:
	RETVAL

MODULE = Gtk2::Gdk::Event	PACKAGE = Gtk2::Gdk::Event::Client

=head1 HIERARCHY

  Gtk2::Gdk::Event
  +----Gtk2::Gdk::Event::Client

=cut

BOOT:
	gperl_set_isa ("Gtk2::Gdk::Event::Client", "Gtk2::Gdk::Event");

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

gushort
data_format (GdkEvent * eventclient, gushort newvalue=0)
    CODE:
	RETVAL = eventclient->client.data_format;
	if (items == 2)
		eventclient->client.data_format = newvalue;
    OUTPUT:
	RETVAL

## TODO/FIXME: implement accessors for data

MODULE = Gtk2::Gdk::Event	PACKAGE = Gtk2::Gdk::Event::Setting

=head1 HIERARCHY

  Gtk2::Gdk::Event
  +----Gtk2::Gdk::Event::Setting

=cut

BOOT:
	gperl_set_isa ("Gtk2::Gdk::Event::Setting", "Gtk2::Gdk::Event");

 #struct _GdkEventSetting
 #{
 #//  GdkEventType type;  <- GdkEventAny
 #//  GdkWindow *window;  <- GdkEventAny
 #//  gint8 send_event;  <- GdkEventAny
 #  GdkSettingAction action;
 #  char *name;
 #};

GdkSettingAction
action (GdkEvent * eventsetting, GdkSettingAction newvalue=0)
    CODE:
	RETVAL = eventsetting->setting.action;
	if (items == 2)
		eventsetting->setting.action = newvalue;
    OUTPUT:
	RETVAL

char *
name (GdkEvent * eventsetting, char * newvalue=NULL)
    CODE:
	RETVAL = eventsetting->setting.name;
	if (items == 2)
	{
		if (newvalue)
			eventsetting->setting.name = g_strdup (newvalue);
		else
			eventsetting->setting.name = NULL;
	}
    OUTPUT:
	RETVAL

MODULE = Gtk2::Gdk::Event	PACKAGE = Gtk2::Gdk::Event::WindowState

=head1 HIERARCHY

  Gtk2::Gdk::Event
  +----Gtk2::Gdk::Event::WindowState

=cut

BOOT:
	gperl_set_isa ("Gtk2::Gdk::Event::WindowState", "Gtk2::Gdk::Event");

 #struct _GdkEventWindowState
 #{
 #//  GdkEventType type;  <- GdkEventAny
 #//  GdkWindow *window;  <- GdkEventAny
 #//  gint8 send_event;  <- GdkEventAny
 #  GdkWindowState changed_mask;
 #  GdkWindowState new_window_state;
 #};

GdkWindowState
changed_mask (GdkEvent * eventwindowstate, GdkWindowState newvalue=0)
    CODE:
	RETVAL = eventwindowstate->window_state.changed_mask;
	if (items == 2)
		eventwindowstate->window_state.changed_mask = newvalue;
    OUTPUT:
	RETVAL

GdkWindowState
new_window_state (GdkEvent * eventwindowstate, GdkWindowState newvalue=0)
    CODE:
	RETVAL = eventwindowstate->window_state.new_window_state;
	if (items == 2)
		eventwindowstate->window_state.new_window_state = newvalue;
    OUTPUT:
	RETVAL

MODULE = Gtk2::Gdk::Event	PACKAGE = Gtk2::Gdk::Event::DND

=head1 HIERARCHY

  Gtk2::Gdk::Event
  +----Gtk2::Gdk::Event::DND

=cut

BOOT:
	gperl_set_isa ("Gtk2::Gdk::Event::DND", "Gtk2::Gdk::Event");

 #/* Event types for DND */

 #struct _GdkEventDND {
 #//  GdkEventType type;  <- GdkEventAny
 #//  GdkWindow *window;  <- GdkEventAny
 #//  gint8 send_event;  <- GdkEventAny
 #  GdkDragContext *context;

 #//  guint32 time;  <- gdk_event_get_time
 #//  gshort x_root, y_root; <- get_root_coords
 #};

GdkDragContext *
context (GdkEvent * eventdnd, GdkDragContext * newvalue=NULL)
    CODE:
	RETVAL = eventdnd->dnd.context;
	if (items == 2 && newvalue != eventdnd->dnd.context)
	{
		if (eventdnd->dnd.context)
			g_object_unref (eventdnd->dnd.context);
		if (newvalue)
		{
			eventdnd->dnd.context = newvalue;
			g_object_ref (newvalue);
		}
		else
			eventdnd->dnd.context = NULL;
	}
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
