/*
 * Copyright (c) 2003 by the gtk2-perl team (see the file AUTHORS)
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Library General Public
 * License as published by the Free Software Foundation; either
 * version 2 of the License, or (at your option) any later version.
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

MODULE = Gtk2::Editable	PACKAGE = Gtk2::Editable	PREFIX = gtk_editable_

void
gtk_editable_select_region (editable, start, end)
	GtkEditable *editable
	gint start
	gint end


 ## returns an empty list if there is no selection

void
gtk_editable_get_selection_bounds (editable)
	GtkEditable *editable
    PREINIT:
	gint start;
	gint end;
    PPCODE:
	if (!gtk_editable_get_selection_bounds (editable, &start, &end))
		XSRETURN_EMPTY;
	EXTEND (SP, 2);
	PUSHs (sv_2mortal (newSViv (start)));
	PUSHs (sv_2mortal (newSViv (end)));

 ## returns position of next char after inserted text
gint
gtk_editable_insert_text (editable, new_text, new_text_length, position)
	GtkEditable *editable
	const gchar *new_text
	gint new_text_length
	gint position
    CODE:
	gtk_editable_insert_text (editable, new_text,
				  new_text_length, &position);
	RETVAL = position;
    OUTPUT:
	RETVAL

void
gtk_editable_delete_text (editable, start_pos, end_pos)
	GtkEditable *editable
	gint start_pos
	gint end_pos

gchar*
gtk_editable_get_chars (editable, start_pos, end_pos)
	GtkEditable *editable
	gint start_pos
	gint end_pos

void
gtk_editable_cut_clipboard (editable)
	GtkEditable *editable

void
gtk_editable_copy_clipboard (editable)
	GtkEditable *editable

void
gtk_editable_paste_clipboard (editable)
	GtkEditable *editable

void
gtk_editable_delete_selection (editable)
	GtkEditable *editable

void
gtk_editable_set_position (editable, position)
	GtkEditable *editable
	gint position

gint
gtk_editable_get_position (editable)
	GtkEditable *editable

void
gtk_editable_set_editable (editable, is_editable)
	GtkEditable *editable
	gboolean is_editable

gboolean
gtk_editable_get_editable (editable)
	GtkEditable *editable

