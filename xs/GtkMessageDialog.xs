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

#include "gtk2perl.h"
#include "ppport.h"

MODULE = Gtk2::MessageDialog	PACKAGE = Gtk2::MessageDialog	PREFIX = gtk_message_dialog_

=for apidoc
=for args format a printf format specifier.  may be undef.
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
	SV * format
    CODE:
	if (format && SvOK (format)) {
		/* text passed to GTK+ must be UTF-8.  force it. */
		STRLEN patlen;
		gchar * pat;
		SV * message = newSV (0);
		SvUTF8_on (message);
		sv_utf8_upgrade (format);
		pat = SvPV (format, patlen);
		sv_vsetpvfn (message, pat, patlen,
		             NULL, &(ST (6)), items - 6, Null(bool*));
		/* the double-indirection is necessary to avoid % chars in the
		 * message string being misinterpreted. */
		RETVAL = gtk_message_dialog_new (parent, flags, type, buttons,
	                                         "%s", SvPV_nolen (message));
	} else
		RETVAL = gtk_message_dialog_new (parent, flags, type,
		                                 buttons, NULL);
		/* -Wall warns about the NULL format string here, but
		 * gtk_message_dialog_new() explicitly allows it. */
    OUTPUT:
	RETVAL
