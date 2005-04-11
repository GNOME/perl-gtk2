/*
 * Copyright (c) 2004-2005 by the gtk2-perl team (see the file AUTHORS)
 *
 * Licensed under the LGPL, see LICENSE file for more information.
 *
 * $Header$
 */
#include "gtk2perl.h"

static GPerlCallback *
gtk2perl_icon_view_foreach_func_create (SV * func, SV * data)
{
	GType param_types [2];
	param_types[0] = GTK_TYPE_ICON_VIEW;
	param_types[1] = GTK_TYPE_TREE_PATH;
	return gperl_callback_new (func, data, G_N_ELEMENTS (param_types),
				   param_types, G_TYPE_NONE);
}
static void
gtk2perl_icon_view_foreach_func (GtkIconView      *icon_view,
				 GtkTreePath      *path,
				 gpointer          data)
{
	gperl_callback_invoke ((GPerlCallback*) data, NULL, icon_view, path);
}


MODULE = Gtk2::IconView PACKAGE = Gtk2::IconView PREFIX = gtk_icon_view_

GtkWidget * gtk_icon_view_new (class)
    C_ARGS:
	/* void */

GtkWidget * gtk_icon_view_new_with_model (class, model)
	GtkTreeModel * model
    C_ARGS:
	model

void gtk_icon_view_set_model (GtkIconView * icon_view, GtkTreeModel * model);

GtkTreeModel * gtk_icon_view_get_model (GtkIconView * icon_view);

void gtk_icon_view_set_text_column (GtkIconView * icon_view, gint column);

gint gtk_icon_view_get_text_column (GtkIconView * icon_view);

void gtk_icon_view_set_markup_column (GtkIconView * icon_view, gint column);

gint gtk_icon_view_get_markup_column (GtkIconView * icon_view);

void gtk_icon_view_set_pixbuf_column (GtkIconView * icon_view, gint column);

gint gtk_icon_view_get_pixbuf_column (GtkIconView * icon_view);

void gtk_icon_view_set_orientation (GtkIconView * icon_view, GtkOrientation orientation);

GtkOrientation gtk_icon_view_get_orientation (GtkIconView * icon_view);

GtkTreePath_own * gtk_icon_view_get_path_at_pos (GtkIconView * icon_view, gint x, gint y);

## void gtk_icon_view_selected_foreach (GtkIconView * icon_view, GtkIconViewForeachFunc func, gpointer data);
void
gtk_icon_view_selected_foreach (GtkIconView * icon_view, SV * func, SV * data=NULL);
    PREINIT:
	GPerlCallback * callback;
    CODE:
	callback = gtk2perl_icon_view_foreach_func_create (func, data);
	gtk_icon_view_selected_foreach (icon_view,
					gtk2perl_icon_view_foreach_func,
					callback);
	gperl_callback_destroy (callback);


void gtk_icon_view_set_selection_mode (GtkIconView * icon_view, GtkSelectionMode mode);

GtkSelectionMode gtk_icon_view_get_selection_mode (GtkIconView * icon_view);

void gtk_icon_view_select_path (GtkIconView * icon_view, GtkTreePath * path);

void gtk_icon_view_unselect_path (GtkIconView * icon_view, GtkTreePath * path);

gboolean gtk_icon_view_path_is_selected (GtkIconView * icon_view, GtkTreePath * path);

## GList * gtk_icon_view_get_selected_items (GtkIconView * icon_view);
void
gtk_icon_view_get_selected_items (GtkIconView * icon_view)
    PREINIT:
	GList * list;
    PPCODE:
	list = gtk_icon_view_get_selected_items (icon_view);
	if (list)
	{
		GList * curr;

		for (curr = list; curr; curr = g_list_next (curr))
			XPUSHs (sv_2mortal (newSVGtkTreePath (curr->data)));

		g_list_foreach (list, (GFunc)gtk_tree_path_free, NULL);
		g_list_free (list);
	}
	else
		XSRETURN_EMPTY;

void gtk_icon_view_select_all (GtkIconView * icon_view);

void gtk_icon_view_unselect_all (GtkIconView * icon_view);

void gtk_icon_view_item_activated (GtkIconView * icon_view, GtkTreePath * path);
