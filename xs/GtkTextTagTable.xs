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

static void
foreach_callback (GtkTextTag *tag,
                  GPerlCallback *callback)
{
	gperl_callback_invoke (callback, NULL, tag);
}

MODULE = Gtk2::TextTagTable	PACKAGE = Gtk2::TextTagTable	PREFIX = gtk_text_tag_table_

GtkTextTagTable_noinc *
gtk_text_tag_table_new (class)
	SV * class
    C_ARGS:
	/* void */
    CLEANUP:
	UNUSED(class);

void
gtk_text_tag_table_add (table, tag)
	GtkTextTagTable *table
	GtkTextTag *tag

void
gtk_text_tag_table_remove (table, tag)
	GtkTextTagTable *table
	GtkTextTag *tag

GtkTextTag *
gtk_text_tag_table_lookup (table, name)
	GtkTextTagTable * table
        const gchar * name

void
gtk_text_tag_table_foreach (table, callback, callback_data=NULL)
	GtkTextTagTable * table
        SV * callback
        SV * callback_data
    PREINIT:
	GPerlCallback * real_callback;
	GType param_types [] = { GTK_TYPE_TEXT_TAG };
    CODE:
	real_callback = gperl_callback_new (callback, callback_data,
	                                    1, param_types, G_TYPE_NONE);
	gtk_text_tag_table_foreach (table, 
	                       (GtkTextTagTableForeach) foreach_callback,
	                       real_callback);
	gperl_callback_destroy (real_callback);

gint
gtk_text_tag_table_get_size (table)
	GtkTextTagTable * table

