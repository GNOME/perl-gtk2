#include "gtk2perl.h"

MODULE = Gtk2::ComboBox	PACKAGE = Gtk2::ComboBox	PREFIX = gtk_combo_box_

GtkWidget *gtk_combo_box_new (class, GtkTreeModel *model);
    C_ARGS:
	model

##/* grids */
void gtk_combo_box_set_wrap_width (GtkComboBox *combo_box, gint width);

void gtk_combo_box_set_row_span_column (GtkComboBox *combo_box, gint row_span);

void gtk_combo_box_set_column_span_column (GtkComboBox *combo_box, gint column_span);

##/* get/set active item */
gint gtk_combo_box_get_active (GtkComboBox *combo_box);

void gtk_combo_box_set_active (GtkComboBox *combo_box, gint index);

gboolean gtk_combo_box_get_active_iter (GtkComboBox *combo_box, GtkTreeIter *iter);

void gtk_combo_box_set_active_iter (GtkComboBox *combo_box, GtkTreeIter *iter);

##/* getters and setters */
GtkTreeModel *gtk_combo_box_get_model (GtkComboBox *combo_box);

##/* convenience -- text */
GtkWidget *gtk_combo_box_new_text (class);
    C_ARGS:
	/* void */

void gtk_combo_box_append_text (GtkComboBox *combo_box, const gchar *text);

void gtk_combo_box_insert_text (GtkComboBox *combo_box, gint position, const gchar *text);

void gtk_combo_box_prepend_text (GtkComboBox *combo_box, const gchar *text);
