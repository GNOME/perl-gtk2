/*
 * Copyright (c) 2005 by the gtk2-perl team (see the file AUTHORS)
 *
 * Licensed under the LGPL, see LICENSE file for more information.
 *
 * $Header$
 */

#include "gtk2perl.h"

MODULE = Gtk2::Atk::Table	PACKAGE = Gtk2::Atk::Table	PREFIX = atk_table_

AtkObject_noinc* atk_table_ref_at (AtkTable *table, gint row, gint column);

gint atk_table_get_index_at (AtkTable *table, gint row, gint column);

gint atk_table_get_column_at_index (AtkTable *table, gint index_);

gint atk_table_get_row_at_index (AtkTable *table, gint index_);

gint atk_table_get_n_columns (AtkTable *table);

gint atk_table_get_n_rows (AtkTable *table);

gint atk_table_get_column_extent_at (AtkTable *table, gint row, gint column);

gint atk_table_get_row_extent_at (AtkTable *table, gint row, gint column);

AtkObject* atk_table_get_caption (AtkTable *table);

const gchar* atk_table_get_column_description (AtkTable *table, gint column);

AtkObject* atk_table_get_column_header (AtkTable *table, gint column);

const gchar* atk_table_get_row_description (AtkTable *table, gint row);

AtkObject* atk_table_get_row_header (AtkTable *table, gint row);

AtkObject* atk_table_get_summary (AtkTable *table);

void atk_table_set_caption (AtkTable *table, AtkObject *caption);

void atk_table_set_column_description (AtkTable *table, gint column, const gchar *description);

void atk_table_set_column_header (AtkTable *table, gint column, AtkObject *header);

void atk_table_set_row_description (AtkTable *table, gint row, const gchar *description);

void atk_table_set_row_header (AtkTable *table, gint row, AtkObject *header);

void atk_table_set_summary (AtkTable *table, AtkObject *accessible);

# FIXME
# gint atk_table_get_selected_columns (AtkTable *table, gint **selected);
# gint atk_table_get_selected_rows (AtkTable *table, gint **selected);

gboolean atk_table_is_column_selected (AtkTable *table, gint column);

gboolean atk_table_is_row_selected (AtkTable *table, gint row);

gboolean atk_table_is_selected (AtkTable *table, gint row, gint column);

gboolean atk_table_add_row_selection (AtkTable *table, gint row);

gboolean atk_table_remove_row_selection (AtkTable *table, gint row);

gboolean atk_table_add_column_selection (AtkTable *table, gint column);

gboolean atk_table_remove_column_selection (AtkTable *table, gint column);
