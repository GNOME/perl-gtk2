/*
 * Copyright (c) 2006 by the gtk2-perl team (see the file AUTHORS)
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

MODULE = Gtk2::CellRendererAccel	PACKAGE = Gtk2::CellRendererAccel	PREFIX = gtk_cell_renderer_accel_

##struct _GtkCellRendererAccel
##{
##  GtkCellRendererText parent;
##
##  /*< private >*/
##  guint accel_key;
##  GdkModifierType accel_mods;
##  guint keycode;
##  GtkCellRendererAccelMode accel_mode;
##
##  GtkWidget *edit_widget;
##  GtkWidget *grab_widget;
##  GtkWidget *sizing_label;
##};

GtkCellRenderer *gtk_cell_renderer_accel_new (class);
    C_ARGS:
        /*void*/
