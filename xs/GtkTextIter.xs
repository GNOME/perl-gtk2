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

MODULE = Gtk2::TextIter	PACKAGE = Gtk2::TextIter	PREFIX = gtk_text_iter_

GtkTextBuffer*
gtk_text_iter_get_buffer (iter)
	GtkTextIter * iter

## GtkTextIter* gtk_text_iter_copy (const GtkTextIter *iter);
GtkTextIter_own*
gtk_text_iter_copy (iter)
	GtkTextIter *iter

## perl doesn't need to know about gtk_text_iter_free

## gint gtk_text_iter_get_offset (const GtkTextIter *iter)
gint
gtk_text_iter_get_offset (iter)
	GtkTextIter *iter

## gint gtk_text_iter_get_line (const GtkTextIter *iter)
gint
gtk_text_iter_get_line (iter)
	GtkTextIter *iter

## gint gtk_text_iter_get_line_offset (const GtkTextIter *iter)
gint
gtk_text_iter_get_line_offset (iter)
	GtkTextIter *iter

## gint gtk_text_iter_get_line_index (const GtkTextIter *iter)
gint
gtk_text_iter_get_line_index (iter)
	GtkTextIter *iter

## gint gtk_text_iter_get_visible_line_offset (const GtkTextIter *iter)
gint
gtk_text_iter_get_visible_line_offset (iter)
	GtkTextIter *iter

## gint gtk_text_iter_get_visible_line_index (const GtkTextIter *iter)
gint
gtk_text_iter_get_visible_line_index (iter)
	 GtkTextIter *iter

## FIXME need gunichar typemap
### gunichar gtk_text_iter_get_char (const GtkTextIter *iter)
#gunichar
#gtk_text_iter_get_char (iter)
#	GtkTextIter *iter

gchar_own *
gtk_text_iter_get_slice (start, end)
	GtkTextIter * start
	GtkTextIter * end

gchar_own *
gtk_text_iter_get_text (start, end)
	GtkTextIter * start
	GtkTextIter * end

gchar_own * gtk_text_iter_get_visible_slice (GtkTextIter *start, GtkTextIter *end)

gchar_own * gtk_text_iter_get_visible_text (GtkTextIter *start, GtkTextIter *end)

## GdkPixbuf* gtk_text_iter_get_pixbuf (const GtkTextIter *iter)
GdkPixbuf_ornull*
gtk_text_iter_get_pixbuf (iter)
	GtkTextIter *iter

# FIXME needs list handling
### GSList * gtk_text_iter_get_marks (const GtkTextIter *iter)
#GSList *
#gtk_text_iter_get_marks (iter)
#	const GtkTextIter *iter

# FIXME needs list handling
## GSList* gtk_text_iter_get_toggled_tags  (const GtkTextIter *iter, gboolean toggled_on)

## GtkTextChildAnchor* gtk_text_iter_get_child_anchor (const GtkTextIter *iter)
GtkTextChildAnchor_ornull*
gtk_text_iter_get_child_anchor (iter)
	GtkTextIter *iter

## gboolean gtk_text_iter_begins_tag (const GtkTextIter *iter, GtkTextTag *tag)
gboolean
gtk_text_iter_begins_tag (iter, tag)
	GtkTextIter *iter
	GtkTextTag_ornull *tag

## gboolean gtk_text_iter_ends_tag (const GtkTextIter *iter, GtkTextTag *tag)
gboolean
gtk_text_iter_ends_tag (iter, tag)
	GtkTextIter *iter
	GtkTextTag_ornull *tag

## gboolean gtk_text_iter_toggles_tag (const GtkTextIter *iter, GtkTextTag *tag)
gboolean
gtk_text_iter_toggles_tag (iter, tag)
	GtkTextIter *iter
	GtkTextTag_ornull *tag

## gboolean gtk_text_iter_has_tag (const GtkTextIter *iter, GtkTextTag *tag)
gboolean
gtk_text_iter_has_tag (iter, tag)
	GtkTextIter *iter
	GtkTextTag *tag

# FIXME needs list handling
### GSList* gtk_text_iter_get_tags (const GtkTextIter *iter)

## gboolean gtk_text_iter_editable (const GtkTextIter *iter, gboolean default_setting)
gboolean
gtk_text_iter_editable (iter, default_setting)
	GtkTextIter *iter
	gboolean default_setting

## gboolean gtk_text_iter_can_insert (const GtkTextIter *iter, gboolean default_editability)
gboolean
gtk_text_iter_can_insert (iter, default_editability)
	GtkTextIter *iter
	gboolean default_editability

## gboolean gtk_text_iter_starts_word (const GtkTextIter *iter)
gboolean
gtk_text_iter_starts_word (iter)
	GtkTextIter *iter

## gboolean gtk_text_iter_ends_word (const GtkTextIter *iter)
gboolean
gtk_text_iter_ends_word (iter)
	GtkTextIter *iter

## gboolean gtk_text_iter_inside_word (const GtkTextIter *iter)
gboolean
gtk_text_iter_inside_word (iter)
	GtkTextIter *iter

## gboolean gtk_text_iter_starts_sentence (const GtkTextIter *iter)
gboolean
gtk_text_iter_starts_sentence (iter)
	GtkTextIter *iter

## gboolean gtk_text_iter_ends_sentence (const GtkTextIter *iter)
gboolean
gtk_text_iter_ends_sentence (iter)
	GtkTextIter *iter

## gboolean gtk_text_iter_inside_sentence (const GtkTextIter *iter)
gboolean
gtk_text_iter_inside_sentence (iter)
	GtkTextIter *iter

## gboolean gtk_text_iter_starts_line (const GtkTextIter *iter)
gboolean
gtk_text_iter_starts_line (iter)
	GtkTextIter *iter

## gboolean gtk_text_iter_ends_line (const GtkTextIter *iter)
gboolean
gtk_text_iter_ends_line (iter)
	GtkTextIter *iter

## gboolean gtk_text_iter_is_cursor_position (const GtkTextIter *iter)
gboolean
gtk_text_iter_is_cursor_position (iter)
	GtkTextIter *iter

## gint gtk_text_iter_get_chars_in_line (const GtkTextIter *iter)
gint
gtk_text_iter_get_chars_in_line (iter)
	GtkTextIter *iter

## gint gtk_text_iter_get_bytes_in_line (const GtkTextIter *iter)
gint
gtk_text_iter_get_bytes_in_line (iter)
	GtkTextIter *iter

# FIXME need to pass a stack struct and return a copy
### gboolean gtk_text_iter_get_attributes (const GtkTextIter *iter, GtkTextAttributes *values)
#gboolean
#gtk_text_iter_get_attributes (iter, values)
#	const GtkTextIter *iter
#	GtkTextAttributes *values

# FIXME i think the returned value should NOT be owned
### PangoLanguage* gtk_text_iter_get_language (const GtkTextIter *iter)
#PangoLanguage*
#gtk_text_iter_get_language (iter)
#	const GtkTextIter *iter

## gboolean gtk_text_iter_is_end (const GtkTextIter *iter)
gboolean
gtk_text_iter_is_end (iter)
	GtkTextIter *iter

## gboolean gtk_text_iter_is_start (const GtkTextIter *iter)
gboolean
gtk_text_iter_is_start (iter)
	GtkTextIter *iter

## gboolean gtk_text_iter_forward_char (GtkTextIter *iter)
gboolean
gtk_text_iter_forward_char (iter)
	GtkTextIter *iter

## gboolean gtk_text_iter_backward_char (GtkTextIter *iter)
gboolean
gtk_text_iter_backward_char (iter)
	GtkTextIter *iter

## gboolean gtk_text_iter_forward_chars (GtkTextIter *iter, gint count)
gboolean
gtk_text_iter_forward_chars (iter, count)
	GtkTextIter *iter
	gint count

## gboolean gtk_text_iter_backward_chars (GtkTextIter *iter, gint count)
gboolean
gtk_text_iter_backward_chars (iter, count)
	GtkTextIter *iter
	gint count

## gboolean gtk_text_iter_forward_line (GtkTextIter *iter)
gboolean
gtk_text_iter_forward_line (iter)
	GtkTextIter *iter

## gboolean gtk_text_iter_backward_line (GtkTextIter *iter)
gboolean
gtk_text_iter_backward_line (iter)
	GtkTextIter *iter

## gboolean gtk_text_iter_forward_lines (GtkTextIter *iter, gint count)
gboolean
gtk_text_iter_forward_lines (iter, count)
	GtkTextIter *iter
	gint count

## gboolean gtk_text_iter_backward_lines (GtkTextIter *iter, gint count)
gboolean
gtk_text_iter_backward_lines (iter, count)
	GtkTextIter *iter
	gint count

## gboolean gtk_text_iter_forward_word_end (GtkTextIter *iter)
gboolean
gtk_text_iter_forward_word_end (iter)
	GtkTextIter *iter

## gboolean gtk_text_iter_backward_word_start (GtkTextIter *iter)
gboolean
gtk_text_iter_backward_word_start (iter)
	GtkTextIter *iter

## gboolean gtk_text_iter_forward_word_ends (GtkTextIter *iter, gint count)
gboolean
gtk_text_iter_forward_word_ends (iter, count)
	GtkTextIter *iter
	gint count

## gboolean gtk_text_iter_backward_word_starts (GtkTextIter *iter, gint count)
gboolean
gtk_text_iter_backward_word_starts (iter, count)
	GtkTextIter *iter
	gint count

## gboolean gtk_text_iter_forward_sentence_end (GtkTextIter *iter)
gboolean
gtk_text_iter_forward_sentence_end (iter)
	GtkTextIter *iter

## gboolean gtk_text_iter_backward_sentence_start (GtkTextIter *iter)
gboolean
gtk_text_iter_backward_sentence_start (iter)
	GtkTextIter *iter

## gboolean gtk_text_iter_forward_sentence_ends (GtkTextIter *iter, gint count)
gboolean
gtk_text_iter_forward_sentence_ends (iter, count)
	GtkTextIter *iter
	gint count

## gboolean gtk_text_iter_backward_sentence_starts (GtkTextIter *iter, gint count)
gboolean
gtk_text_iter_backward_sentence_starts (iter, count)
	GtkTextIter *iter
	gint count

## gboolean gtk_text_iter_forward_cursor_position (GtkTextIter *iter)
gboolean
gtk_text_iter_forward_cursor_position (iter)
	GtkTextIter *iter

## gboolean gtk_text_iter_backward_cursor_position (GtkTextIter *iter)
gboolean
gtk_text_iter_backward_cursor_position (iter)
	GtkTextIter *iter

## gboolean gtk_text_iter_forward_cursor_positions (GtkTextIter *iter, gint count)
gboolean
gtk_text_iter_forward_cursor_positions (iter, count)
	GtkTextIter *iter
	gint count

## gboolean gtk_text_iter_backward_cursor_positions (GtkTextIter *iter, gint count)
gboolean
gtk_text_iter_backward_cursor_positions (iter, count)
	GtkTextIter *iter
	gint count

## void gtk_text_iter_set_offset (GtkTextIter *iter, gint char_offset)
void
gtk_text_iter_set_offset (iter, char_offset)
	GtkTextIter *iter
	gint char_offset

## void gtk_text_iter_set_line (GtkTextIter *iter, gint line_number)
void
gtk_text_iter_set_line (iter, line_number)
	GtkTextIter *iter
	gint line_number

## void gtk_text_iter_set_line_offset (GtkTextIter *iter, gint char_on_line)
void
gtk_text_iter_set_line_offset (iter, char_on_line)
	GtkTextIter *iter
	gint char_on_line

## void gtk_text_iter_set_line_index (GtkTextIter *iter, gint byte_on_line)
void
gtk_text_iter_set_line_index (iter, byte_on_line)
	GtkTextIter *iter
	gint byte_on_line

## void gtk_text_iter_forward_to_end (GtkTextIter *iter)
void
gtk_text_iter_forward_to_end (iter)
	GtkTextIter *iter

## gboolean gtk_text_iter_forward_to_line_end (GtkTextIter *iter)
gboolean
gtk_text_iter_forward_to_line_end (iter)
	GtkTextIter *iter

## void gtk_text_iter_set_visible_line_offset (GtkTextIter *iter, gint char_on_line)
void
gtk_text_iter_set_visible_line_offset (iter, char_on_line)
	GtkTextIter *iter
	gint char_on_line

## void gtk_text_iter_set_visible_line_index (GtkTextIter *iter, gint byte_on_line)
void
gtk_text_iter_set_visible_line_index (iter, byte_on_line)
	GtkTextIter *iter
	gint byte_on_line

## gboolean gtk_text_iter_forward_to_tag_toggle (GtkTextIter *iter, GtkTextTag *tag)
gboolean
gtk_text_iter_forward_to_tag_toggle (iter, tag)
	GtkTextIter *iter
	GtkTextTag *tag

## gboolean gtk_text_iter_backward_to_tag_toggle (GtkTextIter *iter, GtkTextTag *tag)
gboolean
gtk_text_iter_backward_to_tag_toggle (iter, tag)
	GtkTextIter *iter
	GtkTextTag *tag

## FIXME needs callback and gunichar typemap
#### typedef gboolean (* GtkTextCharPredicate) (gunichar ch, gpointer user_data)
##
#### gboolean gtk_text_iter_forward_find_char (GtkTextIter *iter, GtkTextCharPredicate pred, gpointer user_data, const GtkTextIter *limit)
##gboolean
##gtk_text_iter_forward_find_char (iter, pred, user_data, limit)
##	GtkTextIter *iter
##	GtkTextCharPredicate pred
##	gpointer user_data
##	const GtkTextIter *limit
##
#### gboolean gtk_text_iter_backward_find_char (GtkTextIter *iter, GtkTextCharPredicate pred, gpointer user_data, const GtkTextIter *limit)
##gboolean
##gtk_text_iter_backward_find_char (iter, pred, user_data, limit)
##	GtkTextIter *iter
##	GtkTextCharPredicate pred
##	gpointer user_data
##	const GtkTextIter *limit
##
#### gboolean gtk_text_iter_forward_search (const GtkTextIter *iter, const gchar *str, GtkTextSearchFlags flags, GtkTextIter *match_start, GtkTextIter *match_end, const GtkTextIter *limit)
##gboolean
##gtk_text_iter_forward_search (iter, str, flags, match_start, match_end, limit)
##	const GtkTextIter *iter
##	const gchar *str
##	GtkTextSearchFlags flags
##	GtkTextIter *match_start
##	GtkTextIter *match_end
##	const GtkTextIter *limit
##
#### gboolean gtk_text_iter_backward_search (const GtkTextIter *iter, const gchar *str, GtkTextSearchFlags flags, GtkTextIter *match_start, GtkTextIter *match_end, const GtkTextIter *limit)
##gboolean
##gtk_text_iter_backward_search (iter, str, flags, match_start, match_end, limit)
##	const GtkTextIter *iter
##	const gchar *str
##	GtkTextSearchFlags flags
##	GtkTextIter *match_start
##	GtkTextIter *match_end
##	const GtkTextIter *limit

## gboolean gtk_text_iter_equal (const GtkTextIter *lhs, const GtkTextIter *rhs)
gboolean
gtk_text_iter_equal (lhs, rhs)
	GtkTextIter *lhs
	GtkTextIter *rhs

## gint gtk_text_iter_compare (const GtkTextIter *lhs, const GtkTextIter *rhs)
gint
gtk_text_iter_compare (lhs, rhs)
	GtkTextIter *lhs
	GtkTextIter *rhs

## gboolean gtk_text_iter_in_range (const GtkTextIter *iter, const GtkTextIter *start, const GtkTextIter *end)
gboolean
gtk_text_iter_in_range (iter, start, end)
	GtkTextIter *iter
	GtkTextIter *start
	GtkTextIter *end

## void gtk_text_iter_order (GtkTextIter *first, GtkTextIter *second)
void
gtk_text_iter_order (first, second)
	GtkTextIter *first
	GtkTextIter *second

