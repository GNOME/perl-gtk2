#include "gtk2perl.h"

MODULE = Gtk2::SeparatorToolItem PACKAGE = Gtk2::SeparatorToolItem PREFIX = gtk_separator_tool_item_

GtkToolItem *gtk_separator_tool_item_new (class);
    C_ARGS:
	/*void*/

gboolean gtk_separator_tool_item_get_draw (GtkSeparatorToolItem *item);

void gtk_separator_tool_item_set_draw (GtkSeparatorToolItem *tool_item, gboolean draw);
