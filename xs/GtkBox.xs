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

MODULE = Gtk2::Box	PACKAGE = Gtk2::Box	PREFIX = gtk_box_

void
gtk_box_pack_start (box, child, expand, fill, padding)
	GtkBox *box
	GtkWidget *child
	gboolean expand
	gboolean fill
	guint padding

void
gtk_box_pack_end (box, child, expand, fill, padding)
	GtkBox *box
	GtkWidget *child
	gboolean expand
	gboolean fill
	guint padding

void
gtk_box_pack_start_defaults (box, widget)
	GtkBox *box
	GtkWidget *widget

void
gtk_box_pack_end_defaults (box, widget)
	GtkBox *box
	GtkWidget *widget

void
gtk_box_set_homogeneous (box, homogeneous)
	GtkBox *box
	gboolean homogeneous

gboolean
gtk_box_get_homogeneous (box)
	GtkBox *box

void
gtk_box_set_spacing (box, spacing)
	GtkBox *box
	gint spacing

gint
gtk_box_get_spacing (box)
	GtkBox *box

void
gtk_box_reorder_child (box, child, position)
	GtkBox *box
	GtkWidget *child
	gint position

void
gtk_box_query_child_packing (GtkBox * box, GtkWidget * child, OUTLIST gboolean expand, OUTLIST gboolean fill, OUTLIST guint padding, OUTLIST GtkPackType pack_type)

void
gtk_box_set_child_packing (box, child, expand, fill, padding, pack_type)
	GtkBox *box
	GtkWidget *child
	gboolean expand
	gboolean fill
	guint padding
	GtkPackType pack_type

