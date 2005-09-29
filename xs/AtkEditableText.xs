/*
 * Copyright (c) 2005 by the gtk2-perl team (see the file AUTHORS)
 *
 * Licensed under the LGPL, see LICENSE file for more information.
 *
 * $Header$
 */

#include "gtk2perl.h"

MODULE = Gtk2::Atk::EditableText	PACKAGE = Gtk2::Atk::EditableText	PREFIX = atk_exitable_text_

# FIXME
# gboolean atk_editable_text_set_run_attributes (AtkEditableText *text, AtkAttributeSet *attrib_set, gint start_offset, gint end_offset);

void atk_editable_text_set_text_contents (AtkEditableText *text, const gchar *string);

# FIXME
# void atk_editable_text_insert_text (AtkEditableText *text, const gchar *string, gint length, gint *position);

void atk_editable_text_copy_text (AtkEditableText *text, gint start_pos, gint end_pos);

void atk_editable_text_cut_text (AtkEditableText *text, gint start_pos, gint end_pos);

void atk_editable_text_delete_text (AtkEditableText *text, gint start_pos, gint end_pos);

void atk_editable_text_paste_text (AtkEditableText *tex, gint position);
