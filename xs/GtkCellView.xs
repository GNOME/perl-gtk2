#include "gtk2perl.h"

MODULE = Gtk2::CellView PACKAGE = Gtk2::CellView PREFIX = gtk_cell_view_

GtkWidget * gtk_cell_view_new (class)
    C_ARGS:
	/* void */

GtkWidget * gtk_cell_view_new_with_text (class, text)
	const gchar * text
    C_ARGS:
	text

GtkWidget * gtk_cell_view_new_with_markup (class, markup)
	const gchar * markup
    C_ARGS:
	markup

GtkWidget * gtk_cell_view_new_with_pixbuf (class, pixbuf)
	GdkPixbuf * pixbuf
    C_ARGS:
	pixbuf

## TODO/FIXME: 
## void gtk_cell_view_set_value (GtkCellView * cell_view, GtkCellRenderer * renderer, gchar * property, GValue * value);
##void gtk_cell_view_set_values (GtkCellView * cell_view, GtkCellRenderer * renderer, ...);

void gtk_cell_view_set_model (GtkCellView * cell_view, GtkTreeModel * model);

void gtk_cell_view_set_displayed_row (GtkCellView * cell_view, GtkTreePath * path);

GtkTreePath_own * gtk_cell_view_get_displayed_row (GtkCellView * cell_view);

## TODO/FIXME: what's this func supposed to do, is req an output param, is boolean ret needed then.
## gboolean gtk_cell_view_get_size_of_row (GtkCellView * cell_view, GtkTreePath * path, GtkRequisition * requisition);

void gtk_cell_view_set_background_color (GtkCellView * cell_view, const GdkColor * color);

void gtk_cell_view_set_cell_data (GtkCellView * cellview);

## GList * gtk_cell_view_get_cell_renderers (GtkCellView * cellview);
void
gtk_cell_view_get_cell_renderers (GtkCellView * cellview);
    PREINIT:
	GList * list;
    PPCODE:
	list = gtk_cell_view_get_cell_renderers (cellview);
	if (list)
	{
		GList * curr;
		
		for (curr = list; curr; curr = g_list_next (curr))
			XPUSHs (sv_2mortal (newSVGtkCellRenderer (curr->data)));
		
		g_list_free (list);
	}
	else
		XSRETURN_EMPTY;
