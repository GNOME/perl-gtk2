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

SV *
allocation (widget)
	GtkWidget * widget
    CODE:
	RETVAL = newSVGtkAllocation (&(widget->allocation));
    OUTPUT:
	RETVAL

GtkStyle*
style (widget)
	GtkWidget * widget
    CODE:
	RETVAL = widget->style;
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
		default: croak ("inhandled case in flag_get - shouldn't happen");
	    }
	} else {
	    value = (gboolean) SvIV(ST(1));
	    switch (ix) {
		case  1: flag = GTK_TOPLEVEL	     ; break;
		case  2: flag = GTK_NO_WINDOW	     ; break;
		case  3: flag = GTK_REALIZED	     ; break;
		case  4: flag = GTK_MAPPED	     ; break;
		case  5: flag = GTK_VISIBLE	     ; break;
/* read only -	case  6: flag = GTK_DRAWABLE	     ; break; */
		case  7: flag = GTK_SENSITIVE	     ; break;
		case  8: flag = GTK_PARENT_SENSITIVE ; break;
/* read only -	case  9: flag = GTK_IS_SENSITIVE     ; break; */
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
		default: croak ("inhandled case in flag_set - shouldn't happen");
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

void
gtk_widget_destroy (widget)
	GtkWidget * widget

 #void	   gtk_widget_destroyed		  (GtkWidget	       *widget,
 #					   GtkWidget	      **widget_pointer);

 #void
 #gtk_widget_unparent (widget)
 #	GtkWidget * widget

void
gtk_widget_show	(widget)
	GtkWidget * widget

void
gtk_widget_show_now (widget)
	GtkWidget * widget

void
gtk_widget_hide (widget)
	GtkWidget * widget

void
gtk_widget_show_all (widget)
	GtkWidget * widget

void
gtk_widget_hide_all (widget)
	GtkWidget * widget

 #void	   gtk_widget_map		  (GtkWidget	       *widget);
 #void	   gtk_widget_unmap		  (GtkWidget	       *widget);

void
gtk_widget_realize (widget)
	GtkWidget * widget

void
gtk_widget_unrealize (widget)
	GtkWidget * widget

 #/* Queuing draws */

void gtk_widget_queue_draw (GtkWidget * widget);

void
gtk_widget_queue_draw_area (widget, x, y, width, height)
	GtkWidget * widget
	gint x
	gint y
	gint width
	gint height

 #void	   gtk_widget_queue_resize	  (GtkWidget	       *widget);
 #void	   gtk_widget_size_request	  (GtkWidget	       *widget,
 #					   GtkRequisition      *requisition);
 #void	   gtk_widget_size_allocate	  (GtkWidget	       *widget,
 #					   GtkAllocation       *allocation);
 #void       gtk_widget_get_child_requisition (GtkWidget	       *widget,
 #					     GtkRequisition    *requisition);

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

 #void       gtk_widget_set_accel_path      (GtkWidget           *widget,
 #					   const gchar         *accel_path,
 #					   GtkAccelGroup       *accel_group);
 #const gchar* _gtk_widget_get_accel_path   (GtkWidget           *widget);
 #GList*     gtk_widget_list_accel_closures (GtkWidget	       *widget);
 #gboolean   gtk_widget_mnemonic_activate   (GtkWidget           *widget,
 #					   gboolean             group_cycling);
 #gboolean   gtk_widget_event		  (GtkWidget	       *widget,
 #					   GdkEvent	       *event);
 #gint       gtk_widget_send_expose         (GtkWidget           *widget,
 #					   GdkEvent            *event);
 #

gboolean
gtk_widget_activate (widget)
	GtkWidget * widget

 #gboolean   gtk_widget_set_scroll_adjustments (GtkWidget        *widget,
 #					      GtkAdjustment    *hadjustment,
 #					      GtkAdjustment    *vadjustment);

void
gtk_widget_reparent (widget, new_parent)
	GtkWidget * widget
	GtkWidget * new_parent

 #gboolean   gtk_widget_intersect		  (GtkWidget	       *widget,
 #					   GdkRectangle	       *area,
 #					   GdkRectangle	       *intersection);
 #GdkRegion *gtk_widget_region_intersect	  (GtkWidget	       *widget,
 #					   GdkRegion	       *region);
 #
 #void	gtk_widget_freeze_child_notify	  (GtkWidget	       *widget);
 #void	gtk_widget_child_notify		  (GtkWidget	       *widget,
 #					   const gchar	       *child_property);
 #void	gtk_widget_thaw_child_notify	  (GtkWidget	       *widget);
 #
 #gboolean   gtk_widget_is_focus            (GtkWidget           *widget);

void
gtk_widget_grab_focus (widget)
	GtkWidget * widget

void
gtk_widget_grab_default (widget)
	GtkWidget * widget

void
gtk_widget_set_name (widget, name)
	GtkWidget    *widget
	const gchar  *name

const gchar*
gtk_widget_get_name (widget)
	GtkWidget    *widget

 #void                  gtk_widget_set_state              (GtkWidget    *widget,
 #							 GtkStateType  state);

void
gtk_widget_set_sensitive (widget, sensitive)
	GtkWidget * widget
	gboolean sensitive

 #void                  gtk_widget_set_app_paintable      (GtkWidget    *widget,
 #							 gboolean      app_paintable);
 #void                  gtk_widget_set_double_buffered    (GtkWidget    *widget,
 #							 gboolean      double_buffered);
 #void                  gtk_widget_set_redraw_on_allocate (GtkWidget    *widget,
 #							 gboolean      redraw_on_allocate);
 #void                  gtk_widget_set_parent             (GtkWidget    *widget,
 #							 GtkWidget    *parent);
 #void                  gtk_widget_set_parent_window      (GtkWidget    *widget,
 #							 GdkWindow    *parent_window);
 #void                  gtk_widget_set_child_visible      (GtkWidget    *widget,
 #							 gboolean      is_visible);
 #gboolean              gtk_widget_get_child_visible      (GtkWidget    *widget);
 #

 ## must allow NULL on return, in case somebody calls this on
 ## an unparented widget

GtkWidget_ornull *
gtk_widget_get_parent (widget)
	GtkWidget * widget
    ALIAS:
	Gtk2::Widget::get_parent = 0
	Gtk2::Widget::parent = 1

 #GdkWindow *gtk_widget_get_parent_window	  (GtkWidget	       *widget);
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

 #void       gtk_widget_add_events          (GtkWidget           *widget,
 #					   gint	                events);
 #void	   gtk_widget_set_extension_events (GtkWidget		*widget,
 #					    GdkExtensionMode	mode);
 #
 #GdkExtensionMode gtk_widget_get_extension_events (GtkWidget	*widget);

 ## allow NULL for those crazy folks who call get_toplevel before a
 ## widget has been added to a container

GtkWidget_ornull *
gtk_widget_get_toplevel	(widget)
	GtkWidget * widget

 #GtkWidget*   gtk_widget_get_ancestor	(GtkWidget	*widget,
 #					 GtkType	widget_type);
 #GdkColormap* gtk_widget_get_colormap	(GtkWidget	*widget);
 #GdkVisual*   gtk_widget_get_visual	(GtkWidget	*widget);
 #
 #GtkSettings* gtk_widget_get_settings    (GtkWidget      *widget);
 #
 #/* Accessibility support */
 #AtkObject*       gtk_widget_get_accessible               (GtkWidget          *widget);
 #
 #/* The following functions must not be called on an already
 # * realized widget. Because it is possible that somebody
 # * can call get_colormap() or get_visual() and save the
 # * result, these functions are probably only safe to
 # * call in a widget's init() function.
 # */
 #void         gtk_widget_set_colormap    (GtkWidget      *widget,
 #					 GdkColormap    *colormap);

 #gint	     gtk_widget_get_events	(GtkWidget	*widget);
GdkEventMask
gtk_widget_get_events (widget)
	GtkWidget	*widget
	CODE:
	RETVAL = gtk_widget_get_events (widget);
	warn ("gtk_widget_get_events returned 0x%08x", RETVAL);
	OUTPUT:
	RETVAL

 #void	     gtk_widget_get_pointer	(GtkWidget	*widget,
 #					 gint		*x,
 #					 gint		*y);
 #
 #gboolean     gtk_widget_is_ancestor	(GtkWidget	*widget,
 #					 GtkWidget	*ancestor);
 #
 #gboolean     gtk_widget_translate_coordinates (GtkWidget  *src_widget,
 #					       GtkWidget  *dest_widget,
 #					       gint        src_x,
 #					       gint        src_y,
 #					       gint       *dest_x,
 #					       gint       *dest_y);
 #
 #/* Hide widget and return TRUE.
 # */
 #gboolean     gtk_widget_hide_on_delete	(GtkWidget	*widget);
 #
 #/* Widget styles.
 # */
 #void	   gtk_widget_set_style		(GtkWidget	*widget,
 #					 GtkStyle	*style);
 #void	   gtk_widget_ensure_style	(GtkWidget	*widget);
#GtkStyle*  gtk_widget_get_style		(GtkWidget	*widget);
 #
 ###void gtk_widget_modify_style (GtkWidget *widget, GtkRcStyle *style);
 #void
 #gtk_widget_modify_style (widget, style)
 #	GtkWidget  * widget
 #	GtkRcStyle * style
 #
 #GtkRcStyle *gtk_widget_get_modifier_style (GtkWidget            *widget);

void gtk_widget_modify_fg (GtkWidget * widget, GtkStateType state, GdkColor * color);

void gtk_widget_modify_bg (GtkWidget * widget, GtkStateType state, GdkColor * color);

void gtk_widget_modify_text (GtkWidget * widget, GtkStateType state, GdkColor * color);

void gtk_widget_modify_base (GtkWidget * widget, GtkStateType state, GdkColor * color);


##void gtk_widget_modify_font (GtkWidget *widget, PangoFontDescription *font_desc)
void
gtk_widget_modify_font (widget, font_desc)
	GtkWidget            * widget
	PangoFontDescription * font_desc


 #PangoContext *gtk_widget_create_pango_context (GtkWidget   *widget);
 #PangoContext *gtk_widget_get_pango_context    (GtkWidget   *widget);

PangoLayout_noinc *
gtk_widget_create_pango_layout (widget, text)
	GtkWidget   * widget
        const gchar *text

 ### FIXME may return NULL if stockid isn't known.... but then, it will
 ###       croak on converting unknown stock ids, too.
GdkPixbuf_noinc *
gtk_widget_render_icon (widget, stock_id, size, detail=NULL)
	GtkWidget   * widget
	const gchar * stock_id
	GtkIconSize   size
	const gchar * detail


 #/* handle composite names for GTK_COMPOSITE_CHILD widgets,
 # * the returned name is newly allocated.
 # */
 #void   gtk_widget_set_composite_name	(GtkWidget	*widget,
 #					 const gchar   	*name);
 #gchar* gtk_widget_get_composite_name	(GtkWidget	*widget);
 #
 #/* Descend recursively and set rc-style on all widgets without user styles */
 #void       gtk_widget_reset_rc_styles   (GtkWidget      *widget);
 #
 #/* Push/pop pairs, to change default values upon a widget's creation.
 # * This will override the values that got set by the
 # * gtk_widget_set_default_* () functions.
 # */
 #void	     gtk_widget_push_colormap	     (GdkColormap *cmap);
 #void	     gtk_widget_push_composite_child (void);
 #void	     gtk_widget_pop_composite_child  (void);
 #void	     gtk_widget_pop_colormap	     (void);
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
 #void	     gtk_widget_set_default_colormap (GdkColormap *colormap);

GtkStyle* 
gtk_widget_get_default_style (class)
     SV* class
CODE:
     RETVAL = gtk_widget_get_default_style();
OUTPUT:
     RETVAL

 #GdkColormap* gtk_widget_get_default_colormap (void);
 #GdkVisual*   gtk_widget_get_default_visual   (void);
 #
 #/* Functions for setting directionality for widgets
 # */
 #
 #void             gtk_widget_set_direction         (GtkWidget        *widget,
 #						   GtkTextDirection  dir);
 #GtkTextDirection gtk_widget_get_direction         (GtkWidget        *widget);
 #
 #void             gtk_widget_set_default_direction (GtkTextDirection  dir);
 #GtkTextDirection gtk_widget_get_default_direction (void);
 #
 #/* Counterpart to gdk_window_shape_combine_mask.
 # */
 #void	     gtk_widget_shape_combine_mask (GtkWidget *widget,
 #					    GdkBitmap *shape_mask,
 #					    gint       offset_x,
 #					    gint       offset_y);
 #
 #/* Compute a widget's path in the form "GtkWindow.MyLabel", and
 # * return newly alocated strings.
 # */
 #void	     gtk_widget_path		   (GtkWidget *widget,
 #					    guint     *path_length,
 #					    gchar    **path,
 #					    gchar    **path_reversed);
 #void	     gtk_widget_class_path	   (GtkWidget *widget,
 #					    guint     *path_length,
 #					    gchar    **path,
 #					    gchar    **path_reversed);
 #
 #GtkRequisition *gtk_requisition_copy     (const GtkRequisition *requisition);
 #void            gtk_requisition_free     (GtkRequisition       *requisition);
 #
 #GdkColormap* _gtk_widget_peek_colormap (void);

##void gtk_widget_reset_shapes (GtkWidget *widget)
void
gtk_widget_reset_shapes (widget)
	GtkWidget * widget


#if GTK_CHECK_VERSION(2,2,0)

# GParamSpec not in typemap
##GParamSpec* gtk_widget_class_find_style_property (GtkWidgetClass *klass, const gchar *property_name)
#GParamSpec *
#gtk_widget_class_find_style_property (klass, property_name)
#	GtkWidgetClass * klass
#	const gchar    * property_name
#
# GParamSpec not in typemap
##GParamSpec** gtk_widget_class_list_style_properties (GtkWidgetClass *klass, guint *n_properties)
#GParamSpec **
#gtk_widget_class_list_style_properties (klass, n_properties)
#	GtkWidgetClass * klass
#	guint          * n_properties
#
#
##GtkClipboard* gtk_widget_get_clipboard (GtkWidget *widget, GdkAtom selection)
#GtkClipboard *
#gtk_widget_get_clipboard (widget, selection)
#	GtkWidget * widget
#	GdkAtom     selection


#GdkDisplay* gtk_widget_get_display (GtkWidget *widget)
GdkDisplay *
gtk_widget_get_display (widget)
	GtkWidget * widget

#endif

