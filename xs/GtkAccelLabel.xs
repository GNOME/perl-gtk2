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

MODULE = Gtk2::AccelLabel	PACKAGE = Gtk2::AccelLabel	PREFIX = gtk_accel_label_

## GtkWidget* gtk_accel_label_new (const gchar *string)
GtkWidget *
gtk_accel_label_new (class, string)
	SV          * class
	const gchar * string
    C_ARGS:
	string
    CLEANUP:
	UNUSED(class);

## GtkWidget* gtk_accel_label_get_accel_widget (GtkAccelLabel *accel_label)
GtkWidget *
gtk_accel_label_get_accel_widget (accel_label)
	GtkAccelLabel * accel_label

## guint gtk_accel_label_get_accel_width (GtkAccelLabel *accel_label)
guint
gtk_accel_label_get_accel_width (accel_label)
	GtkAccelLabel * accel_label

## void gtk_accel_label_set_accel_widget (GtkAccelLabel *accel_label, GtkWidget *accel_widget)
void
gtk_accel_label_set_accel_widget (accel_label, accel_widget)
	GtkAccelLabel * accel_label
	GtkWidget     * accel_widget

# TODO: GClosure * not in typmap
## void gtk_accel_label_set_accel_closure (GtkAccelLabel *accel_label, GClosure *accel_closure)
#void
#gtk_accel_label_set_accel_closure (accel_label, accel_closure)
#	GtkAccelLabel * accel_label
#	GClosure      * accel_closure

## gboolean gtk_accel_label_refetch (GtkAccelLabel *accel_label)
gboolean
gtk_accel_label_refetch (accel_label)
	GtkAccelLabel * accel_label

