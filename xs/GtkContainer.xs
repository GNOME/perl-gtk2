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
 ## void gtk_container_foreach_full (GtkContainer *container, GtkCallback callback, GtkCallbackMarshal marshal, gpointer callback_data, GtkDestroyNotify notify)

 ## GList* gtk_container_get_children (GtkContainer *container)
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

 ## void gtk_container_propagate_expose (GtkContainer *container, GtkWidget *child, GdkEventExpose *event)
 ##void
 ##gtk_container_propagate_expose (container, child, event)
 ##	GtkContainer *container
 ##	GtkWidget *child
 ##	GdkEventExpose *event
 ##
 ## void gtk_container_set_focus_chain (GtkContainer *container, GList *focusable_widgets)
 ##void
 ##gtk_container_set_focus_chain (container, focusable_widgets)
 ##	GtkContainer *container
 ##	GList *focusable_widgets
 ##
 ## gboolean gtk_container_get_focus_chain (GtkContainer *container, GList **focusable_widgets)
 ##gboolean
 ##gtk_container_get_focus_chain (container, focusable_widgets)
 ##	GtkContainer *container
 ##	GList **focusable_widgets
 ##
 ## void gtk_container_unset_focus_chain (GtkContainer *container)
 ##void
 ##gtk_container_unset_focus_chain (container)
 ##	GtkContainer *container

void
gtk_container_set_focus_child (container, child)
	GtkContainer *container
	GtkWidget *child

 ##GtkAdjustment *
 ##gtk_get_focus_hadjustment (container)
 ##	GtkContainer * container
 ##
 ##GtkAdjustment *
 ##gtk_get_focus_vadjustment (container)
 ##	GtkContainer * container
 ##
 ## void gtk_container_set_focus_vadjustment (GtkContainer *container, GtkAdjustment *adjustment)
 ##void
 ##gtk_container_set_focus_vadjustment (container, adjustment)
 ##	GtkContainer *container
 ##	GtkAdjustment *adjustment
 ##
 ## void gtk_container_set_focus_hadjustment (GtkContainer *container, GtkAdjustment *adjustment)
 ##void
 ##gtk_container_set_focus_hadjustment (container, adjustment)
 ##	GtkContainer *container
 ##	GtkAdjustment *adjustment
 ##
 ## void gtk_container_resize_children (GtkContainer *container)
 ##void
 ##gtk_container_resize_children (container)
 ##	GtkContainer *container
 ##
 ## GtkType gtk_container_child_type (GtkContainer *container)
 ##GtkType
 ##gtk_container_child_type (container)
 ##	GtkContainer *container
 ##
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

##void _gtk_container_queue_resize (GtkContainer *container)
#void
#_gtk_container_queue_resize (container)
#	GtkContainer * container

