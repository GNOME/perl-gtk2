/*
 * $Header$
 */

#include "gtk2perl.h"

MODULE = Gtk2::Statusbar	PACKAGE = Gtk2::Statusbar	PREFIX = gtk_statusbar_

## GtkWidget* gtk_statusbar_new (void)
GtkWidget *
gtk_statusbar_new (class)
	SV * class
    C_ARGS:

## void gtk_statusbar_pop (GtkStatusbar *statusbar, guint context_id)
void
gtk_statusbar_pop (statusbar, context_id)
	GtkStatusbar * statusbar
	guint          context_id

## void gtk_statusbar_remove (GtkStatusbar *statusbar, guint context_id, guint message_id)
void
gtk_statusbar_remove (statusbar, context_id, message_id)
	GtkStatusbar * statusbar
	guint          context_id
	guint          message_id

## void gtk_statusbar_set_has_resize_grip (GtkStatusbar *statusbar, gboolean setting)
void
gtk_statusbar_set_has_resize_grip (statusbar, setting)
	GtkStatusbar * statusbar
	gboolean       setting

## gboolean gtk_statusbar_get_has_resize_grip (GtkStatusbar *statusbar)
gboolean
gtk_statusbar_get_has_resize_grip (statusbar)
	GtkStatusbar * statusbar

##guint gtk_statusbar_get_context_id (GtkStatusbar *statusbar, const gchar *context_description)
guint
gtk_statusbar_get_context_id (statusbar, context_description)
	GtkStatusbar * statusbar
	gchar        * context_description

##guint gtk_statusbar_push (GtkStatusbar *statusbar, guint context_id, const gchar *text)
guint
gtk_statusbar_push (statusbar, context_id, text)
	GtkStatusbar * statusbar
	guint          context_id
	gchar        * text

