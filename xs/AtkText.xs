/*
 * Copyright (c) 2005 by the gtk2-perl team (see the file AUTHORS)
 *
 * Licensed under the LGPL, see LICENSE file for more information.
 *
 * $Header$
 */

#include "gtk2perl.h"

MODULE = Gtk2::Atk::Text	PACKAGE = Gtk2::Atk::Text	PREFIX = atk_text_

gchar_own* atk_text_get_text (AtkText *text, gint start_offset, gint end_offset);

gunichar atk_text_get_character_at_offset (AtkText *text, gint offset);

gchar_own* atk_text_get_text_after_offset (AtkText *text, gint offset, AtkTextBoundary boundary_type, OUTLIST gint start_offset, OUTLIST gint end_offset);

gchar_own* atk_text_get_text_at_offset (AtkText *text, gint offset, AtkTextBoundary boundary_type, OUTLIST gint start_offset, OUTLIST gint end_offset);

gchar_own* atk_text_get_text_before_offset (AtkText *text, gint offset, AtkTextBoundary boundary_type, OUTLIST gint start_offset, OUTLIST gint end_offset);

gint atk_text_get_caret_offset (AtkText *text);

void atk_text_get_character_extents (AtkText *text, gint offset, OUTLIST gint x, OUTLIST gint y, OUTLIST gint width, OUTLIST gint height, AtkCoordType coords);

# FIXME
# AtkAttributeSet* atk_text_get_run_attributes (AtkText *text, gint offset, OUTLIST gint start_offset, OUTLIST gint end_offset);
# AtkAttributeSet* atk_text_get_default_attributes (AtkText *text);

gint atk_text_get_character_count (AtkText *text);

gint atk_text_get_offset_at_point (AtkText *text, gint x, gint y, AtkCoordType coords);

gint atk_text_get_n_selections (AtkText *text);

gchar_own* atk_text_get_selection (AtkText *text, gint selection_num, OUTLIST gint start_offset, OUTLIST gint end_offset);

gboolean atk_text_add_selection (AtkText *text, gint start_offset, gint end_offset);

gboolean atk_text_remove_selection (AtkText *text, gint selection_num);

gboolean atk_text_set_selection (AtkText *text, gint selection_num, gint start_offset, gint end_offset);

gboolean atk_text_set_caret_offset (AtkText *text, gint offset);

# FIXME
# void atk_text_get_range_extents (AtkText *text, gint start_offset, gint end_offset, AtkCoordType coord_type, AtkTextRectangle *rect);
# AtkTextRange** atk_text_get_bounded_ranges (AtkText *text, AtkTextRectangle *rect, AtkCoordType coord_type, AtkTextClipType x_clip_type, AtkTextClipType y_clip_type);
# void atk_text_free_ranges (AtkTextRange **ranges);
# void atk_attribute_set_free (AtkAttributeSet *attrib_set);
# const gchar* atk_text_attribute_get_name (AtkTextAttribute attr);
# AtkTextAttribute atk_text_attribute_for_name (const gchar *name);
# const gchar* atk_text_attribute_get_value (AtkTextAttribute attr, gint index_);
