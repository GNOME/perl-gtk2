/*
 * Copyright (c) 2003-2006 by the gtk2-perl team (see the file AUTHORS)
 *
 * Licensed under the LGPL, see LICENSE file for more information.
 *
 * $Header$
 */
#include "gtk2perl.h"

static void
_INSTALL_OVERRIDES (const char * package)
{
    GType gtype;
    guint signal_id;

    gtype = gperl_object_type_from_package (package);
    if (!gtype)
        croak ("package '%s' is not registered with Gtk2-Perl",
                package);
    if (! g_type_is_a (gtype, GTK_TYPE_WIDGET))
        croak ("%s(%s) is not a GtkWidget",
                package, g_type_name (gtype));

    /*
     * GtkWidgets may implement "native scrolling".  Such widgets can
     * be told to use scroll adjustments with the method
     * gtk_widget_set_scroll_adjustments(), which emits the signal whose
     * id is stored in GtkWidgetClass::set_scroll_adjustments_signal.
     * Since we have limited support for class-init, we'll add the
     * somewhat sensible restriction that the signal named
     * "set-scroll-adjustments" is for that purpose.
     */
    signal_id = g_signal_lookup ("set-scroll-adjustments", gtype);
    if (signal_id) {
        GSignalQuery query;

        /* verify that the signal is valid for this purpose. */
        g_signal_query (signal_id, &query);

        /* Note: we are interested iff the signal is defined by the
         * exact type we're initializing.  Do NOT do this for inherited
         * signals. */
        if (query.itype == gtype) {
            if (query.return_type == G_TYPE_NONE &&
                    query.n_params == 2 &&
                    g_type_is_a (query.param_types[0], GTK_TYPE_ADJUSTMENT) &&
                    g_type_is_a (query.param_types[1], GTK_TYPE_ADJUSTMENT)) {
                GtkWidgetClass * class;

                class = g_type_class_peek (gtype);
                g_assert (class);

                class->set_scroll_adjustments_signal = signal_id;
            } else {
                warn ("Signal %s on %s is an invalid set-scroll-"
                        "adjustments signal.  A set-scroll-adjustments "
                        "signal must have no return type and take "
                        "exactly two Gtk2::Adjustment parameters.  "
                        "Ignoring", query.signal_name, package);
            }
        }
    }
}



MODULE = Gtk2::Widget	PACKAGE = Gtk2::Requisition

gint
width (requisition, newval=NULL)
	GtkRequisition * requisition
	SV * newval
    ALIAS:
	height = 1
    CODE:
	switch (ix) {
		case 0:
			RETVAL = requisition->width;
			if (newval) requisition->width = SvIV (newval);
			break;
		case 1:
			RETVAL = requisition->height;
			if (newval) requisition->height = SvIV (newval);
			break;
		default:
			RETVAL = 0;
			g_assert_not_reached ();
	}
    OUTPUT:
	RETVAL

GtkRequisition_copy *
new (class, width=0, height=0)
	gint width
	gint height
    PREINIT:
	GtkRequisition req;
    CODE:
	req.width = width;
	req.height = height;
	RETVAL = &req;
    OUTPUT:
	RETVAL


MODULE = Gtk2::Widget	PACKAGE = Gtk2::Widget	PREFIX = gtk_widget_

=for apidoc __hide__
=cut
void
_INSTALL_OVERRIDES (const char * package)


 ## access to important struct members:

 ## must allow ornull for people who call ->window before the widget
 ## is realized.  the ref/unref stunt is necessary to make sure RETVAL doesn't
 ## get mangled.
GdkWindow_ornull *
window (widget, new=NULL)
	GtkWidget * widget
	GdkWindow_ornull * new
    CODE:
	RETVAL = widget->window;
	if (RETVAL)
		g_object_ref (widget->window);

	if (items == 2 && new != widget->window) {
		if (widget->window)
			g_object_unref (widget->window);
		if (new)
			g_object_ref (new);
		widget->window = new;
	}
    OUTPUT:
	RETVAL
    CLEANUP:
	if (RETVAL) g_object_unref (RETVAL);

GtkRequisition *
requisition (widget)
	GtkWidget * widget
    CODE:
	RETVAL = &(widget->requisition);
    OUTPUT:
	RETVAL

=for apidoc
=for signature allocation = $widget->allocation
Returns I<$widget>'s current allocated size as a read-only rectangle; the
allocated size is not necessarily the same as the requested size.
=cut
GdkRectangle *
allocation (widget)
	GtkWidget * widget
    CODE:
	RETVAL = &(widget->allocation);
    OUTPUT:
	RETVAL

#GtkStyle*  gtk_widget_get_style		(GtkWidget	*widget);
GtkStyle*
style (widget)
	GtkWidget * widget
    ALIAS:
	Gtk2::Widget::get_style = 1
    CODE:
	PERL_UNUSED_VAR (ix);
	RETVAL = gtk_widget_get_style(widget);
    OUTPUT:
	RETVAL

 ## and now, the exported API from the header

 ##define GTK_WIDGET_TYPE(wid)		  (GTK_OBJECT_TYPE (wid))
 ##define GTK_WIDGET_STATE(wid)		  (GTK_WIDGET (wid)->state)
 ##define GTK_WIDGET_SAVED_STATE(wid)	  (GTK_WIDGET (wid)->saved_state)
GtkStateType
state (widget)
	GtkWidget * widget
    ALIAS:
	Gtk2::Widget::saved_state = 1
    CODE:
	switch (ix) {
	    case 0: RETVAL = GTK_WIDGET_STATE (widget);       break;
	    case 1: RETVAL = GTK_WIDGET_SAVED_STATE (widget); break;
	    default: RETVAL = 0; g_assert_not_reached ();
	}
    OUTPUT:
	RETVAL

 ##define GTK_WIDGET_FLAGS(wid)		  (GTK_OBJECT_FLAGS (wid))

=for apidoc Gtk2::Widget::toplevel
=for signature $widget->toplevel ($value)
=for signature boolean = $widget->toplevel
=for arg ... (__hide__)
=cut

=for apidoc Gtk2::Widget::no_window
=for signature $widget->no_window ($boolean)
=for signature boolean = $widget->no_window
=for arg ... (__hide__)
=cut

=for apidoc Gtk2::Widget::realized
=for signature $widget->realized ($boolean)
=for signature boolean = $widget->realized
=for arg ... (__hide__)
=cut

=for apidoc Gtk2::Widget::mapped
=for signature $widget->mapped ($boolean)
=for signature boolean = $widget->mapped
=for arg ... (__hide__)
=cut

=for apidoc Gtk2::Widget::visible
=for signature $widget->visible ($boolean)
=for signature boolean = $widget->visible
=for arg ... (__hide__)
=cut

=for apidoc Gtk2::Widget::drawable
=for signature $widget->drawable ($boolean)
=for signature boolean = $widget->drawable
=for arg ... (__hide__)
=cut

=for apidoc Gtk2::Widget::sensitive
=for signature $widget->sensitive ($boolean)
=for signature boolean = $widget->sensitive
=for arg ... (__hide__)
=cut

=for apidoc Gtk2::Widget::parent_sensitive
=for signature $widget->parent_sensitive ($boolean)
=for signature boolean = $widget->parent_sensitive
=for arg ... (__hide__)
=cut

=for apidoc Gtk2::Widget::is_sensitive
=for signature $widget->is_sensitive ($boolean)
=for signature boolean = $widget->is_sensitive
=for arg ... (__hide__)
=cut

=for apidoc Gtk2::Widget::can_focus
=for signature $widget->can_focus ($boolean)
=for signature boolean = $widget->can_focus
=for arg ... (__hide__)
=cut

=for apidoc Gtk2::Widget::has_focus
=for signature $widget->has_focus ($boolean)
=for signature boolean = $widget->has_focus
=for arg ... (__hide__)
=cut

=for apidoc Gtk2::Widget::has_grab
=for signature $widget->has_grab ($boolean)
=for signature boolean = $widget->has_grab
=for arg ... (__hide__)
=cut

=for apidoc Gtk2::Widget::rc_style
=for signature $widget->rc_style ($boolean)
=for signature boolean = $widget->rc_style
=for arg ... (__hide__)
=cut

=for apidoc Gtk2::Widget::composite_child
=for signature $widget->composite_child ($boolean)
=for signature boolean = $widget->composite_child
=for arg ... (__hide__)
=cut

=for apidoc Gtk2::Widget::app_paintable
=for signature $widget->app_paintable ($boolean)
=for signature boolean = $widget->app_paintable
=for arg ... (__hide__)
=cut

=for apidoc Gtk2::Widget::receives_default
=for signature $widget->receives_default ($boolean)
=for signature boolean = $widget->receives_default
=for arg ... (__hide__)
=cut

=for apidoc Gtk2::Widget::double_buffered
=for signature $widget->double_buffered ($boolean)
=for signature boolean = $widget->double_buffered
=for arg ... (__hide__)
=cut

=for apidoc Gtk2::Widget::can_default
=for signature $widget->can_default ($boolean)
=for signature boolean = $widget->can_default
=for arg ... (__hide__)
=cut

=for apidoc Gtk2::Widget::has_default
=for signature $widget->has_default ($boolean)
=for signature boolean = $widget->has_default
=for arg ... (__hide__)
=cut

gboolean
toplevel (widget, ...)
	GtkWidget * widget
    ALIAS:
	Gtk2::Widget::no_window        =  1
	Gtk2::Widget::realized         =  2
	Gtk2::Widget::mapped           =  3
	Gtk2::Widget::visible          =  4
	Gtk2::Widget::drawable         =  5
	Gtk2::Widget::sensitive        =  6
	Gtk2::Widget::parent_sensitive =  7
	Gtk2::Widget::is_sensitive     =  8
	Gtk2::Widget::can_focus        =  9
	Gtk2::Widget::has_focus        = 10
	Gtk2::Widget::has_grab         = 11
	Gtk2::Widget::rc_style         = 12
	Gtk2::Widget::composite_child  = 13
	Gtk2::Widget::app_paintable    = 14
	Gtk2::Widget::receives_default = 15
	Gtk2::Widget::double_buffered  = 16
	Gtk2::Widget::can_default      = 17
	Gtk2::Widget::has_default      = 18
    PREINIT:
	gboolean value = FALSE;
	GtkWidgetFlags flag = 0;
    CODE:
	if (items > 2) {
		croak ("Usage: boolean = $widget->%s\n"
		       "       $widget->%s (newvalue)\n"
		       "   too many arguments",
		       GvNAME (CvGV (cv)), GvNAME (CvGV (cv)));
	}

        if ( items == 1 ) {
	    switch (ix) {
		case  0: RETVAL = GTK_WIDGET_TOPLEVEL         (widget); break;
		case  1: RETVAL = GTK_WIDGET_NO_WINDOW        (widget); break;
		case  2: RETVAL = GTK_WIDGET_REALIZED         (widget); break;
		case  3: RETVAL = GTK_WIDGET_MAPPED           (widget); break;
		case  4: RETVAL = GTK_WIDGET_VISIBLE          (widget); break;
		case  5: RETVAL = GTK_WIDGET_DRAWABLE         (widget); break;
		case  6: RETVAL = GTK_WIDGET_SENSITIVE        (widget); break;
		case  7: RETVAL = GTK_WIDGET_PARENT_SENSITIVE (widget); break;
		case  8: RETVAL = GTK_WIDGET_IS_SENSITIVE     (widget); break;
		case  9: RETVAL = GTK_WIDGET_CAN_FOCUS        (widget); break;
		case 10: RETVAL = GTK_WIDGET_HAS_FOCUS        (widget); break;
		case 11: RETVAL = GTK_WIDGET_HAS_GRAB         (widget); break;
		case 12: RETVAL = GTK_WIDGET_RC_STYLE         (widget); break;
		case 13: RETVAL = GTK_WIDGET_COMPOSITE_CHILD  (widget); break;
		case 14: RETVAL = GTK_WIDGET_APP_PAINTABLE    (widget); break;
		case 15: RETVAL = GTK_WIDGET_RECEIVES_DEFAULT (widget); break;
		case 16: RETVAL = GTK_WIDGET_DOUBLE_BUFFERED  (widget); break;
		case 17: RETVAL = GTK_WIDGET_CAN_DEFAULT      (widget); break;
		case 18: RETVAL = GTK_WIDGET_HAS_DEFAULT      (widget); break;
		default:
			RETVAL = FALSE;
			g_assert_not_reached ();
	    }
	} else {
	    value = (gboolean) SvIV(ST(1));
	    switch (ix) {
		case  0: flag = GTK_TOPLEVEL	     ; break;
		case  1: flag = GTK_NO_WINDOW	     ; break;
		case  2: flag = GTK_REALIZED	     ; break;
		case  3: flag = GTK_MAPPED	     ; break;
		case  4: flag = GTK_VISIBLE	     ; break;
		case  5: croak ("widget flag drawable is read only"); break;
		case  6: flag = GTK_SENSITIVE	     ; break;
		case  7: flag = GTK_PARENT_SENSITIVE ; break;
		case  8: croak ("widget flag is_sensitive is read only"); break;
		case  9: flag = GTK_CAN_FOCUS	     ; break;
		case 10: flag = GTK_HAS_FOCUS	     ; break;
		case 11: flag = GTK_HAS_GRAB	     ; break;
		case 12: flag = GTK_RC_STYLE	     ; break;
		case 13: flag = GTK_COMPOSITE_CHILD  ; break;
		case 14: flag = GTK_APP_PAINTABLE    ; break;
		case 15: flag = GTK_RECEIVES_DEFAULT ; break;
		case 16: flag = GTK_DOUBLE_BUFFERED  ; break;
		case 17: flag = GTK_CAN_DEFAULT      ; break;
		case 18: flag = GTK_HAS_DEFAULT      ; break;
		default:
			flag = FALSE;
			g_assert_not_reached ();
	    }
	    if ( value ) {
	    	GTK_WIDGET_SET_FLAGS(widget, flag);
	    } else {
	    	GTK_WIDGET_UNSET_FLAGS(widget, flag);
	    }
	    RETVAL=value;
	}

    OUTPUT:
	RETVAL

GtkWidgetFlags
flags (GtkWidget * widget)
    ALIAS:
	get_flags = 1
    CODE:
	PERL_UNUSED_VAR (ix);
	RETVAL = GTK_WIDGET_FLAGS (widget);
    OUTPUT:
	RETVAL

 #
 #/* Macros for setting and clearing widget flags.
 # */
 ##define GTK_WIDGET_SET_FLAGS(wid,flag)	  G_STMT_START{ (GTK_WIDGET_FLAGS (wid) |= (flag)); }G_STMT_END
 ##define GTK_WIDGET_UNSET_FLAGS(wid,flag)  G_STMT_START{ (GTK_WIDGET_FLAGS (wid) &= ~(flag)); }G_STMT_END

void
set_flags (widget, flags)
	GtkWidget * widget
	GtkWidgetFlags flags
    CODE:
	GTK_WIDGET_SET_FLAGS (widget, flags);

void
unset_flags (widget, flags)
	GtkWidget * widget
	GtkWidgetFlags flags
    CODE:
	GTK_WIDGET_UNSET_FLAGS (widget, flags);

 #/* A requisition is a desired amount of space which a
 # *  widget may request.
 # */
 #struct _GtkRequisition
 #{
 #  gint width;
 #  gint height;
 #};
 #
 #
 #struct _GtkWidgetShapeInfo
 #{
 #  gint16     offset_x;
 #  gint16     offset_y;
 #  GdkBitmap *shape_mask;
 #};
 #
 #GtkWidget* gtk_widget_new		  (GtkType		type,
 #					   const gchar	       *first_property_name,
 #					   ...);

 ## should use g_object_ref and g_object_unref instead, so we do
 #GtkWidget* gtk_widget_ref		  (GtkWidget	       *widget);
 #void	   gtk_widget_unref		  (GtkWidget	       *widget);


 #void	   gtk_widget_destroyed		  (GtkWidget	       *widget,
 #					   GtkWidget	      **widget_pointer);

##
## by consolidating all of the various xsubs with the signature
##    void $widget->method(void)
## into one aliased xsub, i managed to cut a couple of kilobytes from the
## resultant stripped i686 object file.
##
void
destroy (GtkWidget * widget)
    ALIAS:
	unparent  = 1
	show      = 2
	show_now  = 3
	hide      = 4
	show_all  = 5
	hide_all  = 6
	map       = 7
	unmap     = 8
	realize   = 9
	unrealize = 10
	grab_focus   = 11
	grab_default = 12
	reset_shapes = 13
	queue_draw   = 14
	queue_resize = 15
	freeze_child_notify = 16
	thaw_child_notify   = 17
    CODE:
	switch (ix) {
		case  0: gtk_widget_destroy   (widget); break;
		case  1: gtk_widget_unparent  (widget); break;
		case  2: gtk_widget_show      (widget); break;
		case  3: gtk_widget_show_now  (widget); break;
		case  4: gtk_widget_hide      (widget); break;
		case  5: gtk_widget_show_all  (widget); break;
		case  6: gtk_widget_hide_all  (widget); break;
		case  7: gtk_widget_map       (widget); break;
		case  8: gtk_widget_unmap     (widget); break;
		case  9: gtk_widget_realize   (widget); break;
		case 10: gtk_widget_unrealize (widget); break;
		case 11: gtk_widget_grab_focus   (widget); break;
		case 12: gtk_widget_grab_default (widget); break;
		case 13: gtk_widget_reset_shapes (widget); break;
		case 14: gtk_widget_queue_draw   (widget); break;
		case 15: gtk_widget_queue_resize (widget); break;
		case 16: gtk_widget_freeze_child_notify (widget); break;
		case 17: gtk_widget_thaw_child_notify   (widget); break;
		default:
			 g_assert_not_reached ();
	}

void
gtk_widget_queue_draw_area (widget, x, y, width, height)
	GtkWidget * widget
	gint x
	gint y
	gint width
	gint height

GtkRequisition_copy *
gtk_widget_size_request (widget)
	GtkWidget * widget
    PREINIT:
	GtkRequisition req;
    CODE:
	gtk_widget_size_request (widget, &req);
	RETVAL = &req;
    OUTPUT:
	RETVAL


##void gtk_widget_size_allocate (GtkWidget * widget, GtkAllocation * allocation);
void
gtk_widget_size_allocate (widget, allocation)
	GtkWidget * widget
	GdkRectangle * allocation

## function is only useful for widget implementations
##void gtk_widget_get_child_requisition (GtkWidget *widget, GtkRequisition *requisition);
GtkRequisition_copy*
gtk_widget_get_child_requisition (GtkWidget * widget)
    PREINIT:
	GtkRequisition req;
    CODE:
	gtk_widget_get_child_requisition (widget, &req);
	RETVAL = &req;
    OUTPUT:
	RETVAL

void
gtk_widget_add_accelerator (widget, accel_signal, accel_group, accel_key, accel_mods, flags)
	GtkWidget       * widget
	const gchar     * accel_signal
	GtkAccelGroup   * accel_group
	guint             accel_key
	GdkModifierType   accel_mods
	GtkAccelFlags     flags

gboolean
gtk_widget_remove_accelerator (widget, accel_group, accel_key, accel_mods)
	GtkWidget       * widget
	GtkAccelGroup   * accel_group
	guint             accel_key
	GdkModifierType   accel_mods

void
gtk_widget_set_accel_path (widget, accel_path, accel_group)
	GtkWidget     * widget
	const gchar   * accel_path
	GtkAccelGroup * accel_group

 #GList*     gtk_widget_list_accel_closures (GtkWidget	       *widget);

gboolean
gtk_widget_mnemonic_activate   (widget, group_cycling)
	GtkWidget * widget
	gboolean    group_cycling

 # gtk docs say rarely used, suggest other ways
=for apidoc
This rarely-used function emits an event signal on I<$widget>.  Don't use
this to synthesize events; use C<< Gtk2->main_do_event >> instead.  Don't
synthesize expose events; use C<< $gdkwindow->invalidate_rect >> instead.
Basically, the main use for this in gtk2-perl will be to pass motion
notify events to rulers from other widgets.
=cut
gboolean gtk_widget_event (GtkWidget * widget, GdkEvent	*event);

 # gtk docs say rarely used, suggest other ways
 #gint       gtk_widget_send_expose         (GtkWidget           *widget,
 #					   GdkEvent            *event);

gboolean
gtk_widget_activate (widget)
	GtkWidget * widget

gboolean
gtk_widget_set_scroll_adjustments (widget, hadjustment, vadjustment)
	GtkWidget     * widget
	GtkAdjustment_ornull * hadjustment
	GtkAdjustment_ornull * vadjustment

void
gtk_widget_reparent (widget, new_parent)
	GtkWidget * widget
	GtkWidget * new_parent

=for apidoc
Returns undef if I<$widget> and I<$area> do not intersect.
=cut
GdkRectangle_copy *
gtk_widget_intersect (widget, area)
	GtkWidget    * widget
	GdkRectangle * area
    PREINIT:
	GdkRectangle intersection;
    CODE:
	if (!gtk_widget_intersect (widget, area, &intersection))
		XSRETURN_UNDEF;
	RETVAL = &intersection;
    OUTPUT:
	RETVAL

GdkRegion * gtk_widget_region_intersect (GtkWidget * widget, GdkRegion * region)

void gtk_widget_child_notify (GtkWidget	*widget, const gchar *child_property);

gboolean gtk_widget_is_focus (GtkWidget *widget);

void
gtk_widget_set_name (widget, name)
	GtkWidget    *widget
	const gchar  *name

const gchar*
gtk_widget_get_name (widget)
	GtkWidget    *widget

 # gtk doc says only used for widget implementations
void 
gtk_widget_set_state (GtkWidget * widget, GtkStateType state);

void
gtk_widget_set_sensitive (widget, sensitive)
	GtkWidget * widget
	gboolean sensitive

void gtk_widget_set_app_paintable (GtkWidget *widget, gboolean app_paintable);

void gtk_widget_set_double_buffered (GtkWidget *widget, gboolean double_buffered);

void gtk_widget_set_redraw_on_allocate (GtkWidget *widget, gboolean redraw_on_allocate);

void 
gtk_widget_set_parent (GtkWidget *widget, GtkWidget *parent);

void 
gtk_widget_set_parent_window (GtkWidget *widget, GdkWindow *parent_window);

void 
gtk_widget_set_child_visible (GtkWidget *widget, gboolean is_visible);

gboolean 
gtk_widget_get_child_visible (GtkWidget *widget);


 ## must allow NULL on return, in case somebody calls this on
 ## an unparented widget

GtkWidget_ornull *
gtk_widget_get_parent (widget)
	GtkWidget * widget
    ALIAS:
	Gtk2::Widget::parent = 1
    CLEANUP:
	PERL_UNUSED_VAR (ix);

GdkWindow *gtk_widget_get_parent_window	  (GtkWidget	       *widget);

gboolean gtk_widget_child_focus (GtkWidget *widget, GtkDirectionType direction);

void
gtk_widget_set_size_request (widget, width=-1, height=-1)
	GtkWidget * widget
	gint width
	gint height

=for apidoc
This function is typically used when implementing a GtkContainer subclass.
Obtains the preferred size of a widget. The container uses this information to
arrange its child widgets and decide what size allocations to give them with
size_allocate ().

You can also call this function from an application, with some caveats. Most
notably, getting a size request requires the widget to be associated with a
screen, because font information may be needed. Multihead-aware applications
should keep this in mind.

Also remember that the size request is not necessarily the size a widget will
actually be allocated.

See also L<get_child_requisition ()|requisistion = $widget-E<gt>get_child_requisition>
=cut
void
gtk_widget_get_size_request (widget)
	GtkWidget * widget
    PREINIT:
	gint width, height;
    PPCODE:
	gtk_widget_get_size_request (widget, &width, &height);
	XPUSHs (sv_2mortal (newSViv (width)));
	XPUSHs (sv_2mortal (newSViv (height)));

void
gtk_widget_set_events (widget, events)
	GtkWidget	       *widget
	GdkEventMask            events
 ###	gint			events

void
gtk_widget_add_events          (widget, events)
	GtkWidget           *widget
	GdkEventMask         events

void
gtk_widget_set_extension_events (widget, mode)
	GtkWidget		*widget
	GdkExtensionMode	mode

GdkExtensionMode
gtk_widget_get_extension_events (widget)
	GtkWidget	*widget

## allow NULL for those crazy folks who call get_toplevel before a
## widget has been added to a container
GtkWidget_ornull *
gtk_widget_get_toplevel	(widget)
	GtkWidget * widget

# useful for grabbing the box which contains you
 #GtkWidget* gtk_widget_get_ancestor (GtkWidget *widget, GtkType widget_type);
GtkWidget_ornull*
gtk_widget_get_ancestor (widget, ancestor_package)
	GtkWidget *widget
	const char * ancestor_package
    PREINIT:
	GtkType widget_type;
    CODE:
	widget_type = gperl_object_type_from_package (ancestor_package);
	if (!widget_type)
		croak ("package %s is not registered to a GType",
		       ancestor_package);
	RETVAL = gtk_widget_get_ancestor (widget, widget_type);
    OUTPUT:
	RETVAL

GdkColormap*
gtk_widget_get_colormap	(widget)
	GtkWidget * widget

GdkVisual * gtk_widget_get_visual (GtkWidget * widget);

GtkSettings * gtk_widget_get_settings (GtkWidget * widget);

#/* Accessibility support */
AtkObject * gtk_widget_get_accessible (GtkWidget * widget);

 #/* The following functions must not be called on an already
 # * realized widget. Because it is possible that somebody
 # * can call get_colormap() or get_visual() and save the
 # * result, these functions are probably only safe to
 # * call in a widget's init() function.
 # */
void gtk_widget_set_colormap (GtkWidget * widget, GdkColormap * colormap);

 #gint	     gtk_widget_get_events	(GtkWidget	*widget);
GdkEventMask
gtk_widget_get_events (widget)
	GtkWidget	*widget

 #void gtk_widget_get_pointer (GtkWidget *widget, gint *x, gint *y);
void
gtk_widget_get_pointer (GtkWidget *widget, OUTLIST gint x, OUTLIST gint y);

gboolean gtk_widget_is_ancestor (GtkWidget *widget, GtkWidget *ancestor);

 #gboolean gtk_widget_translate_coordinates (GtkWidget *src_widget, GtkWidget *dest_widget, gint src_x, gint src_y, gint *dest_x, gint *dest_y);
=for apidoc
=for signature (dst_x, dst_y) = $src_widget->translate_coordinates ($dest_widget, $src_x, $src_y)
Returns an empty list if either widget is not realized or if they do not share
a common ancestor.
=cut
void
gtk_widget_translate_coordinates (GtkWidget *src_widget, GtkWidget *dest_widget, gint src_x, gint src_y)
    PREINIT:
	gint dest_x, dest_y;
    PPCODE:
	if (!gtk_widget_translate_coordinates (src_widget, dest_widget,
	                                     src_x, src_y, &dest_x, &dest_y))
		XSRETURN_EMPTY;
	EXTEND (SP, 2);
	PUSHs (sv_2mortal (newSViv (dest_x)));
	PUSHs (sv_2mortal (newSViv (dest_y)));


 # Hide widget and return TRUE.
 # intended for passing directly to g_signal_connect for handling
 # the delete event.  pointless in perl.
 #gboolean     gtk_widget_hide_on_delete	(GtkWidget	*widget);


 #/* Widget styles.
 # */

void gtk_widget_set_style (GtkWidget *widget, GtkStyle_ornull *style);

void gtk_widget_ensure_style (GtkWidget *widget);

void gtk_widget_modify_style (GtkWidget *widget, GtkRcStyle *style);

GtkRcStyle * gtk_widget_get_modifier_style (GtkWidget * widget);

void gtk_widget_modify_fg (GtkWidget * widget, GtkStateType state, GdkColor_ornull * color);

void gtk_widget_modify_bg (GtkWidget * widget, GtkStateType state, GdkColor_ornull * color);

void gtk_widget_modify_text (GtkWidget * widget, GtkStateType state, GdkColor_ornull * color);

void gtk_widget_modify_base (GtkWidget * widget, GtkStateType state, GdkColor_ornull * color);

void gtk_widget_modify_font (GtkWidget *widget, PangoFontDescription_ornull *font_desc)


 #PangoContext *gtk_widget_create_pango_context (GtkWidget   *widget);
PangoContext_noinc *
gtk_widget_create_pango_context (GtkWidget *widget)

 #PangoContext *gtk_widget_get_pango_context    (GtkWidget   *widget);
PangoContext *
gtk_widget_get_pango_context (GtkWidget *widget)

PangoLayout_noinc *
gtk_widget_create_pango_layout (widget, text)
	GtkWidget   * widget
        const gchar *text

 ### may return NULL if stockid isn't known.... but then, it will
 ### croak on converting unknown stock ids, too.
GdkPixbuf_noinc *
gtk_widget_render_icon (widget, stock_id, size, detail=NULL)
	GtkWidget   * widget
	const gchar * stock_id
	GtkIconSize   size
	const gchar * detail

 #/* handle composite names for GTK_COMPOSITE_CHILD widgets,
 # * the returned name is newly allocated.
 # */

void gtk_widget_set_composite_name (GtkWidget *widget, const gchar *name)

gchar* gtk_widget_get_composite_name (GtkWidget *widget)
 
#/* Descend recursively and set rc-style on all widgets without user styles */
void gtk_widget_reset_rc_styles (GtkWidget *widget)
 
=for apidoc
=for signature Gtk2::Widget->push_colormap (cmap)
=for signature $widget->push_colormap (cmap)
=cut
void gtk_widget_push_colormap (class_or_widget, GdkColormap *cmap)
    C_ARGS: cmap

=for apidoc
=for signature Gtk2::Widget->pop_colormap (cmap)
=for signature $widget->pop_colormap (cmap)
=cut
void gtk_widget_pop_colormap (class_or_widget)
    C_ARGS: /* void */

=for apidoc
=for signature Gtk2::Widget->push_composite_child
=for signature $widget->push_composite_child
=cut
void gtk_widget_push_composite_child (class_or_widget=NULL)
    C_ARGS: /* void */

=for apidoc
=for signature Gtk2::Widget->pop_composite_child
=for signature $widget->pop_composite_child
=cut
void gtk_widget_pop_composite_child (class_or_widget=NULL)
    C_ARGS: /* void */

# bunch of FIXMEs: widget class style properties
#
#void gtk_widget_class_install_style_property        (GtkWidgetClass     *klass,
#						     GParamSpec         *pspec);
#void gtk_widget_class_install_style_property_parser (GtkWidgetClass     *klass,
#						     GParamSpec         *pspec,
#						     GtkRcPropertyParser parser);

### gtk_widget_class_find_style_property isn't available until 2.2.0, so we
### can't implement gtk_widget_style_get and friends until 2.2.0, because
### we have to be able to query the property's pspec to know what type of
### GValue to send it.

#if GTK_CHECK_VERSION(2,2,0)

#void gtk_widget_style_get_property (GtkWidget *widget, const gchar *property_name, GValue *value);
#void gtk_widget_style_get_valist (GtkWidget *widget, const gchar *first_property_name, va_list var_args);
#void gtk_widget_style_get (GtkWidget *widget, const gchar *first_property_name, ...);

=for apidoc style_get_property
=for arg first_property_name (string)
=for arg ... 0 or more additional property names
An alias for style_get.
=cut
=for apidoc
=for arg first_property_name (string)
=for arg ... 0 or more additional property names
Returns the values of the requested style properties.
=cut
void
style_get (GtkWidget * widget, first_property_name, ...)
    ALIAS:
	style_get_property = 1
    PREINIT:
	int i;
    PPCODE:
	PERL_UNUSED_VAR (ix);
	EXTEND (SP, items - 1);
	for (i = 1 ; i < items ; i++) {
		GValue value = {0, };
		gchar * name = SvGChar (ST (i));
		GParamSpec * pspec;
		pspec = gtk_widget_class_find_style_property
		                         (GTK_WIDGET_GET_CLASS (widget), name);
		if (pspec) {
			g_value_init (&value, G_PARAM_SPEC_VALUE_TYPE (pspec));
			gtk_widget_style_get_property (widget, name, &value);
			PUSHs (sv_2mortal (gperl_sv_from_value (&value)));
			g_value_unset (&value);
		} else {
			warn ("Invalid property `%s' used", name);
		}
	}

#endif


 #/* Set certain default values to be used at widget creation time.
 # */

=for apidoc
=for signature Gtk2::Widget->set_default_colormap ($colormap)
=for signature $widget->set_default_colormap ($colormap)
=cut
void gtk_widget_set_default_colormap (class_or_widget, GdkColormap *colormap);
    C_ARGS: colormap

=for apidoc
=for signature style = Gtk2::Widget->get_default_style
=for signature style = $widget->get_default_style
=cut
GtkStyle*
gtk_widget_get_default_style (class_or_widget)
    C_ARGS: /* void */

=for apidoc
=for signature colormap = Gtk2::Widget->get_default_colormap
=for signature colormap = $widget->get_default_colormap
=cut
GdkColormap* gtk_widget_get_default_colormap (class_or_widget)
    C_ARGS: /* void */

=for apidoc
=for signature visual = Gtk2::Widget->get_default_visual
=for signature visual = $widget->get_default_visual
=cut
GdkVisual* gtk_widget_get_default_visual (class_or_widget)
    C_ARGS: /* void */

 #
 #/* Functions for setting directionality for widgets
 # */

void
gtk_widget_set_direction (GtkWidget *widget, GtkTextDirection  dir);

GtkTextDirection
gtk_widget_get_direction (GtkWidget *widget);

void
gtk_widget_set_default_direction (class, dir);
	GtkTextDirection   dir
    C_ARGS:
    	dir

GtkTextDirection
gtk_widget_get_default_direction (class);
    C_ARGS:
	/* void */

 #/* Counterpart to gdk_window_shape_combine_mask.
 # */
void gtk_widget_shape_combine_mask (GtkWidget *widget, GdkBitmap *shape_mask, gint offset_x, gint offset_y);




 # void gtk_widget_path (GtkWidget *widget, guint *path_length, gchar **path, gchar **path_reversed);
 # void gtk_widget_class_path (GtkWidget *widget, guint *path_length, gchar **path, gchar **path_reversed);
 ## both changed to ($path, $path_reversed) = $widget->(path|class_path);
 ## returns the path_reversed straight from C, no matter how nonsensical...
=for apidoc Gtk2::Widget::path
=for signature (path, path_reversed) = $widget->path
=cut

=for apidoc class_path
=for signature (path, path_reversed) = $widget->class_path
=cut

void
gtk_widget_path (GtkWidget *widget)
    ALIAS:
	class_path = 1
    PREINIT:
	gchar *path = NULL, *path_reversed = NULL;
    PPCODE:
	if (ix == 1)
		gtk_widget_class_path (widget, NULL, &path, &path_reversed);
	else
		gtk_widget_path (widget, NULL, &path, &path_reversed);
	EXTEND (SP, 2);
	PUSHs (sv_2mortal (newSVGChar (path)));
	PUSHs (sv_2mortal (newSVGChar (path_reversed)));
	g_free (path);
	g_free (path_reversed);


 # boxed support, bindings not needed
 #GtkRequisition *gtk_requisition_copy     (const GtkRequisition *requisition);
 #void            gtk_requisition_free     (GtkRequisition       *requisition);

 # private, will not be bound
 #GdkColormap* _gtk_widget_peek_colormap (void);




#if GTK_CHECK_VERSION(2,2,0)

# GtkWidgetClass not in typemap, should use type_from_package and
# then look up the class
##GParamSpec* gtk_widget_class_find_style_property (GtkWidgetClass *klass, const gchar *property_name)
#GParamSpec *
#gtk_widget_class_find_style_property (klass, property_name)
#	GtkWidgetClass * klass
#	const gchar    * property_name
#
# GtkWidgetClass not in typemap
##GParamSpec** gtk_widget_class_list_style_properties (GtkWidgetClass *klass, guint *n_properties)
#GParamSpec **
#gtk_widget_class_list_style_properties (klass, n_properties)
#	GtkWidgetClass * klass
#	guint          * n_properties


#GtkClipboard* gtk_widget_get_clipboard (GtkWidget *widget, GdkAtom selection)
GtkClipboard *
gtk_widget_get_clipboard (widget, selection=GDK_SELECTION_CLIPBOARD)
	GtkWidget * widget
	GdkAtom     selection


GdkDisplay * gtk_widget_get_display (GtkWidget * widget)

GdkWindow * gtk_widget_get_root_window (GtkWidget * widget)

GdkScreen * gtk_widget_get_screen (GtkWidget * widget)

gboolean gtk_widget_has_screen (GtkWidget * widget);

#endif


#if GTK_CHECK_VERSION(2,4,0)

void gtk_widget_set_no_show_all (GtkWidget *widget, gboolean no_show_all);

gboolean gtk_widget_get_no_show_all (GtkWidget *widget);

void gtk_widget_queue_resize_no_redraw (GtkWidget *widget);

gboolean
gtk_widget_can_activate_accel (widget, signal_id)
	GtkWidget *widget
	guint signal_id

void
gtk_widget_list_mnemonic_labels (widget)
	GtkWidget *widget
    PREINIT:
	GList *i, *list = NULL;
    PPCODE:
	list = gtk_widget_list_mnemonic_labels (widget);
	for (i = list; i != NULL; i = i->next)
		XPUSHs (sv_2mortal (newSVGtkWidget (i->data)));
	g_list_free (list);

void gtk_widget_add_mnemonic_label (GtkWidget *widget, GtkWidget *label);

void gtk_widget_remove_mnemonic_label (GtkWidget *widget, GtkWidget *label);

#endif

#if GTK_CHECK_VERSION(2, 10, 0)

void gtk_widget_input_shape_combine_mask (GtkWidget *widget, GdkBitmap_ornull *shape_mask, gint offset_x, gint offset_y);

#endif /* 2.10 */

#if GTK_CHECK_VERSION(2, 11, 0) /* FIXME: 2.12 */

gboolean gtk_widget_keynav_failed (GtkWidget *widget, GtkDirectionType direction);

void gtk_widget_error_bell (GtkWidget *widget);

void gtk_widget_set_tooltip_window (GtkWidget *widget, GtkWindow_ornull *custom_window);

GtkWindow_ornull *gtk_widget_get_tooltip_window (GtkWidget *widget);

void gtk_widget_trigger_tooltip_query (GtkWidget *widget);

void gtk_widget_set_tooltip_text (GtkWidget *widget, const gchar_ornull *text);

gchar_own * gtk_widget_get_tooltip_text (GtkWidget *widget);

void gtk_widget_set_tooltip_markup (GtkWidget *widget, const gchar_ornull *markup);

gchar_own * gtk_widget_get_tooltip_markup (GtkWidget *widget);

void gtk_widget_modify_cursor (GtkWidget *widget, const GdkColor *primary, const GdkColor *secondary);

void gtk_widget_set_has_tooltip (GtkWidget *widget, gboolean has_tooltip);

gboolean gtk_widget_get_has_tooltip (GtkWidget *widget);

#endif
