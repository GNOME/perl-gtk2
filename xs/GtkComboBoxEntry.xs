/*
 * Copyright (c) 2003 by the gtk2-perl team (see the file AUTHORS)
 *
 * Licensed under the LGPL, see LICENSE file for more information.
 *
 * $Header$
 */

#include "gtk2perl.h"

MODULE = Gtk2::ComboBoxEntry	PACKAGE = Gtk2::ComboBoxEntry	PREFIX = gtk_combo_box_entry_

 ## GtkWidget *gtk_combo_box_entry_new (void);
 ## GtkWidget *gtk_combo_box_entry_new_with_model (GtkTreeModel *model, gint text_column);
=for apidoc new_with_model
=for signature $entry = Gtk2::ComboBoxEntry->new_with_model ($model, $text_column)
=for arg model (GtkTreeModel)
=for arg text_column (int)
=for arg ... (__hide__)
Alias for new, with two arguments.
=cut

=for apidoc
=for signature $entry = Gtk2::ComboBoxEntry->new
=for signature $entry = Gtk2::ComboBoxEntry->new ($model, $text_column)
=for arg model (GtkTreeModel)
=for arg text_column (int)
=for arg ... (__hide__)
=cut
GtkWidget *
gtk_combo_box_entry_new (class, ...)
    ALIAS:
	new_with_model = 1
    CODE:
	if (ix == 1 || items == 3) {
		RETVAL = gtk_combo_box_entry_new_with_model
					(SvGtkTreeModel (ST (1)), SvIV (ST (2)));
	} else if (ix == 0 && items == 1) {
		RETVAL = gtk_combo_box_entry_new ();
	} else {
		croak ("Usage: Gtk2::ComboBoxEntry->new ()\n"
		       "    OR\n"
		       "       Gtk2::ComboBoxEntry->new (model, text_column)\n"
		       "    OR\n"
		       "       Gtk2::ComboBoxEntry->new_with_model (model, text_column)\n"
		       "    wrong number of arguments");
	}
    OUTPUT:
	RETVAL

gint gtk_combo_box_entry_get_text_column (GtkComboBoxEntry *entry_box);

void gtk_combo_box_entry_set_text_column (GtkComboBoxEntry *entry_box, gint text_column);

#if GTK_CHECK_VERSION (2, 3, 5) /* FIXME 2.4 */

GtkWidget *
gtk_combo_box_entry_new_text (class)
    C_ARGS:
	/* void */

#endif
