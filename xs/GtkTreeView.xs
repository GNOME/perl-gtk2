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

/* handlers for GtkTreeCellDataFunc, defined in GtkTreeViewColumn.xs */
GPerlCallback * gtk2perl_tree_cell_data_func_create (SV * func, SV *data);
void  gtk2perl_tree_cell_data_func (GtkTreeViewColumn * tree_column,
                                    GtkCellRenderer * cell,
                                    GtkTreeModel * tree_model,
                                    GtkTreeIter * iter,
                                    gpointer data);

// typedef gboolean (* GtkTreeViewColumnDropFunc) (GtkTreeView *tree_view, GtkTreeViewColumn *column, GtkTreeViewColumn *prev_column, GtkTreeViewColumn *next_column, gpointer data)
// typedef void (* GtkTreeViewMappingFunc) (GtkTreeView *tree_view, GtkTreePath *path, gpointer user_data)
// typedef gboolean (*GtkTreeViewSearchEqualFunc) (GtkTreeModel *model, gint column, const gchar *key, GtkTreeIter *iter, gpointer search_data)
// typedef void (* GtkTreeDestroyCountFunc) (GtkTreeView *tree_view, GtkTreePath *path, gint children, gpointer user_data)

MODULE = Gtk2::TreeView	PACKAGE = Gtk2::TreeView	PREFIX = gtk_tree_view_

BOOT:
	//gperl_set_isa ("Gtk2::TreeView", "Gtk2::Atk::ImplementorIface");

### FIXME what about constructor consolidations?:

GtkWidget *
gtk_tree_view_new (class, model=NULL)
	SV * class
	GtkTreeModel * model
    CODE:
	if (model)
		RETVAL = gtk_tree_view_new_with_model (model);
	else
		RETVAL = gtk_tree_view_new ();
    OUTPUT:
	RETVAL

GtkWidget *
gtk_tree_view_new_with_model (class, model)
	SV * class
	GtkTreeModel * model
    C_ARGS:
	model

GtkTreeModel_ornull *
gtk_tree_view_get_model (tree_view)
	GtkTreeView * tree_view

void
gtk_tree_view_set_model (tree_view, model)
	GtkTreeView *tree_view
	GtkTreeModel_ornull *model

GtkTreeSelection*
gtk_tree_view_get_selection (tree_view)
	GtkTreeView * tree_view


GtkAdjustment_ornull *
gtk_tree_view_get_hadjustment (tree_view)
	GtkTreeView *tree_view

GtkAdjustment_ornull *
gtk_tree_view_get_vadjustment (tree_view)
	GtkTreeView *tree_view

void
gtk_tree_view_set_hadjustment (tree_view, adjustment)
	GtkTreeView *tree_view
	GtkAdjustment_ornull *adjustment

void
gtk_tree_view_set_vadjustment (tree_view, adjustment)
	GtkTreeView *tree_view
	GtkAdjustment_ornull *adjustment

gboolean
gtk_tree_view_get_headers_visible (tree_view)
	GtkTreeView *tree_view

void
gtk_tree_view_set_headers_visible (tree_view, headers_visible)
	GtkTreeView *tree_view
	gboolean headers_visible

void
gtk_tree_view_columns_autosize (tree_view)
	GtkTreeView *tree_view

void
gtk_tree_view_set_headers_clickable (tree_view, setting)
	GtkTreeView *tree_view
	gboolean setting

void
gtk_tree_view_set_rules_hint (tree_view, setting)
	GtkTreeView *tree_view
	gboolean setting

gboolean
gtk_tree_view_get_rules_hint (tree_view)
	GtkTreeView *tree_view

gint
gtk_tree_view_append_column (tree_view, column)
	GtkTreeView *tree_view
	GtkTreeViewColumn *column

gint
gtk_tree_view_remove_column (tree_view, column)
	GtkTreeView *tree_view
	GtkTreeViewColumn *column

gint
gtk_tree_view_insert_column (tree_view, column, position)
	GtkTreeView *tree_view
	GtkTreeViewColumn *column
	gint position

### TODO
## gint gtk_tree_view_insert_column_with_attributes (GtkTreeView *tree_view, gint position, const gchar *title, GtkCellRenderer *cell, ...)
### this is implemented in GtkTreeViewColumn.xs so it can get access to
### a static helper function used to parse the stack for attributes.

#### gint gtk_tree_view_insert_column_with_data_func (GtkTreeView *tree_view, gint position, const gchar *title, GtkCellRenderer *cell, GtkTreeCellDataFunc func, gpointer data, GDestroyNotify dnotify)
##gint
##gtk_tree_view_insert_column_with_data_func (tree_view, position, title, cell, func, data, dnotify)
##	GtkTreeView *tree_view
##	gint position
##	const gchar *title
##	GtkCellRenderer *cell
##	GtkTreeCellDataFunc func
##	gpointer data
##	GDestroyNotify dnotify
gint
gtk_tree_view_insert_column_with_data_func (tree_view, position, title, cell, func, data=NULL)
	GtkTreeView *tree_view
	gint position
	const gchar *title
	GtkCellRenderer *cell
	SV * func
	SV * data
    PREINIT:
	GPerlCallback * callback;
    CODE:
	callback = gtk2perl_tree_cell_data_func_create (func, data);
	RETVAL = gtk_tree_view_insert_column_with_data_func
				(tree_view, position, title, cell,
				 gtk2perl_tree_cell_data_func, callback,
				 (GDestroyNotify) gperl_callback_destroy);
    OUTPUT:
	RETVAL

GtkTreeViewColumn *
gtk_tree_view_get_column (tree_view, n)
	GtkTreeView * tree_view
	gint n

### return the columns on the stack.
### GList*      gtk_tree_view_get_columns       (GtkTreeView *tree_view);
void
gtk_tree_view_get_columns (tree_view)
	GtkTreeView * tree_view
    PREINIT:
	GList * columns, * i;
    PPCODE:
	columns = gtk_tree_view_get_columns (tree_view);
	if (!columns)
		XSRETURN_EMPTY;
	EXTEND (SP, g_list_length (columns));
	for (i = columns ; i ; i = i->next)
		PUSHs (sv_2mortal (newSVGtkTreeViewColumn (GTK_TREE_VIEW_COLUMN (i->data))));
	g_list_free (columns);

void
gtk_tree_view_move_column_after (tree_view, column, base_column)
	GtkTreeView *tree_view
	GtkTreeViewColumn *column
	GtkTreeViewColumn_ornull *base_column

void
gtk_tree_view_set_expander_column (tree_view, column)
	GtkTreeView *tree_view
	GtkTreeViewColumn_ornull *column

#### void gtk_tree_view_set_column_drag_function (GtkTreeView *tree_view, GtkTreeViewColumnDropFunc func, gpointer user_data, GtkDestroyNotify destroy)
##void
##gtk_tree_view_set_column_drag_function (tree_view, func, user_data, destroy)
##	GtkTreeView *tree_view
##	GtkTreeViewColumnDropFunc func
##	gpointer user_data
##	GtkDestroyNotify destroy


#### FIXME also allow undef instead of -1 to specify no scrolling
## void gtk_tree_view_scroll_to_point (GtkTreeView *tree_view, gint tree_x, gint tree_y)
void
gtk_tree_view_scroll_to_point (tree_view, tree_x, tree_y)
	GtkTreeView *tree_view
	gint tree_x
	gint tree_y

void
gtk_tree_view_scroll_to_cell (tree_view, path, column=NULL, use_align=FALSE, row_align=0.0, col_align=0.0)
	GtkTreeView *tree_view
	GtkTreePath_ornull *path
	GtkTreeViewColumn_ornull *column
	gboolean use_align
	gfloat row_align
	gfloat col_align

void
gtk_tree_view_row_activated (tree_view, path, column)
	GtkTreeView *tree_view
	GtkTreePath *path
	GtkTreeViewColumn *column

void
gtk_tree_view_expand_all (tree_view)
	GtkTreeView *tree_view

void
gtk_tree_view_collapse_all (tree_view)
	GtkTreeView *tree_view

#if GTK_CHECK_VERSION(2,2,0)

void
gtk_tree_view_expand_to_path (tree_view, path)
	GtkTreeView *tree_view
	GtkTreePath *path

#endif /* >= 2.2.0 */

gboolean
gtk_tree_view_expand_row (tree_view, path, open_all)
	GtkTreeView *tree_view
	GtkTreePath *path
	gboolean open_all

gboolean
gtk_tree_view_collapse_row (tree_view, path)
	GtkTreeView *tree_view
	GtkTreePath *path

#### void gtk_tree_view_map_expanded_rows (GtkTreeView *tree_view, GtkTreeViewMappingFunc func, gpointer data)
##void
##gtk_tree_view_map_expanded_rows (tree_view, func, data)
##	GtkTreeView *tree_view
##	GtkTreeViewMappingFunc func
##	gpointer data

gboolean
gtk_tree_view_row_expanded (tree_view, path)
	GtkTreeView *tree_view
	GtkTreePath *path

void
gtk_tree_view_set_reorderable (tree_view, reorderable)
	GtkTreeView *tree_view
	gboolean reorderable

gboolean
gtk_tree_view_get_reorderable (tree_view)
	GtkTreeView *tree_view

void
gtk_tree_view_set_cursor (tree_view, path, focus_column=NULL, start_editing=FALSE)
	GtkTreeView *tree_view
	GtkTreePath *path
	GtkTreeViewColumn_ornull *focus_column
	gboolean start_editing

#if GTK_CHECK_VERSION(2,2,0)

void
gtk_tree_view_set_cursor_on_cell (tree_view, path, focus_column, focus_cell, start_editing)
	GtkTreeView *tree_view
	GtkTreePath *path
	GtkTreeViewColumn_ornull *focus_column
	GtkCellRenderer_ornull *focus_cell
	gboolean start_editing

#endif /* >= 2.2.0 */

## void gtk_tree_view_get_cursor (GtkTreeView *tree_view, GtkTreePath **path, GtkTreeViewColumn **focus_column)
void
gtk_tree_view_get_cursor (tree_view)
	GtkTreeView *tree_view
    PREINIT:
	GtkTreePath *path;
	GtkTreeViewColumn *focus_column;
    PPCODE:
	gtk_tree_view_get_cursor (tree_view, &path, &focus_column);
	EXTEND (SP, 2);
	PUSHs (sv_2mortal (path == NULL
	                   ? &PL_sv_undef
	                   : newSVGtkTreePath_copy (path)));
	PUSHs (sv_2mortal (focus_column == NULL
	                   ? &PL_sv_undef
	                   : newSVGtkTreeViewColumn (focus_column)));


#### gboolean gtk_tree_view_get_path_at_pos (GtkTreeView *tree_view, gint x, gint y, GtkTreePath **path, GtkTreeViewColumn **column, gint *cell_x, gint *cell_y)
void
gtk_tree_view_get_path_at_pos (tree_view, x, y)
	GtkTreeView *tree_view
	gint x
	gint y
    PREINIT:
	GtkTreePath *path;
	GtkTreeViewColumn *column;
	gint cell_x;
	gint cell_y;
    PPCODE:
	if (!gtk_tree_view_get_path_at_pos (tree_view, x, y, &path, &column, &cell_x, &cell_y))
		XSRETURN_EMPTY;
	EXTEND (SP, 4);
	PUSHs (sv_2mortal (newSVGtkTreePath_own (path)));
	PUSHs (sv_2mortal (newSVGtkTreeViewColumn (column)));
	PUSHs (sv_2mortal (newSViv (cell_x)));
	PUSHs (sv_2mortal (newSViv (cell_y)));


### void gtk_tree_view_get_cell_area (GtkTreeView *tree_view, GtkTreePath *path, GtkTreeViewColumn *column, GdkRectangle *rect)
GdkRectangle_copy *
gtk_tree_view_get_cell_area (tree_view, path, column)
	GtkTreeView *tree_view
	GtkTreePath *path
	GtkTreeViewColumn *column
    PREINIT:
	GdkRectangle rect;
    CODE:
	gtk_tree_view_get_cell_area (tree_view, path, column, &rect);
	RETVAL = &rect;
    OUTPUT:
	RETVAL

### void gtk_tree_view_get_background_area (GtkTreeView *tree_view, GtkTreePath *path, GtkTreeViewColumn *column, GdkRectangle *rect)
GdkRectangle_copy *
gtk_tree_view_get_background_area (tree_view, path, column)
	GtkTreeView *tree_view
	GtkTreePath *path
	GtkTreeViewColumn *column
    PREINIT:
	GdkRectangle rect;
    CODE:
	gtk_tree_view_get_background_area (tree_view, path, column, &rect);
	RETVAL = &rect;
    OUTPUT:
	RETVAL

### void gtk_tree_view_get_visible_rect (GtkTreeView *tree_view, GdkRectangle *visible_rect)
GdkRectangle_copy *
gtk_tree_view_get_visible_rect (tree_view)
	GtkTreeView *tree_view
    PREINIT:
	GdkRectangle visible_rect;
    CODE:
	gtk_tree_view_get_visible_rect (tree_view, &visible_rect);
	RETVAL = &visible_rect;
    OUTPUT:
	RETVAL


## FIXME this is where i stopped so i could try to go home

###GdkWindow*  gtk_tree_view_get_bin_window    (GtkTreeView *tree_view);
##
##
#### void gtk_tree_view_widget_to_tree_coords (GtkTreeView *tree_view, gint wx, gint wy, gint *tx, gint *ty)
##void
##gtk_tree_view_widget_to_tree_coords (tree_view, wx, wy, tx, ty)
##	GtkTreeView *tree_view
##	gint wx
##	gint wy
##	gint *tx
##	gint *ty
##
#### void gtk_tree_view_tree_to_widget_coords (GtkTreeView *tree_view, gint tx, gint ty, gint *wx, gint *wy)
##void
##gtk_tree_view_tree_to_widget_coords (tree_view, tx, ty, wx, wy)
##	GtkTreeView *tree_view
##	gint tx
##	gint ty
##	gint *wx
##	gint *wy
##

#### void gtk_tree_view_enable_model_drag_source (GtkTreeView *tree_view, GdkModifierType start_button_mask, const GtkTargetEntry *targets, gint n_targets, GdkDragAction actions)
void
gtk_tree_view_enable_model_drag_source (tree_view, start_button_mask, actions, ...)
	GtkTreeView *tree_view
	GdkModifierType start_button_mask
	GdkDragAction actions
    PREINIT:
    	GtkTargetEntry * targets = NULL;
	gint n_targets, i;
    CODE:
#define FIRST_TARGET 3
	n_targets = items - FIRST_TARGET;
	targets = g_new (GtkTargetEntry, n_targets);
	for (i = 0 ; i < n_targets ; i++)
		gtk2perl_read_gtk_target_entry (ST (i+FIRST_TARGET), targets+i);
	gtk_tree_view_enable_model_drag_source (tree_view, start_button_mask, targets, n_targets, actions);
#undef FIRST_TARGET
    CLEANUP:
	g_free (targets);

#### void gtk_tree_view_enable_model_drag_dest (GtkTreeView *tree_view, const GtkTargetEntry *targets, gint n_targets, GdkDragAction actions)
void
gtk_tree_view_enable_model_drag_dest (tree_view, actions, ...)
	GtkTreeView *tree_view
	GdkDragAction actions
    PREINIT:
	GtkTargetEntry * targets = NULL;
	gint n_targets, i;
    CODE:
#define FIRST_TARGET 2
	n_targets = items - FIRST_TARGET;
	targets = g_new (GtkTargetEntry, n_targets);
	for (i = 0 ; i < n_targets ; i++)
		gtk2perl_read_gtk_target_entry (ST (i+FIRST_TARGET), targets+i);
	gtk_tree_view_enable_model_drag_dest (tree_view, targets, n_targets, actions);
#undef FIRST_TARGET
    CLEANUP:
	g_free (targets);

#### void gtk_tree_view_unset_rows_drag_source (GtkTreeView *tree_view)
void
gtk_tree_view_unset_rows_drag_source (tree_view)
	GtkTreeView *tree_view

#### void gtk_tree_view_unset_rows_drag_dest (GtkTreeView *tree_view)
void
gtk_tree_view_unset_rows_drag_dest (tree_view)
	GtkTreeView *tree_view

#### void gtk_tree_view_set_drag_dest_row (GtkTreeView *tree_view, GtkTreePath *path, GtkTreeViewDropPosition pos)
##void
##gtk_tree_view_set_drag_dest_row (tree_view, path, pos)
##	GtkTreeView *tree_view
##	GtkTreePath *path
##	GtkTreeViewDropPosition pos
##
#### void gtk_tree_view_get_drag_dest_row (GtkTreeView *tree_view, GtkTreePath **path, GtkTreeViewDropPosition *pos)
##void
##gtk_tree_view_get_drag_dest_row (tree_view, path, pos)
##	GtkTreeView *tree_view
##	GtkTreePath **path
##	GtkTreeViewDropPosition *pos
##
#### gboolean gtk_tree_view_get_dest_row_at_pos (GtkTreeView *tree_view, gint drag_x, gint drag_y, GtkTreePath **path, GtkTreeViewDropPosition *pos)
##gboolean
##gtk_tree_view_get_dest_row_at_pos (tree_view, drag_x, drag_y, path, pos)
##	GtkTreeView *tree_view
##	gint drag_x
##	gint drag_y
##	GtkTreePath **path
##	GtkTreeViewDropPosition *pos
##
## void gtk_tree_view_set_enable_search (GtkTreeView *tree_view, gboolean enable_search)
void
gtk_tree_view_set_enable_search (tree_view, enable_search)
	GtkTreeView *tree_view
	gboolean enable_search

## gboolean gtk_tree_view_get_enable_search (GtkTreeView *tree_view)
gboolean
gtk_tree_view_get_enable_search (tree_view)
	GtkTreeView *tree_view

## gint gtk_tree_view_get_search_column (GtkTreeView *tree_view)
gint
gtk_tree_view_get_search_column (tree_view)
	GtkTreeView *tree_view

## void gtk_tree_view_set_search_column (GtkTreeView *tree_view, gint column)
void
gtk_tree_view_set_search_column (tree_view, column)
	GtkTreeView *tree_view
	gint column

#### GtkTreeViewSearchEqualFunc gtk_tree_view_get_search_equal_func (GtkTreeView *tree_view)
##GtkTreeViewSearchEqualFunc
##gtk_tree_view_get_search_equal_func (tree_view)
##	GtkTreeView *tree_view
##
#### void gtk_tree_view_set_search_equal_func (GtkTreeView *tree_view, GtkTreeViewSearchEqualFunc search_equal_func, gpointer search_user_data, GtkDestroyNotify search_destroy)
##void
##gtk_tree_view_set_search_equal_func (tree_view, search_equal_func, search_user_data, search_destroy)
##	GtkTreeView *tree_view
##	GtkTreeViewSearchEqualFunc search_equal_func
##	gpointer search_user_data
##	GtkDestroyNotify search_destroy
##
#### void gtk_tree_view_set_destroy_count_func (GtkTreeView *tree_view, GtkTreeDestroyCountFunc func, gpointer data, GtkDestroyNotify destroy)
##void
##gtk_tree_view_set_destroy_count_func (tree_view, func, data, destroy)
##	GtkTreeView *tree_view
##	GtkTreeDestroyCountFunc func
##	gpointer data
##	GtkDestroyNotify destroy
##
