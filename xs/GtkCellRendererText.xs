/*
 * $Header$
 */

#include "gtk2perl.h"

MODULE = Gtk2::CellRendererText	PACKAGE = Gtk2::CellRendererText	PREFIX = gtk_cell_renderer_text_

##GtkWidget* gtk_cell_renderer_text_new (void);
GtkCellRenderer *
gtk_cell_renderer_text_new (class)
	SV * class
    C_ARGS:

## void gtk_cell_renderer_text_set_fixed_height_from_font (GtkCellRendererText *renderer, gint number_of_rows)
void
gtk_cell_renderer_text_set_fixed_height_from_font (renderer, number_of_rows)
	GtkCellRendererText * renderer
	gint                  number_of_rows

