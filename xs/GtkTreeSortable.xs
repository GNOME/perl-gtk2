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

// typedef gint (* GtkTreeIterCompareFunc) (GtkTreeModel *model, GtkTreeIter *a, GtkTreeIter *b, gpointer user_data)

MODULE = Gtk2::TreeSortable	PACKAGE = Gtk2::TreeSortable	PREFIX = gtk_tre_sortable_

## void gtk_tree_sortable_sort_column_changed (GtkTreeSortable *sortable)
void
gtk_tree_sortable_sort_column_changed (sortable)
	GtkTreeSortable *sortable

#### gboolean gtk_tree_sortable_get_sort_column_id (GtkTreeSortable *sortable, gint *sort_column_id, GtkSortType *order)
void
gtk_tree_sortable_get_sort_column_id (sortable)
	GtkTreeSortable *sortable
    PREINIT:
	gint sort_column_id;
	GtkSortType order;
    PPCODE:
	if (!gtk_tree_sortable_get_sort_column_id (sortable, &sort_column_id,
	                                           &order))
		XSRETURN_EMPTY;
	EXTEND (SP, 2);
	PUSHs (sv_2mortal (newSViv (sort_column_id)));
	PUSHs (sv_2mortal (newSVGtkSortType (order)));

## void gtk_tree_sortable_set_sort_column_id (GtkTreeSortable *sortable, gint sort_column_id, GtkSortType order)
void
gtk_tree_sortable_set_sort_column_id (sortable, sort_column_id, order)
	GtkTreeSortable *sortable
	gint sort_column_id
	GtkSortType order

#### void gtk_tree_sortable_set_sort_func (GtkTreeSortable *sortable, gint sort_column_id, GtkTreeIterCompareFunc sort_func, gpointer user_data, GtkDestroyNotify destroy)
##void
##gtk_tree_sortable_set_sort_func (sortable, sort_column_id, sort_func, user_data, destroy)
##	GtkTreeSortable *sortable
##	gint sort_column_id
##	GtkTreeIterCompareFunc sort_func
##	gpointer user_data
##	GtkDestroyNotify destroy
##
#### void gtk_tree_sortable_set_default_sort_func (GtkTreeSortable *sortable, GtkTreeIterCompareFunc sort_func, gpointer user_data, GtkDestroyNotify destroy)
##void
##gtk_tree_sortable_set_default_sort_func (sortable, sort_func, user_data, destroy)
##	GtkTreeSortable *sortable
##	GtkTreeIterCompareFunc sort_func
##	gpointer user_data
##	GtkDestroyNotify destroy

## gboolean gtk_tree_sortable_has_default_sort_func (GtkTreeSortable *sortable)
gboolean
gtk_tree_sortable_has_default_sort_func (sortable)
	GtkTreeSortable *sortable

