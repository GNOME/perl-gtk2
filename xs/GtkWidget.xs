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
#include "ppport.h"

/*
gtkwidget.h typedefs GtkAllocation to be the same as GdkRectangle;
unfortunately, there is no type macro associated with GtkAllocation itself.
on the other hand, it's only used in one or two places, and is used only for
looking at the width and height members, anyway.  so, we treat is specially
here.

since allocations are notoriously read-only, we specify that it's always a
copy.
*/
SV *
newSVGtkAllocation (GtkAllocation * allocation)
{
	SV * sv = gperl_new_boxed_copy (allocation, GDK_TYPE_RECTANGLE);
	return sv_bless (sv, gv_stashpv ("Gtk2::Allocation", TRUE));
}


MODULE = Gtk2::Widget	PACKAGE = Gtk2::Allocation

BOOT:
	gperl_set_isa ("Gtk2::Allocation", "Gtk2::Gdk::Rectangle");

 ## we'll need to destroy this explicitly because of the name mangling.
void
DESTROY (sv)
	SV * sv
    CODE:
	/* warn ("Gtk2::Allocation::DESTROY"); */
	g_boxed_free (GDK_TYPE_RECTANGLE, GUINT_TO_POINTER (SvIV (SvRV (sv))));


MODULE = Gtk2::Widget	PACKAGE = Gtk2::Requisition

gint
width (requisition, newval=NULL)
	GtkRequisition * requisition
	SV * newval
    ALIAS:
	width = 0
	height = 1
    CODE:
	RETVAL = 0;
	switch (ix) {
		case 0:
			RETVAL = requisition->width;
			if (newval) requisition->width = SvIV (newval);
			break;
		case 1:
			RETVAL = requisition->height;
			if (newval) requisition->height = SvIV (newval);
			break;
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

 ## access to important struct members:

 ## must allow ornull for people who call ->window before the widget
 ## is realized
GdkWindow_ornull *
window (widget)
	GtkWidget * widget
    CODE:
	RETVAL = widget->window;
    OUTPUT:
	RETVAL

=for apidoc
=for signature allocation = $widget->allocation
Returns I<$widget>'s current allocated size as a read-only rectangle
(re-blessed as a Gtk2::Allocation); the allocated size is not necessarily
the same as the requested size.
=cut
SV *
allocation (widget)
	GtkWidget * widget
    CODE:
	RETVAL = newSVGtkAllocation (&(widget->allocation));
    OUTPUT:
	RETVAL

#GtkStyle*  gtk_widget_get_style		(GtkWidget	*widget);
GtkStyle*
style (widget)
	GtkWidget * widget
    ALIAS:
	Gtk2::Widget::style = 1
	Gtk2::Widget::get_style = 2
    CODE:
	PERL_UNUSED_VAR (ix);
	RETVAL = gtk_widget_get_style(widget);
    OUTPUT:
	RETVAL

 ## and now, the exported API from the header

 ##define GTK_WIDGET_TYPE(wid)		  (GTK_OBJECT_TYPE (wid))
 ##define GTK_WIDGET_STATE(wid)		  (GTK_WIDGET (wid)->state)
GtkStateType
state (widget)
	GtkWidget * widget
    CODE:
	RETVAL = GTK_WIDGET_STATE (widget);
    OUTPUT:
	RETVAL

 ##define GTK_WIDGET_SAVED_STATE(wid)	  (GTK_WIDGET (wid)->saved_state)


 ##define GTK_WIDGET_FLAGS(wid)		  (GTK_OBJECT_FLAGS (wid))

gboolean
get_flags (widget, ...)
	GtkWidget * widget
    ALIAS:
	Gtk2::Widget::toplevel         =  1
	Gtk2::Widget::no_window        =  2
	Gtk2::Widget::realized         =  3
	Gtk2::Widget::mapped           =  4
	Gtk2::Widget::visible          =  5
	Gtk2::Widget::drawable         =  6
	Gtk2::Widget::sensitive        =  7
	Gtk2::Widget::parent_sensitive =  8
	Gtk2::Widget::is_sensitive     =  9
	Gtk2::Widget::can_focus        = 10
	Gtk2::Widget::has_focus        = 11
	Gtk2::Widget::has_grab         = 12
	Gtk2::Widget::rc_style         = 13
	Gtk2::Widget::composite_child  = 14
	Gtk2::Widget::app_paintable    = 15
	Gtk2::Widget::receives_default = 16
	Gtk2::Widget::double_buffered  = 17
	Gtk2::Widget::can_default      = 18
	Gtk2::Widget::has_default      = 19
    PREINIT:
	gboolean value;
	GtkWidgetFlags flag;
    CODE:
	if ( items > 2 ) {
	    croak ("Usage: flag(widget[, value])");
	    return;
	}

        if ( items == 1 ) {
	    switch (ix) {
		case  1: RETVAL = GTK_WIDGET_TOPLEVEL         (widget); break;
		case  2: RETVAL = GTK_WIDGET_NO_WINDOW        (widget); break;
		case  3: RETVAL = GTK_WIDGET_REALIZED         (widget); break;
		case  4: RETVAL = GTK_WIDGET_MAPPED           (widget); break;
		case  5: RETVAL = GTK_WIDGET_VISIBLE          (widget); break;
		case  6: RETVAL = GTK_WIDGET_DRAWABLE         (widget); break;
		case  7: RETVAL = GTK_WIDGET_SENSITIVE        (widget); break;
		case  8: RETVAL = GTK_WIDGET_PARENT_SENSITIVE (widget); break;
		case  9: RETVAL = GTK_WIDGET_IS_SENSITIVE     (widget); break;
		case 10: RETVAL = GTK_WIDGET_CAN_FOCUS        (widget); break;
		case 11: RETVAL = GTK_WIDGET_HAS_FOCUS        (widget); break;
		case 12: RETVAL = GTK_WIDGET_HAS_GRAB         (widget); break;
		case 13: RETVAL = GTK_WIDGET_RC_STYLE         (widget); break;
		case 14: RETVAL = GTK_WIDGET_COMPOSITE_CHILD  (widget); break;
		case 15: RETVAL = GTK_WIDGET_APP_PAINTABLE    (widget); break;
		case 16: RETVAL = GTK_WIDGET_RECEIVES_DEFAULT (widget); break;
		case 17: RETVAL = GTK_WIDGET_DOUBLE_BUFFERED  (widget); break;
		case 18: RETVAL = GTK_WIDGET_CAN_DEFAULT      (widget); break;
		case 19: RETVAL = GTK_WIDGET_HAS_DEFAULT      (widget); break;
		default: croak ("unhandled case (%s) in get_flags - shouldn't happen", ix);
	    }
	} else {
	    value = (gboolean) SvIV(ST(1));
	    switch (ix) {
		case  1: flag = GTK_TOPLEVEL	     ; break;
		case  2: flag = GTK_NO_WINDOW	     ; break;
		case  3: flag = GTK_REALIZED	     ; break;
		case  4: flag = GTK_MAPPED	     ; break;
		case  5: flag = GTK_VISIBLE	     ; break;
		case  6: croak ("widget flag drawable is read only"); break;
		case  7: flag = GTK_SENSITIVE	     ; break;
		case  8: flag = GTK_PARENT_SENSITIVE ; break;
		case  9: croak ("widget flag is_sensitive is read only"); break;
		case 10: flag = GTK_CAN_FOCUS	     ; break;
		case 11: flag = GTK_HAS_FOCUS	     ; break;
		case 12: flag = GTK_HAS_GRAB	     ; break;
		case 13: flag = GTK_RC_STYLE	     ; break;
		case 14: flag = GTK_COMPOSITE_CHILD  ; break;
		case 15: flag = GTK_APP_PAINTABLE    ; break;
		case 16: flag = GTK_RECEIVES_DEFAULT ; break;
		case 17: flag = GTK_DOUBLE_BUFFERED  ; break;
		case 18: flag = GTK_CAN_DEFAULT      ; break;
		case 19: flag = GTK_HAS_DEFAULT      ; break;
		default: croak ("unhandled case (%s) in set_flags - shouldn't happen", ix);
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
void_methods (GtkWidget * widget)
    ALIAS:
	destroy   = 0
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

## GtkAllocation is not in typemap
##void gtk_widget_size_allocate (GtkWidget * widget, GtkAllocation * allocation);

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
	GtkAdjustment * hadjustment
	GtkAdjustment * vadjustment

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

# FIXME needs typemap for GdkRegion
 #GdkRegion *gtk_widget_region_intersect (GtkWidget *widget, GdkRegion *region);

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
 #void                  gtk_widget_set_state              (GtkWidget    *widget,
 #							 GtkStateType  state);

void
gtk_widget_set_sensitive (widget, sensitive)
	GtkWidget * widget
	gboolean sensitive

void gtk_widget_set_app_paintable (GtkWidget *widget, gboolean app_paintable);

void gtk_widget_set_double_buffered (GtkWidget *widget, gboolean double_buffered);

void gtk_widget_set_redraw_on_allocate (GtkWidget *widget, gboolean redraw_on_allocate);

 # gtk doc says useful only for impelemnting container sub classes, never to be
 # called by apps
 #void gtk_widget_set_parent (GtkWidget *widget, GtkWidget *parent);
 #void gtk_widget_set_parent_window (GtkWidget *widget, GdkWindow *parent_window);
 #void gtk_widget_set_child_visible (GtkWidget *widget, gboolean is_visible);
 #gboolean gtk_widget_get_child_visible (GtkWidget *widget);


 ## must allow NULL on return, in case somebody calls this on
 ## an unparented widget

GtkWidget_ornull *
gtk_widget_get_parent (widget)
	GtkWidget * widget
    ALIAS:
	Gtk2::Widget::get_parent = 0
	Gtk2::Widget::parent = 1
    CLEANUP:
	PERL_UNUSED_VAR (ix);

GdkWindow *gtk_widget_get_parent_window	  (GtkWidget	       *widget);

 # gtk doc says this is only useful for widget impelementations, never for apps
 #gboolean   gtk_widget_child_focus         (GtkWidget           *widget,
 #                                           GtkDirectionType     direction);

void
gtk_widget_set_size_request (widget, width=-1, height=-1)
	GtkWidget * widget
	gint width
	gint height

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

void gtk_widget_modify_fg (GtkWidget * widget, GtkStateType state, GdkColor * color);

void gtk_widget_modify_bg (GtkWidget * widget, GtkStateType state, GdkColor * color);

void gtk_widget_modify_text (GtkWidget * widget, GtkStateType state, GdkColor * color);

void gtk_widget_modify_base (GtkWidget * widget, GtkStateType state, GdkColor * color);

void gtk_widget_modify_font (GtkWidget *widget, PangoFontDescription *font_desc)


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
 
void gtk_widget_push_colormap (SV *class_or_widget, GdkColormap *cmap)
    C_ARGS: cmap

void gtk_widget_pop_colormap (SV *class_or_widget)
    C_ARGS: /* void */

void gtk_widget_push_composite_child (SV *class_or_widget)
    C_ARGS: /* void */

void gtk_widget_pop_composite_child (SV *class_or_widget)
    C_ARGS: /* void */

# bunch of FIXMEs FIXME FIXME FIXME
 #
 #/* widget style properties
 # */
 #void gtk_widget_class_install_style_property        (GtkWidgetClass     *klass,
 #						     GParamSpec         *pspec);
 #void gtk_widget_class_install_style_property_parser (GtkWidgetClass     *klass,
 #						     GParamSpec         *pspec,
 #						     GtkRcPropertyParser parser);
 #void gtk_widget_style_get_property (GtkWidget	     *widget,
 #				    const gchar    *property_name,
 #				    GValue	     *value);
 #void gtk_widget_style_get_valist   (GtkWidget	     *widget,
 #				    const gchar    *first_property_name,
 #				    va_list         var_args);
 #void gtk_widget_style_get          (GtkWidget	     *widget,
 #				    const gchar    *first_property_name,
 #				    ...);
 #
 #
 #/* Set certain default values to be used at widget creation time.
 # */

void gtk_widget_set_default_colormap (SV *class_or_widget, GdkColormap *colormap);
    C_ARGS: colormap

GtkStyle*
gtk_widget_get_default_style (SV *class_or_widget)
    C_ARGS: /* void */

GdkColormap* gtk_widget_get_default_colormap (SV *class_or_widget)
    C_ARGS: /* void */

GdkVisual* gtk_widget_get_default_visual (SV *class_or_widget)
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


#GdkDisplay* gtk_widget_get_display (GtkWidget *widget)
GdkDisplay *
gtk_widget_get_display (widget)
	GtkWidget * widget

#endif

