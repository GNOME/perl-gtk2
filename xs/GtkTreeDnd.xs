/*
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
#gboolean
#gtk_tree_drag_source_drag_data_get (drag_source, path, selection_data)
#	GtkTreeDragSource *drag_source
#	GtkTreePath *path
#	GtkSelectionData *selection_data

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

MODULE = Gtk2::TreeDnd	PACKAGE = Gtk2::Tree	PREFIX = gtk_tree_

## gboolean gtk_tree_set_row_drag_data (GtkSelectionData *selection_data, GtkTreeModel *tree_model, GtkTreePath *path)
gboolean
gtk_tree_set_row_drag_data (selection_data, tree_model, path)
	GtkSelectionData *selection_data
	GtkTreeModel *tree_model
	GtkTreePath *path

### gboolean gtk_tree_get_row_drag_data (GtkSelectionData *selection_data, GtkTreeModel **tree_model, GtkTreePath **path)
#gboolean
#gtk_tree_get_row_drag_data (selection_data, tree_model, path)
#	GtkSelectionData *selection_data
#	GtkTreeModel **tree_model
#	GtkTreePath **path

