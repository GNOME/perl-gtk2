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

MODULE = Gtk2::TextTag	PACKAGE = Gtk2::TextTag	PREFIX = gtk_text_tag_


#### FIXME name may be NULL... need a gchar_ornull typemap
GtkTextTag_noinc *
gtk_text_tag_new (class, name)
	SV * class
	const gchar * name
    C_ARGS:
	name
    CLEANUP:
	UNUSED(class);

gint
gtk_text_tag_get_priority (tag)
	GtkTextTag *tag

void
gtk_text_tag_set_priority (tag, priority)
	GtkTextTag *tag
	gint priority

## gboolean gtk_text_tag_event (GtkTextTag *tag, GObject *event_object, GdkEvent *event, const GtkTextIter *iter)
gboolean
gtk_text_tag_event (tag, event_object, event, iter)
	GtkTextTag *tag
	GObject *event_object
	GdkEvent *event
	GtkTextIter *iter

MODULE = Gtk2::TextTag	PACKAGE = Gtk2::TextAttributes	PREFIX = gtk_text_attributes_

## GtkTextAttributes* gtk_text_attributes_new (void)
GtkTextAttributes_own *
gtk_text_attributes_new (class)
	SV * class
    C_ARGS:
	/* void */
    CLEANUP:
	UNUSED(class);

GtkTextAttributes_own*
gtk_text_attributes_copy (src)
	GtkTextAttributes *src

## void gtk_text_attributes_copy_values (GtkTextAttributes *src, GtkTextAttributes *dest)
### swapping the order of these, because i think the method is pulling the
### parameters from another object; as a method, you modify yourself, not
### somebody else.
void
gtk_text_attributes_copy_values (dest, src)
	GtkTextAttributes *dest
	GtkTextAttributes *src
    C_ARGS:
	src, dest

#### void gtk_text_attributes_unref (GtkTextAttributes *values)
#### void gtk_text_attributes_ref (GtkTextAttributes *values)
