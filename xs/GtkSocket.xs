/*
 * $Header$
 */

#include "gtk2perl.h"

MODULE = Gtk2::Socket	PACKAGE = Gtk2::Socket	PREFIX = gtk_socket_

## GtkWidget* gtk_socket_new (void)
GtkWidget *
gtk_socket_new (class)
	SV * class
    C_ARGS:

## void gtk_socket_add_id (GtkSocket *socket, GdkNativeWindow window_id)
void
gtk_socket_add_id (socket, window_id)
	GtkSocket       * socket
	GdkNativeWindow   window_id

## GdkNativeWindow gtk_socket_get_id (GtkSocket *socket)
GdkNativeWindow
gtk_socket_get_id (socket)
	GtkSocket * socket

## void gtk_socket_steal (GtkSocket *socket, GdkNativeWindow wid)
void
gtk_socket_steal (socket, wid)
	GtkSocket       * socket
	GdkNativeWindow   wid

