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

MODULE = Gtk2::TreeModelSort	PACKAGE = Gtk2::TreeModelSort	PREFIX = gtk_tree_model_sort_

BOOT:
	gperl_set_isa ("Gtk2::TreeModelSort", "Gtk2::TreeModel");
	gperl_set_isa ("Gtk2::TreeModelSort", "Gtk2::TreeSortable");


GtkTreeModel_noinc *
gtk_tree_model_sort_new_with_model (class, child_model)
	GtkTreeModel * child_model
    C_ARGS:
	child_model

GtkTreeModel *
gtk_tree_model_sort_get_model (tree_model)
	GtkTreeModelSort * tree_model


GtkTreePath_own_ornull*
gtk_tree_model_sort_convert_child_path_to_path (tree_model_sort, child_path)
	GtkTreeModelSort * tree_model_sort
	GtkTreePath      * child_path

GtkTreePath_own_ornull*
gtk_tree_model_sort_convert_path_to_child_path (tree_model_sort, sorted_path)
	GtkTreeModelSort * tree_model_sort
	GtkTreePath      * sorted_path


## void gtk_tree_model_sort_convert_child_iter_to_iter (GtkTreeModelSort *tree_model_sort, GtkTreeIter *sort_iter, GtkTreeIter *child_iter)
## C version initializes an existing iter for you;
## perl version returns a new iter.

GtkTreeIter_copy *
gtk_tree_model_sort_convert_child_iter_to_iter (tree_model_sort, child_iter)
	GtkTreeModelSort *tree_model_sort
	GtkTreeIter *child_iter
    PREINIT:
	GtkTreeIter sort_iter;
    CODE:
	gtk_tree_model_sort_convert_iter_to_child_iter (tree_model_sort,
	                                                &sort_iter,
	                                                child_iter);
	RETVAL = &sort_iter;
    OUTPUT:
	RETVAL

## void gtk_tree_model_sort_convert_iter_to_child_iter (GtkTreeModelSort *tree_model_sort, GtkTreeIter *child_iter, GtkTreeIter *sorted_iter)
## C version initializes an existing iter for you;
## perl version returns a new iter.

GtkTreeIter_copy *
gtk_tree_model_sort_convert_iter_to_child_iter (tree_model_sort, sorted_iter)
	GtkTreeModelSort *tree_model_sort
	GtkTreeIter *sorted_iter
    PREINIT:
	GtkTreeIter child_iter;
    CODE:
	gtk_tree_model_sort_convert_iter_to_child_iter (tree_model_sort,
	                                                &child_iter,
	                                                sorted_iter);
	RETVAL = &child_iter;
    OUTPUT:
	RETVAL


void
gtk_tree_model_sort_reset_default_sort_func (tree_model_sort)
	GtkTreeModelSort *tree_model_sort


## the API docs say this should almost never be called.
## therefore, it's out unless somebody can find a need for it.
#### void gtk_tree_model_sort_clear_cache (GtkTreeModelSort *tree_model_sort)
##void
##gtk_tree_model_sort_clear_cache (tree_model_sort)
##	GtkTreeModelSort *tree_model_sort

#if GTK_CHECK_VERSION(2,2,0)

## API docs say to use this only for testing/debugging purposes
gboolean
gtk_tree_model_sort_iter_is_valid (tree_model_sort, iter)
	GtkTreeModelSort *tree_model_sort
	GtkTreeIter *iter

#endif
