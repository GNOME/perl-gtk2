/*
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
##void
##gtk_text_attributes_unref (values)
##	GtkTextAttributes *values
##
#### void gtk_text_attributes_ref (GtkTextAttributes *values)
##void
##gtk_text_attributes_ref (values)
##	GtkTextAttributes *values
##
