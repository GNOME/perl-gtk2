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

/* descended directly from GObject */

static GPerlCallback *
gtk2perl_tree_selection_func_create (SV * func, SV * data)
{
	GType param_types [] = {
		GTK_TYPE_TREE_SELECTION,
		GTK_TYPE_TREE_MODEL,
		GTK_TYPE_TREE_PATH,
		G_TYPE_BOOLEAN
	};
	return gperl_callback_new (func, data, G_N_ELEMENTS (param_types),
				   param_types, G_TYPE_BOOLEAN);
}

static gboolean
gtk2perl_tree_selection_func (GtkTreeSelection * selection,
			      GtkTreeModel * model,
			      GtkTreePath * path,
			      gboolean path_currently_selected,
			      gpointer data)
{
	GPerlCallback * callback = (GPerlCallback*)data;
	GValue value = {0,};
	gboolean retval;

	g_value_init (&value, callback->return_type);
	gperl_callback_invoke (callback, &value, selection, model, path,
			       path_currently_selected);
	retval = g_value_get_boolean (&value);
	g_value_unset (&value);

	return retval;
}


static GPerlCallback *
gtk2perl_tree_selection_foreach_func_create (SV * func, SV * data)
{
	GType param_types [] = {
		GTK_TYPE_TREE_MODEL,
		GTK_TYPE_TREE_PATH,
		GTK_TYPE_TREE_ITER
	};
	return gperl_callback_new (func, data, G_N_ELEMENTS (param_types),
				   param_types, 0);
}

static void
gtk2perl_tree_selection_foreach_func (GtkTreeModel * model,
				      GtkTreePath * path,
				      GtkTreeIter * iter,
				      gpointer data)
{
	gperl_callback_invoke ((GPerlCallback*)data, NULL, model, path, iter);
}

#if !GTK_CHECK_VERSION(2,2,0)
/* selected_foreach callbacks to implement get_selected_rows and 
 * count_selected_rows for gtk < 2.2 */
static void
get_selected_rows (GtkTreeModel * model,
                   GtkTreePath * path,
                   GtkTreeIter * iter,
                   GList ** paths)
{
	*paths = g_list_append (*paths, gtk_tree_path_copy (path));
}

static void
count_selected_rows (GtkTreeModel * model,
                     GtkTreePath * path,
                     GtkTreeIter * iter,
                     gint * n)
{
	++*n;
}
#endif /* <2.2.0 */

MODULE = Gtk2::TreeSelection	PACKAGE = Gtk2::TreeSelection	PREFIX = gtk_tree_selection_


## void gtk_tree_selection_set_mode (GtkTreeSelection *selection, GtkSelectionMode type)
void
gtk_tree_selection_set_mode (selection, type)
	GtkTreeSelection *selection
	GtkSelectionMode type

## GtkSelectionMode gtk_tree_selection_get_mode (GtkTreeSelection *selection)
GtkSelectionMode
gtk_tree_selection_get_mode (selection)
	GtkTreeSelection *selection

### void gtk_tree_selection_set_select_function (GtkTreeSelection *selection, GtkTreeSelectionFunc func, gpointer data, GtkDestroyNotify destroy)
void
gtk_tree_selection_set_select_function (selection, func, data=NULL)
	GtkTreeSelection *selection
	SV * func
	SV * data
    PREINIT:
	GPerlCallback * callback;
    CODE:
	callback = gtk2perl_tree_selection_func_create (func, data);
	gtk_tree_selection_set_select_function (selection,
						gtk2perl_tree_selection_func,
						callback,
						(GDestroyNotify) gperl_callback_destroy);

## FIXME eh? i thought GObject took care of this 
### gpointer gtk_tree_selection_get_user_data (GtkTreeSelection *selection)
#gpointer
#gtk_tree_selection_get_user_data (selection)
#	GtkTreeSelection *selection

## GtkTreeView* gtk_tree_selection_get_tree_view (GtkTreeSelection *selection)
GtkTreeView*
gtk_tree_selection_get_tree_view (selection)
	GtkTreeSelection *selection

### gboolean gtk_tree_selection_get_selected (GtkTreeSelection *selection, GtkTreeModel **model, GtkTreeIter *iter)
void
gtk_tree_selection_get_selected (selection)
	GtkTreeSelection *selection
    PREINIT:
	GtkTreeModel * model;
	GtkTreeIter iter = {0, };
    PPCODE:
	if (!gtk_tree_selection_get_selected (selection, &model, &iter))
		XSRETURN_EMPTY;
	if (GIMME_V == G_ARRAY)
		XPUSHs (sv_2mortal (newSVGtkTreeModel (model)));
	XPUSHs (sv_2mortal (newSVGtkTreeIter_copy (&iter)));

#if GTK_CHECK_VERSION(2,2,0)

## GList * gtk_tree_selection_get_selected_rows (GtkTreeSelection *selection, GtkTreeModel **model)
void
gtk_tree_selection_get_selected_rows (selection)
	GtkTreeSelection *selection
    PREINIT:
	GtkTreeModel * model = NULL;
	GList * list, * i;
    PPCODE:
	list = gtk_tree_selection_get_selected_rows (selection, &model);
	EXTEND (SP, (int)g_list_length (list));
	for (i = list ; i != NULL ; i = i->next)
		PUSHs (sv_2mortal (newSVGtkTreePath_own ((GtkTreePath*)i->data)));
	g_list_free (list);

## gint gtk_tree_selection_count_selected_rows (GtkTreeSelection *selection)
gint
gtk_tree_selection_count_selected_rows (selection)
	GtkTreeSelection *selection

#else

  ## these two are generally useful and very slow to implement in perl, so
  ## we'll be really nice and provide implementations for people stuck on
  ## gtk < 2.2.x

void
gtk_tree_selection_get_selected_rows (selection)
	GtkTreeSelection * selection
    PREINIT:
	GtkTreeView * view;
	GList * paths = NULL, * i;
    PPCODE:
	view = gtk_tree_selection_get_tree_view (selection);
	gtk_tree_selection_selected_foreach (selection,
					     (GtkTreeSelectionForeachFunc)
					       get_selected_rows, &paths);
	EXTEND (SP, g_list_length (paths));
	for (i = paths ; i != NULL ; i = i->next)
		PUSHs (sv_2mortal (newSVGtkTreePath_own ((GtkTreePath*)i->data)));
	g_list_free (paths);


gint
gtk_tree_selection_count_selected_rows (selection)
	GtkTreeSelection * selection
    CODE:
	RETVAL = 0;
	gtk_tree_selection_selected_foreach (selection, 
					     (GtkTreeSelectionForeachFunc)
					        count_selected_rows, &RETVAL);
    OUTPUT:
	RETVAL

#endif /* 2.2.0 */

### void gtk_tree_selection_selected_foreach (GtkTreeSelection *selection, GtkTreeSelectionForeachFunc func, gpointer data)
void
gtk_tree_selection_selected_foreach (selection, func, data=NULL)
	GtkTreeSelection *selection
	SV * func
	SV * data
    PREINIT:
	GPerlCallback * callback;
    CODE:
	callback = gtk2perl_tree_selection_foreach_func_create (func, data);
	gtk_tree_selection_selected_foreach (selection,
					     gtk2perl_tree_selection_foreach_func,
					     callback);
	gperl_callback_destroy (callback);

## void gtk_tree_selection_select_path (GtkTreeSelection *selection, GtkTreePath *path)
void
gtk_tree_selection_select_path (selection, path)
	GtkTreeSelection *selection
	GtkTreePath *path

## void gtk_tree_selection_unselect_path (GtkTreeSelection *selection, GtkTreePath *path)
void
gtk_tree_selection_unselect_path (selection, path)
	GtkTreeSelection *selection
	GtkTreePath *path

## void gtk_tree_selection_select_iter (GtkTreeSelection *selection, GtkTreeIter *iter)
void
gtk_tree_selection_select_iter (selection, iter)
	GtkTreeSelection *selection
	GtkTreeIter *iter

## void gtk_tree_selection_unselect_iter (GtkTreeSelection *selection, GtkTreeIter *iter)
void
gtk_tree_selection_unselect_iter (selection, iter)
	GtkTreeSelection *selection
	GtkTreeIter *iter

## gboolean gtk_tree_selection_path_is_selected (GtkTreeSelection *selection, GtkTreePath *path)
gboolean
gtk_tree_selection_path_is_selected (selection, path)
	GtkTreeSelection *selection
	GtkTreePath *path

## gboolean gtk_tree_selection_iter_is_selected (GtkTreeSelection *selection, GtkTreeIter *iter)
gboolean
gtk_tree_selection_iter_is_selected (selection, iter)
	GtkTreeSelection *selection
	GtkTreeIter *iter

## void gtk_tree_selection_select_all (GtkTreeSelection *selection)
void
gtk_tree_selection_select_all (selection)
	GtkTreeSelection *selection

## void gtk_tree_selection_unselect_all (GtkTreeSelection *selection)
void
gtk_tree_selection_unselect_all (selection)
	GtkTreeSelection *selection

## void gtk_tree_selection_select_range (GtkTreeSelection *selection, GtkTreePath *start_path, GtkTreePath *end_path)
void
gtk_tree_selection_select_range (selection, start_path, end_path)
	GtkTreeSelection *selection
	GtkTreePath *start_path
	GtkTreePath *end_path

#if GTK_CHECK_VERSION(2,2,0)

## void gtk_tree_selection_unselect_range (GtkTreeSelection *selection, GtkTreePath *start_path, GtkTreePath *end_path)
void
gtk_tree_selection_unselect_range (selection, start_path, end_path)
	GtkTreeSelection *selection
	GtkTreePath *start_path
	GtkTreePath *end_path

#endif /* >= 2.2.0 */
