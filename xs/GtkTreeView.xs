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

/* handlers for GtkTreeCellDataFunc, defined in GtkTreeViewColumn.xs */
GPerlCallback * gtk2perl_tree_cell_data_func_create (SV * func, SV *data);
void  gtk2perl_tree_cell_data_func (GtkTreeViewColumn * tree_column,
                                    GtkCellRenderer * cell,
                                    GtkTreeModel * tree_model,
                                    GtkTreeIter * iter,
                                    gpointer data);

static GPerlCallback *
gtk2perl_tree_view_column_drop_func_create (SV * func, SV *data)
{
	GType param_types [] = {
		GTK_TYPE_TREE_VIEW,
		GTK_TYPE_TREE_VIEW_COLUMN,
		GTK_TYPE_TREE_VIEW_COLUMN,
		GTK_TYPE_TREE_VIEW_COLUMN
	};
	return gperl_callback_new (func, data, G_N_ELEMENTS (param_types),
	                           param_types, G_TYPE_BOOLEAN);
}

static gboolean
gtk2perl_tree_view_column_drop_func (GtkTreeView * tree_view,
				     GtkTreeViewColumn * column,
				     GtkTreeViewColumn * prev_column,
				     GtkTreeViewColumn * next_column,
				     gpointer data)
{
	GPerlCallback * callback = (GPerlCallback*)data;
	GValue value = {0,};
	gboolean retval;

	g_value_init (&value, callback->return_type);
	gperl_callback_invoke (callback, &value, tree_view, column,
	                       prev_column, next_column);
	retval = g_value_get_boolean (&value);
	g_value_unset (&value);

	return retval;
}

static GPerlCallback *
gtk2perl_tree_view_mapping_func_create (SV * func, SV *data)
{
	GType param_types [] = {
		GTK_TYPE_TREE_VIEW,
		GTK_TYPE_TREE_PATH
	};
	return gperl_callback_new (func, data, G_N_ELEMENTS (param_types),
	                           param_types, 0);
}

static void
gtk2perl_tree_view_mapping_func (GtkTreeView * tree_view,
				 GtkTreePath * tree_path,
				 gpointer data)
{
	gperl_callback_invoke ((GPerlCallback*)data, NULL,
	                        tree_view, tree_path);
}

static GPerlCallback *
gtk2perl_tree_view_search_equal_func_create (SV * func, SV *data)
{
	GType param_types [] = {
		GTK_TYPE_TREE_MODEL,
		GTK_TYPE_INT,
		G_TYPE_STRING,
		GTK_TYPE_TREE_ITER
	};
	return gperl_callback_new (func, data, G_N_ELEMENTS (param_types),
	                           param_types, G_TYPE_BOOLEAN);
}

static gboolean
gtk2perl_tree_view_search_equal_func (GtkTreeModel * model,
				      gint column,
				      const gchar * key,
				      GtkTreeIter * iter,
				      gpointer data)
{
	GPerlCallback * callback = (GPerlCallback*)data;
	GValue value = {0,};
	gboolean retval;

	g_value_init (&value, callback->return_type);
	gperl_callback_invoke (callback, &value, model, column, key, iter);
	retval = g_value_get_boolean (&value);
	g_value_unset (&value);

	return retval;
}

#if 0
/* see commentary above gtk_tree_view_set_destroy_count_func() for details on
 * why this is commented out. */
GPerlCallback *
gtk2perl_tree_view_destroy_count_func_create (SV * func, SV *data)
{
	GType param_types [] = {
		GTK_TYPE_TREE_VIEW,
		GTK_TYPE_TREE_PATH,
		GTK_TYPE_INT
	};
	return gperl_callback_new (func, data, G_N_ELEMENTS(param_types), param_types, 0);
}

void
gtk2perl_tree_view_destroy_count_func (GtkTreeView * tree_view,
				       GtkTreePath * path,
				       gint children,
				       gpointer data)
{
	gperl_callback_invoke ((GPerlCallback*)data, NULL, tree_view, path, children);
}
#endif

MODULE = Gtk2::TreeView	PACKAGE = Gtk2::TreeView	PREFIX = gtk_tree_view_

=for enum Gtk2::TreeViewDropPosition
=cut

BOOT:
	/* gperl_set_isa ("Gtk2::TreeView", "Gtk2::Atk::ImplementorIface"); */

GtkWidget *
gtk_tree_view_new (class, model=NULL)
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

## gint gtk_tree_view_insert_column_with_attributes (GtkTreeView *tree_view, gint position, const gchar *title, GtkCellRenderer *cell, ...)
### this is implemented in GtkTreeViewColumn.xs so it can get access to
### a static helper function used to parse the stack for attributes.

#### gint gtk_tree_view_insert_column_with_data_func (GtkTreeView *tree_view, gint position, const gchar *title, GtkCellRenderer *cell, GtkTreeCellDataFunc func, gpointer data, GDestroyNotify dnotify)
=for apidoc
=for arg func (subroutine) 

Insert a column that calls I<$func> every time it needs to fetch the data for
a cell.  I<$func> will get a cell renderer, the tree model, and the iter of
the row in question, and should set the proper value into the cell renderer.

=cut
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
	EXTEND (SP, (int) g_list_length (columns));
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

GtkTreeViewColumn_ornull *
gtk_tree_view_get_expander_column (tree_view)
	GtkTreeView *tree_view

#### void gtk_tree_view_set_column_drag_function (GtkTreeView *tree_view, GtkTreeViewColumnDropFunc func, gpointer user_data, GtkDestroyNotify destroy)
void
gtk_tree_view_set_column_drag_function (tree_view, func, data=NULL)
	GtkTreeView *tree_view
	SV * func
	SV * data
    PREINIT:
	GPerlCallback * callback;
    CODE:
	callback = gtk2perl_tree_view_column_drop_func_create (func, data);
	gtk_tree_view_set_column_drag_function (tree_view,
						gtk2perl_tree_view_column_drop_func,
						callback,
						(GDestroyNotify) gperl_callback_destroy);

#### also allow undef instead of -1 to specify no scrolling
## void gtk_tree_view_scroll_to_point (GtkTreeView *tree_view, gint tree_x, gint tree_y)
void
gtk_tree_view_scroll_to_point (tree_view, tree_x, tree_y)
	GtkTreeView *tree_view
	SV * tree_x
	SV * tree_y
    PREINIT:
	gint real_tree_x = -1;
	gint real_tree_y = -1;
    CODE:
	/* can't do SvTRUE, because 0 is defined but not true. */
	real_tree_x = SvOK (tree_x) && looks_like_number (tree_x)
	            ? SvIV (tree_x) : -1;
	real_tree_y = SvOK (tree_y) && looks_like_number (tree_y)
	            ? SvIV (tree_y) : -1;
	gtk_tree_view_scroll_to_point (tree_view, real_tree_x, real_tree_y);

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
void
gtk_tree_view_map_expanded_rows (tree_view, func, data=NULL)
	GtkTreeView *tree_view
	SV * func
	SV * data
    PREINIT:
	GPerlCallback * callback;
    CODE:
	callback = gtk2perl_tree_view_mapping_func_create (func, data);
	gtk_tree_view_map_expanded_rows (tree_view,
					 gtk2perl_tree_view_mapping_func,
					 callback);
	gperl_callback_destroy (callback);

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
=for apidoc
=for signature (path, focus_column) = $tree_view->get_cursor
Returns the Gtk2::TreePath and Gtk2::TreeViewColumn of the cell with the
keyboard focus cursor.  Either may be undef.
=cut
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
=for apidoc
=for signature path = $tree_view->get_path_at_pos ($x, $y)
=for signature (path, column, cell_x, cell_y) = $tree_view->get_path_at_pos ($x, $y)
In scalar context, returns the Gtk2::TreePath, in array context, adds the
Gtk2::TreeViewColumn, and I<$x> and I<$y> translated to be relative to the
cell.
=cut
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
	XPUSHs (sv_2mortal (newSVGtkTreePath_own (path)));
	if (GIMME_V == G_ARRAY) {
		XPUSHs (sv_2mortal (newSVGtkTreeViewColumn (column)));
		XPUSHs (sv_2mortal (newSViv (cell_x)));
		XPUSHs (sv_2mortal (newSViv (cell_y)));
	}


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

### GdkWindow* gtk_tree_view_get_bin_window (GtkTreeView *tree_view);
GdkWindow *
gtk_tree_view_get_bin_window (tree_view)
	GtkTreeView *tree_view

#### void gtk_tree_view_widget_to_tree_coords (GtkTreeView *tree_view, gint wx, gint wy, gint *tx, gint *ty)
void gtk_tree_view_widget_to_tree_coords (GtkTreeView *tree_view, gint wx, gint wy, OUTLIST gint tx, OUTLIST gint ty)

#### void gtk_tree_view_tree_to_widget_coords (GtkTreeView *tree_view, gint tx, gint ty, gint *wx, gint *wy)
void gtk_tree_view_tree_to_widget_coords (GtkTreeView *tree_view, gint tx, gint ty, OUTLIST gint wx, OUTLIST gint wy)

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
void
gtk_tree_view_set_drag_dest_row (tree_view, path, pos)
	GtkTreeView *tree_view
	GtkTreePath_ornull *path
	GtkTreeViewDropPosition pos

#### void gtk_tree_view_get_drag_dest_row (GtkTreeView *tree_view, GtkTreePath **path, GtkTreeViewDropPosition *pos)
=for apidoc
=for signature (path, dropposition) = $tree_view->get_drag_dest_row
=cut
void
gtk_tree_view_get_drag_dest_row (tree_view)
	GtkTreeView *tree_view
    PREINIT:
	GtkTreePath *path;
	GtkTreeViewDropPosition pos;
    PPCODE:
	gtk_tree_view_get_drag_dest_row (tree_view, &path, &pos);
	EXTEND (SP, 2);
	PUSHs (sv_2mortal (newSVGtkTreePath_own (path)));
	PUSHs (sv_2mortal (newSVGtkTreeViewDropPosition (pos)));

#### gboolean gtk_tree_view_get_dest_row_at_pos (GtkTreeView *tree_view, gint drag_x, gint drag_y, GtkTreePath **path, GtkTreeViewDropPosition *pos)
=for apidoc
=for signature (path, dropposition) = $tree_view->get_dest_row_at_pos ($drag_x, $drag_y)
=cut
void
gtk_tree_view_get_dest_row_at_pos (tree_view, drag_x, drag_y)
	GtkTreeView *tree_view
	gint drag_x
	gint drag_y
    PREINIT:
	GtkTreePath *path;
	GtkTreeViewDropPosition pos;
    PPCODE:
	if (!gtk_tree_view_get_dest_row_at_pos (tree_view, drag_x, drag_y, &path, &pos))
		XSRETURN_EMPTY;
	EXTEND (SP, 2);
	PUSHs (sv_2mortal (newSVGtkTreePath_own (path)));
	PUSHs (sv_2mortal (newSVGtkTreeViewDropPosition (pos)));

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

# there are issues of major badness with this.  if you come up with a
# solution that won't be rickety and dangerous, go for it.
#### GtkTreeViewSearchEqualFunc gtk_tree_view_get_search_equal_func (GtkTreeView *tree_view)
##GtkTreeViewSearchEqualFunc
##gtk_tree_view_get_search_equal_func (tree_view)
##	GtkTreeView *tree_view

#### void gtk_tree_view_set_search_equal_func (GtkTreeView *tree_view, GtkTreeViewSearchEqualFunc search_equal_func, gpointer search_user_data, GtkDestroyNotify search_destroy)
=for apidoc
=for arg func (subroutine) 
=cut
void
gtk_tree_view_set_search_equal_func (tree_view, func, data=NULL)
	GtkTreeView *tree_view
	SV * func
	SV * data
    PREINIT:
	GPerlCallback * callback;
    CODE:
	callback = gtk2perl_tree_view_search_equal_func_create (func, data);
	gtk_tree_view_set_search_equal_func (tree_view,
	                         gtk2perl_tree_view_search_equal_func,
	                         callback,
	                         (GDestroyNotify) gperl_callback_destroy);


#if 0

## according to the documentation, this function "should almost never be
## used", and is exported for ATK.  i'll leave it out.
#### void gtk_tree_view_set_destroy_count_func (GtkTreeView *tree_view, GtkTreeDestroyCountFunc func, gpointer data, GtkDestroyNotify destroy)
void
gtk_tree_view_set_destroy_count_func (tree_view, func, data=NULL)
	GtkTreeView *tree_view
	SV * func
	SV * data
    PREINIT:
	GPerlCallback * callback;
    CODE:
	callback = gtk2perl_tree_view_destroy_count_func_create (func, data);
	gtk_tree_view_set_destroy_count_func (tree_view,
					      gtk2perl_tree_view_destroy_count_func,
					      callback,
					      (GDestroyNotify) gperl_callback_destroy);

#endif
