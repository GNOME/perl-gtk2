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

MODULE = Gtk2::ColorSelectionDialog	PACKAGE = Gtk2::ColorSelectionDialog	PREFIX = gtk_color_selection_dialog_


GtkWidget *
colorsel (dialog)
	GtkColorSelectionDialog *dialog
    ALIAS:
	ok_button = 1
	cancel_button = 2
	help_button = 3
    CODE:
	RETVAL = NULL;
	switch (ix) {
		case 0: RETVAL = dialog->colorsel; break;
		case 1: RETVAL = dialog->ok_button; break;
		case 2: RETVAL = dialog->cancel_button; break;
		case 3: RETVAL = dialog->help_button; break;
	}
    OUTPUT:
	RETVAL


## GtkWidget* gtk_color_selection_dialog_new (const gchar *title)
GtkWidget *
gtk_color_selection_dialog_new (class, title)
	const gchar * title
    C_ARGS:
	title

