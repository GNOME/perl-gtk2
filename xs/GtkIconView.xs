#include "gtk2perl.h"

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

## TODO/FIXME: 
## void gtk_icon_view_selected_foreach (GtkIconView * icon_view, GtkIconViewForeachFunc func, gpointer data);

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
