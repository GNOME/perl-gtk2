/*
 * $Header$
 */

#include "gtk2perl.h"

MODULE = Gtk2::CellRendererToggle	PACKAGE = Gtk2::CellRendererToggle	PREFIX = gtk_cell_renderer_toggle_

GtkCellRenderer *
gtk_cell_renderer_toggle_new (class)
	SV * class
    C_ARGS:

## gboolean gtk_cell_renderer_toggle_get_radio (GtkCellRendererToggle *toggle)
gboolean
gtk_cell_renderer_toggle_get_radio (toggle)
	GtkCellRendererToggle * toggle

## void gtk_cell_renderer_toggle_set_radio (GtkCellRendererToggle *toggle, gboolean radio)
void
gtk_cell_renderer_toggle_set_radio (toggle, radio)
	GtkCellRendererToggle * toggle
	gboolean                radio

## gboolean gtk_cell_renderer_toggle_get_active (GtkCellRendererToggle *toggle)
gboolean
gtk_cell_renderer_toggle_get_active (toggle)
	GtkCellRendererToggle * toggle

## void gtk_cell_renderer_toggle_set_active (GtkCellRendererToggle *toggle, gboolean setting)
void
gtk_cell_renderer_toggle_set_active (toggle, setting)
	GtkCellRendererToggle * toggle
	gboolean                setting

