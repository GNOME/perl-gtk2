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

MODULE = Gtk2::TreeDnd	PACKAGE = Gtk2::TreeDragSource	PREFIX = gtk_tree_drag_source_

## gboolean gtk_tree_drag_source_row_draggable (GtkTreeDragSource *drag_source, GtkTreePath *path)
gboolean
gtk_tree_drag_source_row_draggable (drag_source, path)
	GtkTreeDragSource *drag_source
	GtkTreePath *path

## gboolean gtk_tree_drag_source_drag_data_delete (GtkTreeDragSource *drag_source, GtkTreePath *path)
gboolean
gtk_tree_drag_source_drag_data_delete (drag_source, path)
	GtkTreeDragSource *drag_source
	GtkTreePath *path

### gboolean gtk_tree_drag_source_drag_data_get (GtkTreeDragSource *drag_source, GtkTreePath *path, GtkSelectionData *selection_data)
=for apidoc
=for arg selection_data (Gtk2::SelectionData) the first selection data
=for arg ... (__hide__)
=cut
GtkSelectionData_copy *
gtk_tree_drag_source_drag_data_get (drag_source, path, selection_data)
	GtkTreeDragSource *drag_source
	GtkTreePath *path
    PREINIT:
	GtkSelectionData selection_data;
    CODE:
	if (!gtk_tree_drag_source_drag_data_get (drag_source, path, 
	                                         &selection_data))
		XSRETURN_UNDEF;
	RETVAL = &selection_data;
    OUTPUT:
	RETVAL

MODULE = Gtk2::TreeDnd	PACKAGE = Gtk2::TreeDragDest	PREFIX = gtk_tree_drag_dest_

## gboolean gtk_tree_drag_dest_drag_data_received (GtkTreeDragDest *drag_dest, GtkTreePath *dest, GtkSelectionData *selection_data)
gboolean
gtk_tree_drag_dest_drag_data_received (drag_dest, dest, selection_data)
	GtkTreeDragDest *drag_dest
	GtkTreePath *dest
	GtkSelectionData *selection_data

## gboolean gtk_tree_drag_dest_row_drop_possible (GtkTreeDragDest *drag_dest, GtkTreePath *dest_path, GtkSelectionData *selection_data)
gboolean
gtk_tree_drag_dest_row_drop_possible (drag_dest, dest_path, selection_data)
	GtkTreeDragDest *drag_dest
	GtkTreePath *dest_path
	GtkSelectionData *selection_data

MODULE = Gtk2::TreeDnd	PACKAGE = Gtk2::SelectionData	PREFIX = gtk_tree_

## gboolean gtk_tree_set_row_drag_data (GtkSelectionData *selection_data, GtkTreeModel *tree_model, GtkTreePath *path)
gboolean
gtk_tree_set_row_drag_data (selection_data, tree_model, path)
	GtkSelectionData *selection_data
	GtkTreeModel *tree_model
	GtkTreePath *path

## gboolean gtk_tree_get_row_drag_data (GtkSelectionData *selection_data, GtkTreeModel **tree_model, GtkTreePath **path)
=for apidoc
=signature (tree_model, path) = $selection_data->get_row_drag_data
=cut
void
gtk_tree_get_row_drag_data (selection_data)
	GtkSelectionData *selection_data
    PREINIT:
	GtkTreeModel *tree_model;
	GtkTreePath *path;
    PPCODE:
	if (! gtk_tree_get_row_drag_data (selection_data, &tree_model, &path))
		XSRETURN_EMPTY;
	EXTEND (SP, 2);
	PUSHs (sv_2mortal (newSVGtkTreeModel (tree_model)));
	PUSHs (sv_2mortal (newSVGtkTreePath_own (path)));

