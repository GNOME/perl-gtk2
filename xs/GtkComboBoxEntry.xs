#include "gtk2perl.h"

MODULE = Gtk2::ComboBoxEntry	PACKAGE = Gtk2::ComboBoxEntry	PREFIX = gtk_combo_box_entry_

GtkWidget *gtk_combo_box_entry_new (class, GtkTreeModel *model, gint text_column);
    C_ARGS:
	model, text_column

gint gtk_combo_box_entry_get_text_column (GtkComboBoxEntry *entry_box);
