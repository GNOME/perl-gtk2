/*
 * Copyright (c) 2003-2006 by the gtk2-perl team (see the file AUTHORS)
 *
 * Licensed under the LGPL, see LICENSE file for more information.
 *
 * $Header$
 */

#include "gtk2perl.h"

MODULE = Gtk2::Action	PACKAGE = Gtk2::Action	PREFIX = gtk_action_

const gchar* gtk_action_get_name (GtkAction *action);

void gtk_action_activate (GtkAction *action);

gboolean gtk_action_is_sensitive (GtkAction *action);

gboolean gtk_action_get_sensitive (GtkAction *action);

gboolean gtk_action_is_visible (GtkAction *action);

gboolean gtk_action_get_visible (GtkAction *action);

GtkWidget* gtk_action_create_icon (GtkAction *action, GtkIconSize icon_size);

GtkWidget* gtk_action_create_menu_item (GtkAction *action);

#if GTK_CHECK_VERSION (2, 12, 0)

GtkWidget* gtk_action_create_menu (GtkAction *action);

#endif

GtkWidget* gtk_action_create_tool_item (GtkAction *action);

void gtk_action_connect_proxy (GtkAction *action, GtkWidget *proxy);

void gtk_action_disconnect_proxy (GtkAction *action, GtkWidget *proxy);

void gtk_action_get_proxies (GtkAction *action);
    PREINIT:
	GSList * i;
    PPCODE:
	for (i = gtk_action_get_proxies (action) ; i != NULL ; i = i->next)
		XPUSHs (sv_2mortal (newSVGtkWidget (i->data)));

void gtk_action_connect_accelerator (GtkAction *action);

void gtk_action_disconnect_accelerator (GtkAction *action);

## /* protected ... for use by child actions */
void gtk_action_block_activate_from (GtkAction *action, GtkWidget *proxy);

void gtk_action_unblock_activate_from (GtkAction *action, GtkWidget *proxy);

## /* protected ... for use by action groups */
void gtk_action_set_accel_path (GtkAction *action, const gchar *accel_path);

void gtk_action_set_accel_group (GtkAction *action, GtkAccelGroup_ornull *accel_group);

#if GTK_CHECK_VERSION (2, 6, 0)

void gtk_action_set_sensitive (GtkAction *action, gboolean sensitive);

void gtk_action_set_visible (GtkAction *action, gboolean visible);

const gchar* gtk_action_get_accel_path (GtkAction *action);

#endif

#if GTK_CHECK_VERSION (2, 10, 0)

MODULE = Gtk2::Action	PACKAGE = Gtk2::Widget	PREFIX = gtk_widget_

GtkAction_ornull * gtk_widget_get_action (GtkWidget *widget);

#endif
