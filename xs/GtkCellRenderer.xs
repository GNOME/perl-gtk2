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

MODULE = Gtk2::CellRenderer	PACKAGE = Gtk2::CellRenderer	PREFIX = gtk_cell_renderer_

## void gtk_cell_renderer_get_size (GtkCellRenderer *cell, GtkWidget *widget, GdkRectangle *cell_area, gint *x_offset, gint *y_offset, gint *width, gint *height)
void
gtk_cell_renderer_get_size (cell, widget)
	GtkCellRenderer * cell
	GtkWidget       * widget
    PREINIT:
	gint x_offset;
	gint y_offset;
	gint width;
	gint height;
	GdkRectangle cell_area;
    PPCODE:
	cell_area.width = cell_area.height = 0;
	gtk_cell_renderer_get_size(cell, widget, &cell_area,
		&x_offset, &y_offset, &width, &height);
	EXTEND(SP,5);
	PUSHs(sv_2mortal(newSVGdkRectangle_copy (&cell_area)));
	PUSHs(sv_2mortal(newSViv(x_offset)));
	PUSHs(sv_2mortal(newSViv(y_offset)));
	PUSHs(sv_2mortal(newSViv(width)));
	PUSHs(sv_2mortal(newSViv(height)));

## void gtk_cell_renderer_render (GtkCellRenderer *cell, GdkWindow *window, GtkWidget *widget, GdkRectangle *background_area, GdkRectangle *cell_area, GdkRectangle *expose_area, GtkCellRendererState flags)
void
gtk_cell_renderer_render (cell, window, widget, background_area, cell_area, expose_area, flags)
	GtkCellRenderer      * cell
	GdkWindow            * window
	GtkWidget            * widget
	GdkRectangle         * background_area
	GdkRectangle         * cell_area
	GdkRectangle         * expose_area
	GtkCellRendererState   flags

## gboolean gtk_cell_renderer_activate (GtkCellRenderer *cell, GdkEvent *event, GtkWidget *widget, const gchar *path, GdkRectangle *background_area, GdkRectangle *cell_area, GtkCellRendererState flags)
gboolean
gtk_cell_renderer_activate (cell, event, widget, path, background_area, cell_area, flags)
	GtkCellRenderer      * cell
	GdkEvent             * event
	GtkWidget            * widget
	const gchar          * path
	GdkRectangle         * background_area
	GdkRectangle         * cell_area
	GtkCellRendererState   flags

## void gtk_cell_renderer_set_fixed_size (GtkCellRenderer *cell, gint width, gint height)
void
gtk_cell_renderer_set_fixed_size (cell, width, height)
	GtkCellRenderer * cell
	gint              width
	gint              height

## void gtk_cell_renderer_get_fixed_size (GtkCellRenderer *cell, gint *width, gint *height)
void
gtk_cell_renderer_get_fixed_size (GtkCellRenderer * cell, OUTLIST gint width, OUTLIST gint height)

##GtkCellEditable* gtk_cell_renderer_start_editing (GtkCellRenderer *cell, GdkEvent *event, GtkWidget *widget, const gchar *path, GdkRectangle *background_area, GdkRectangle *cell_area, GtkCellRendererState flags)
GtkCellEditable_ornull *
gtk_cell_renderer_start_editing (cell, event, widget, path, background_area, cell_area, flags)
	GtkCellRenderer      * cell
	GdkEvent             * event
	GtkWidget            * widget
	const gchar          * path
	GdkRectangle         * background_area
	GdkRectangle         * cell_area
	GtkCellRendererState   flags
