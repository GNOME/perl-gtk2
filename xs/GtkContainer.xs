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


static void
gtk2perl_foreach_callback (GtkWidget * widget,
                           GPerlCallback * callback)
{
	gperl_callback_invoke (callback, NULL, widget);
}


MODULE = Gtk2::Container	PACKAGE = Gtk2::Container	PREFIX = gtk_container_

void
gtk_container_set_border_width (container, border_width)
	GtkContainer *container
	guint border_width

guint
gtk_container_get_border_width (container)
	GtkContainer *container

void
gtk_container_add (container, widget)
	GtkContainer *container
	GtkWidget *widget

void
gtk_container_remove (container, widget)
	GtkContainer *container
	GtkWidget *widget

void
gtk_container_set_resize_mode (container, resize_mode)
	GtkContainer *container
	GtkResizeMode resize_mode

GtkResizeMode
gtk_container_get_resize_mode (container)
	GtkContainer *container

void
gtk_container_check_resize (container)
	GtkContainer *container

 ## void gtk_container_foreach (GtkContainer *container, GtkCallback callback, gpointer callback_data)
void
gtk_container_foreach (container, callback, callback_data=NULL)
	GtkContainer *container
	SV * callback
	SV * callback_data
    PREINIT:
	GPerlCallback * real_callback;
	GType param_types [] = { GTK_TYPE_WIDGET };
    CODE:
	real_callback = gperl_callback_new (callback, callback_data,
	                                    1, param_types, G_TYPE_NONE);
	gtk_container_foreach (container, 
	                       (GtkCallback)gtk2perl_foreach_callback,
	                       real_callback);
	gperl_callback_destroy (real_callback);

 ## deprecated
 ## gtk_container_foreach_full

 ## GList* gtk_container_get_children (GtkContainer *container)
=for apidoc
Returns a list of Gtk2::Widget's, the children of the container.
=cut
void
gtk_container_get_children (container)
	GtkContainer *container
    PREINIT:
	GList * children, * i;
    PPCODE:
	children = gtk_container_get_children (container);
	for (i = children ; i != NULL ; i = i->next)
		XPUSHs (sv_2mortal (newSVGtkWidget (GTK_WIDGET (i->data))));
	g_list_free (children);

# FIXME: is that okay?
 ## void gtk_container_propagate_expose (GtkContainer *container, GtkWidget *child, GdkEventExpose *event)
void
gtk_container_propagate_expose (container, child, event)
	GtkContainer *container
	GtkWidget *child
	GdkEvent *event
    C_ARGS:
	container, child, (GdkEventExpose *) event

 ## void gtk_container_set_focus_chain (GtkContainer *container, GList *focusable_widgets)
=for apidoc
=for arg ... of Gtk2::Widget's, the focus chain
Sets a focus chain, overriding the one computed automatically by GTK+.

In principle each widget in the chain should be a descendant of the container,
but this is not enforced by this method, since it's allowed to set the focus
chain before you pack the widgets, or have a widget in the chain that isn't
always packed. The necessary checks are done when the focus chain is actually
traversed.
=cut
void
gtk_container_set_focus_chain (container, ...)
	GtkContainer *container
    PREINIT:
	GList *focusable_widgets = NULL;
	int i;
    CODE:
	for (i = items - 1 ; i > 0 ; i--)
		focusable_widgets = g_list_prepend (focusable_widgets,
		                                    SvGtkWidget (ST (i)));
	gtk_container_set_focus_chain (container, focusable_widgets);
	g_list_free (focusable_widgets);
 
 ## gboolean gtk_container_get_focus_chain (GtkContainer *container, GList **focusable_widgets)
=for apidoc
Returns a list of Gtk2::Widgets, the focus chain.
=cut
void
gtk_container_get_focus_chain (container)
	GtkContainer *container
    PREINIT:
	GList * i, * focusable_widgets = NULL;
    PPCODE:
	if (!gtk_container_get_focus_chain (container, &focusable_widgets))
		XSRETURN_EMPTY;
	for (i = focusable_widgets; i != NULL ; i = i->next)
		XPUSHs (sv_2mortal (newSVGtkWidget (i->data)));
	g_list_free (focusable_widgets);

void
gtk_container_unset_focus_chain (container)
	GtkContainer *container

void
gtk_container_set_focus_child (container, child)
	GtkContainer *container
	GtkWidget *child

GtkAdjustment_ornull *
gtk_container_get_focus_hadjustment (container)
	GtkContainer * container

GtkAdjustment_ornull *
gtk_container_get_focus_vadjustment (container)
	GtkContainer * container

void
gtk_container_set_focus_vadjustment (container, adjustment)
	GtkContainer *container
	GtkAdjustment_ornull *adjustment

void
gtk_container_set_focus_hadjustment (container, adjustment)
	GtkContainer *container
	GtkAdjustment_ornull *adjustment

void
gtk_container_resize_children (container)
	GtkContainer *container

 ## GtkType gtk_container_child_type (GtkContainer *container)
const char *
gtk_container_child_type (container)
	GtkContainer *container
    PREINIT:
	GType gtype;
    CODE:
	gtype = gtk_container_child_type (container);
	if (!gtype)
		/* this means that the container is full. */
		XSRETURN_UNDEF;
	/* GtkWidgets are GObjects, so we should only be getting object
	 * types back from this function.  however, we might get a GType
	 * that isn't registered with the bindings, so we have to look 
	 * for one that we know about.  since Glib::Object is always
	 * registered, this loop cannot be infinite. */
	while (gtype &&
	       (NULL == (RETVAL = gperl_object_package_from_type (gtype))))
		gtype = g_type_parent (gtype);
    OUTPUT:
	RETVAL

# FIXME
#  next we have a whole slew of functions you'd use for child properties
#  and such.  any suggestions on how to use them?
 ## void gtk_container_class_install_child_property (GtkContainerClass *cclass, guint property_id, GParamSpec *pspec)
 ##void
 ##gtk_container_class_install_child_property (cclass, property_id, pspec)
 ##	GtkContainerClass *cclass
 ##	guint property_id
 ##	GParamSpec *pspec
 ##
 ## GParamSpec* gtk_container_class_find_child_property (GObjectClass *cclass, const gchar *property_name)
 ##GParamSpec*
 ##gtk_container_class_find_child_property (cclass, property_name)
 ##	GObjectClass *cclass
 ##	const gchar *property_name
 ##
 ## void gtk_container_add_with_properties (GtkContainer *container, GtkWidget *widget, const gchar *first_prop_name, ...)
 ##void
 ##gtk_container_add_with_properties (container, widget, first_prop_name, first_prop_name)
 ##	GtkContainer *container
 ##	GtkWidget *widget
 ##	const gchar *first_prop_name
 ##	...
 ##
 ## void gtk_container_child_set (GtkContainer *container, GtkWidget *child, const gchar *first_prop_name, ...)
 ##void
 ##gtk_container_child_set (container, child, first_prop_name, first_prop_name)
 ##	GtkContainer *container
 ##	GtkWidget *child
 ##	const gchar *first_prop_name
 ##	...
 ##
 ## void gtk_container_child_get_valist (GtkContainer *container, GtkWidget *child, const gchar *first_property_name, va_list var_args)
 ##void
 ##gtk_container_child_get_valist (container, child, first_property_name, var_args)
 ##	GtkContainer *container
 ##	GtkWidget *child
 ##	const gchar *first_property_name
 ##	va_list var_args
 ##
 ## void gtk_container_child_set_property (GtkContainer *container, GtkWidget *child, const gchar *property_name, const GValue *value)
 ##void
 ##gtk_container_child_set_property (container, child, property_name, value)
 ##	GtkContainer *container
 ##	GtkWidget *child
 ##	const gchar *property_name
 ##	const GValue *value
 ##
 ## void gtk_container_child_get_property (GtkContainer *container, GtkWidget *child, const gchar *property_name, GValue *value)
 ##void
 ##gtk_container_child_get_property (container, child, property_name, value)
 ##	GtkContainer *container
 ##	GtkWidget *child
 ##	const gchar *property_name
 ##	GValue *value
 ##
 ##void
 ##gtk_container_child_get (GtkContainer *container,
 ##	GtkWidget *child,
 ##	const gchar *first_prop_name,
 ##	...);
 ##
 ##void gtk_container_child_set_valist (GtkContainer *container,
 ##	GtkWidget *child,
 ##	const gchar *first_property_name,
 ##	va_list var_args);
 ##
# works on all children, including the internal ones.
 ##void gtk_container_forall (GtkContainer *container,
 ##	GtkCallback callback,
 ##	gpointer callback_data);
 ##
 ##GParamSpec** gtk_container_class_list_child_properties (GObjectClass *cclass,
 ##	guint *n_properties);

##GtkType gtk_container_get_type (void) G_GNUC_CONST

##void gtk_container_set_reallocate_redraws (GtkContainer *container, gboolean needs_redraws)
void
gtk_container_set_reallocate_redraws (container, needs_redraws)
	GtkContainer * container
	gboolean       needs_redraws

# __PRIVATE__
##void _gtk_container_queue_resize (GtkContainer *container)
