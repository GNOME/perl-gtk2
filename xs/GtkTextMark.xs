/*
 * $Header$
 */

#include "gtk2perl.h"

MODULE = Gtk2::TextMark	PACKAGE = Gtk2::TextMark	PREFIX = gtk_text_mark_

## void gtk_text_mark_set_visible (GtkTextMark *mark, gboolean setting)
void
gtk_text_mark_set_visible (mark, setting)
	GtkTextMark *mark
	gboolean setting

## gboolean gtk_text_mark_get_visible (GtkTextMark *mark)
gboolean
gtk_text_mark_get_visible (mark)
	GtkTextMark *mark

## gboolean gtk_text_mark_get_deleted (GtkTextMark *mark)
gboolean
gtk_text_mark_get_deleted (mark)
	GtkTextMark *mark

## gchar* gtk_text_mark_get_name (GtkTextMark *mark);
const gchar *
gtk_text_mark_get_name (mark)
	GtkTextMark * mark

## GtkTextBuffer* gtk_text_mark_get_buffer (GtkTextMark *mark)
GtkTextBuffer*
gtk_text_mark_get_buffer (mark)
	GtkTextMark *mark

## gboolean gtk_text_mark_get_left_gravity (GtkTextMark *mark)
gboolean
gtk_text_mark_get_left_gravity (mark)
	GtkTextMark *mark

