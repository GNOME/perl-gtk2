#include "gtk2perl.h"

MODULE = Gtk2::Action	PACKAGE = Gtk2::Action	PREFIX = gtk_action_

const gchar* gtk_action_get_name (GtkAction *action);

void gtk_action_activate (GtkAction *action);

GtkWidget* gtk_action_create_icon (GtkAction *action, GtkIconSize icon_size);

GtkWidget* gtk_action_create_menu_item (GtkAction *action);

GtkWidget* gtk_action_create_tool_item (GtkAction *action);

void gtk_action_connect_proxy (GtkAction *action, GtkWidget *proxy);

void gtk_action_disconnect_proxy (GtkAction *action, GtkWidget *proxy);

void gtk_action_get_proxies (GtkAction *action);
    PREINIT:
	GSList * i;
	PPCODE:
	i = gtk_action_get_proxies (action);
	for ( ; i != NULL ; i = i->next)
		XPUSHs (sv_2mortal (newSVGtkWidget (i->data)));

void gtk_action_connect_accelerator (GtkAction *action);

void gtk_action_disconnect_accelerator (GtkAction *action);

## /* protected ... for use by child actions */
void gtk_action_block_activate_from (GtkAction *action, GtkWidget *proxy);

void gtk_action_unblock_activate_from (GtkAction *action, GtkWidget *proxy);

## /* protected ... for use by action groups */
void gtk_action_set_accel_path (GtkAction *action, const gchar *accel_path);

void gtk_action_set_accel_group (GtkAction *action, GtkAccelGroup *accel_group);

