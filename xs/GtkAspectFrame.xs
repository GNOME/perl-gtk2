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

MODULE = Gtk2::AspectFrame	PACKAGE = Gtk2::AspectFrame	PREFIX = gtk_aspect_frame_

## GtkWidget* gtk_aspect_frame_new (const gchar *label, gfloat xalign, gfloat yalign, gfloat ratio, gboolean obey_child)
GtkWidget *
gtk_aspect_frame_new (class, label, xalign, yalign, ratio, obey_child)
	const gchar * label
	gfloat        xalign
	gfloat        yalign
	gfloat        ratio
	gboolean      obey_child
    C_ARGS:
	label, xalign, yalign, ratio, obey_child

## void gtk_aspect_frame_set (GtkAspectFrame *aspect_frame, gfloat xalign, gfloat yalign, gfloat ratio, gboolean obey_child)
 ### NOTE: renamed to avoid clashing with Glib::Object->set
void
gtk_aspect_frame_set_params (aspect_frame, xalign, yalign, ratio, obey_child)
	GtkAspectFrame * aspect_frame
	gfloat           xalign
	gfloat           yalign
	gfloat           ratio
	gboolean         obey_child
    CODE:
	gtk_aspect_frame_set (aspect_frame, xalign, yalign, ratio, obey_child);

