/*
 * $Header$
 */

#include "../gtk2perl.h"
#include "../ppport.h"

MODULE = Gtk2::MessageDialog	PACKAGE = Gtk2::MessageDialog	PREFIX = gtk_message_dialog_

GtkWidget *
gtk_message_dialog_new (class, parent, flags, type, buttons, message)
	SV * class
	GtkWindow_ornull * parent
	GtkDialogFlags flags
	GtkMessageType type
	GtkButtonsType buttons
	char * message
    C_ARGS:
	parent, flags, type, buttons, message
