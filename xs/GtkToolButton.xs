#include "gtk2perl.h"

MODULE = Gtk2::ToolButton PACKAGE = Gtk2::ToolButton PREFIX = gtk_tool_button_

GtkToolItem *gtk_tool_button_new (class, GtkWidget *icon_widget, const gchar *label);
    C_ARGS:
	icon_widget, label

GtkToolItem *gtk_tool_button_new_from_stock (class, const gchar *stock_id);
    C_ARGS:
	stock_id


void gtk_tool_button_set_label (GtkToolButton *button, const gchar *label);

 ##G_CONST_RETURN
const gchar *gtk_tool_button_get_label (GtkToolButton *button);

void gtk_tool_button_set_use_underline (GtkToolButton *button, gboolean use_underline);

gboolean gtk_tool_button_get_use_underline (GtkToolButton *button);

void gtk_tool_button_set_stock_id (GtkToolButton *button, const gchar *stock_id);

 ##G_CONST_RETURN 
const gchar *gtk_tool_button_get_stock_id (GtkToolButton *button);

void gtk_tool_button_set_icon_widget (GtkToolButton *button, GtkWidget *icon_widget);

GtkWidget * gtk_tool_button_get_icon_widget (GtkToolButton *button);

void gtk_tool_button_set_label_widget (GtkToolButton *button, GtkWidget *label_widget);

GtkWidget * gtk_tool_button_get_label_widget (GtkToolButton *button);


