/*
 * $Header$
 */

#include "gtk2perl.h"

/*
this is an interface
*/

MODULE = Gtk2::CellEditable	PACKAGE = Gtk2::CellEditable	PREFIX = gtk_cell_editable_

## void gtk_cell_editable_start_editing (GtkCellEditable *cell_editable, GdkEvent *event)
void
gtk_cell_editable_start_editing (cell_editable, event)
	GtkCellEditable *cell_editable
	GdkEvent *event

## void gtk_cell_editable_editing_done (GtkCellEditable *cell_editable)
void
gtk_cell_editable_editing_done (cell_editable)
	GtkCellEditable *cell_editable

## void gtk_cell_editable_remove_widget (GtkCellEditable *cell_editable)
void
gtk_cell_editable_remove_widget (cell_editable)
	GtkCellEditable *cell_editable

