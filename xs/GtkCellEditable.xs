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

/*
this is an interface
*/

MODULE = Gtk2::CellEditable	PACKAGE = Gtk2::CellEditable	PREFIX = gtk_cell_editable_

## void gtk_cell_editable_start_editing (GtkCellEditable *cell_editable, GdkEvent *event)
void
gtk_cell_editable_start_editing (cell_editable, event)
	GtkCellEditable *cell_editable
	GdkEvent *event

## void gtk_cell_editable_editing_done (GtkCellEditable *cell_editable)
void
gtk_cell_editable_editing_done (cell_editable)
	GtkCellEditable *cell_editable

## void gtk_cell_editable_remove_widget (GtkCellEditable *cell_editable)
void
gtk_cell_editable_remove_widget (cell_editable)
	GtkCellEditable *cell_editable

