#include "gtk2perl.h"

MODULE = Gtk2::Plug	PACKAGE = Gtk2::Plug	PREFIX = gtk_plug_

## void gtk_plug_construct (GtkPlug *plug, GdkNativeWindow socket_id)
void
gtk_plug_construct (plug, socket_id)
	GtkPlug         * plug
	GdkNativeWindow   socket_id

# for 2.2 compat this function needs to be updated to include
# the for_display version
## GtkWidget* gtk_plug_new (GdkNativeWindow socket_id)
GtkWidget *
gtk_plug_new (class, socket_id)
	SV              * class
	GdkNativeWindow   socket_id
    C_ARGS:
	socket_id

##if GTK_CHECK_VERSION(2,2,0)
#
##GtkWidget * gtk_plug_new_for_display (GdkDisplay *display, GdkNativeWindow socket_id)
#GtkWidget *
#gtk_plug_new_for_display (display, socket_id)
#	GdkDisplay *display
#	GdkNativeWindow socket_id
#
### void gtk_plug_construct (GtkPlug *plug, GdkNativeWindow socket_id)
#void
#gtk_plug_construct_for_display (plug, socket_id)
#	GtkPlug         * plug
#	GdkDisplay      * display
#	GdkNativeWindow   socket_id
#
##endif

## GdkNativeWindow gtk_plug_get_id (GtkPlug *plug)
GdkNativeWindow
gtk_plug_get_id (plug)
	GtkPlug * plug

## void _gtk_plug_add_to_socket (GtkPlug *plug, GtkSocket *socket)
#void
#_gtk_plug_add_to_socket (plug, socket)
#	GtkPlug   * plug
#	GtkSocket * socket

## void _gtk_plug_remove_from_socket (GtkPlug *plug, GtkSocket *socket)
#void
#_gtk_plug_remove_from_socket (plug, socket)
#	GtkPlug   * plug
#	GtkSocket * socket

