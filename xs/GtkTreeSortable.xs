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

static GPerlCallback *
new_sort_func (SV * sort_func, SV * user_data)
{
	GType param_types[] = {
		GTK_TYPE_TREE_MODEL,
		GTK_TYPE_TREE_ITER,
		GTK_TYPE_TREE_ITER
	};
	return gperl_callback_new (sort_func, user_data,
	                           3, param_types, G_TYPE_INT);
}

static gint
gtk2perl_tree_iter_compare_func (GtkTreeModel *model,
                                 GtkTreeIter *a,
                                 GtkTreeIter *b,
                                 gpointer user_data)
{
	gint ret;
	GValue retval = {0,};
	GPerlCallback * callback = (GPerlCallback*) user_data;

	g_value_init (&retval, callback->return_type);
	gperl_callback_invoke (callback, &retval, model, a, b);
	ret = g_value_get_int (&retval);
	g_value_unset (&retval);

	return ret;
}

MODULE = Gtk2::TreeSortable	PACKAGE = Gtk2::TreeSortable	PREFIX = gtk_tree_sortable_

## void gtk_tree_sortable_sort_column_changed (GtkTreeSortable *sortable)
void
gtk_tree_sortable_sort_column_changed (sortable)
	GtkTreeSortable *sortable

#### gboolean gtk_tree_sortable_get_sort_column_id (GtkTreeSortable *sortable, gint *sort_column_id, GtkSortType *order)
=for apidoc
=for signature (sort_column_id, order) = $sortable->get_sort_column_id
Returns sort_column_id, an integer and order, a Gtk2::SortType.
=cut
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
void
gtk_tree_sortable_set_sort_func (sortable, sort_column_id, sort_func, user_data=NULL)
	GtkTreeSortable *sortable
	gint sort_column_id
	SV * sort_func
	SV * user_data
    CODE:
	gtk_tree_sortable_set_sort_func (sortable, sort_column_id,
	                                 gtk2perl_tree_iter_compare_func,
	                                 new_sort_func (sort_func, user_data),
	                                 (GtkDestroyNotify)
	                                       gperl_callback_destroy);

#### void gtk_tree_sortable_set_default_sort_func (GtkTreeSortable *sortable, GtkTreeIterCompareFunc sort_func, gpointer user_data, GtkDestroyNotify destroy)
void
gtk_tree_sortable_set_default_sort_func (sortable, sort_func, user_data=NULL)
	GtkTreeSortable *sortable
	SV * sort_func
	SV * user_data
    CODE:
	if (!sort_func || !SvOK (sort_func)) {
		gtk_tree_sortable_set_default_sort_func
					(sortable, NULL, NULL, NULL);
	} else {
		gtk_tree_sortable_set_default_sort_func
				(sortable, 
				 gtk2perl_tree_iter_compare_func,
		                 new_sort_func (sort_func, user_data),
				 (GtkDestroyNotify) gperl_callback_destroy);
	}

## gboolean gtk_tree_sortable_has_default_sort_func (GtkTreeSortable *sortable)
gboolean
gtk_tree_sortable_has_default_sort_func (sortable)
	GtkTreeSortable *sortable

