#include "gtk2perl.h"

MODULE = Gtk2::RadioToolButton PACKAGE = Gtk2::RadioToolButton PREFIX = gtk_radio_tool_button_

#### FIXME this needs an implementation for button groups like what GtkRadioButton has
##
##GtkToolItem *gtk_radio_tool_button_new (GSList *group);
##
##GtkToolItem *gtk_radio_tool_button_new_from_stock (GSList *group, const gchar *stock_id);

GtkToolItem *gtk_radio_tool_button_new_from_widget (class, GtkWidget_ornull *group);
    C_ARGS:
	group

GtkToolItem *gtk_radio_tool_button_new_with_stock_from_widget (class, GtkWidget_ornull *group, const gchar *stock_id);
    C_ARGS:
	group, stock_id

##GSList * gtk_radio_tool_button_get_group (GtkRadioToolButton *button);
##
##void gtk_radio_tool_button_set_group (GtkRadioToolButton *button, GSList *group);

