/*
 * Copyright (c) 2003 by the gtk2-perl team (see the file AUTHORS)
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Library General Public
 * License as published by the Free Software Foundation; either
 * version 2.1 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Library General Public License for more details.
 *
 * You should have received a copy of the GNU Library General Public
 * License along with this library; if not, write to the 
 * Free Software Foundation, Inc., 59 Temple Place - Suite 330, 
 * Boston, MA  02111-1307  USA.
 *
 * $Header$
 */

#include "../gtk2perl.h"
#include "../ppport.h"

MODULE = Gtk2::MessageDialog	PACKAGE = Gtk2::MessageDialog	PREFIX = gtk_message_dialog_

=for apidoc
=for args format a printf format specifier
=for args ... arguments for I<$format>
Create a new Gtk2::Dialog with a simple message.  It will also include an
icon, as determined by I<$type>.  If you need buttons not available through
Gtk2::ButtonsType, use 'none' and add buttons with C<< $dialog->add_buttons >>.
=cut
GtkWidget *
gtk_message_dialog_new (class, parent, flags, type, buttons, format, ...)
	GtkWindow_ornull * parent
	GtkDialogFlags flags
	GtkMessageType type
	GtkButtonsType buttons
	guchar * format
    PREINIT:
	SV * message;
    CODE:
	message = newSV (0);
	sv_vsetpvfn (message, format, SvLEN (ST (5)),
	             NULL, &(ST (6)), items - 6, Null(bool*));
	RETVAL = gtk_message_dialog_new (parent, flags, type, buttons,
	                                 "%s", SvGChar (message));
    OUTPUT:
	RETVAL

#if GTK_CHECK_VERSION(2,3,0)

=for apidoc
=for arg message a string containing Pango markup
Like C<new>, but allowing Pango markup tags in the message.  Note that this
version is not variadic.
=cut
GtkWidget *
gtk_message_dialog_new_with_markup (class, parent, flags, type, buttons, message)
	GtkWindow_ornull * parent
	GtkDialogFlags flags
	GtkMessageType type
	GtkButtonsType buttons
	gchar * message
    CODE:
	RETVAL = gtk_message_dialog_new (parent, flags, type, buttons, NULL);
	gtk_message_dialog_set_markup (GTK_MESSAGE_DIALOG (RETVAL), message);
    OUTPUT:
	RETVAL

void
gtk_message_dialog_set_markup (GtkMessageDialog *message_dialog, const gchar *str)

#endif
