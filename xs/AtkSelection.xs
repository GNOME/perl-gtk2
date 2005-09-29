/*
 * Copyright (c) 2005 by the gtk2-perl team (see the file AUTHORS)
 *
 * Licensed under the LGPL, see LICENSE file for more information.
 *
 * $Header$
 */

#include "gtk2perl.h"

MODULE = Gtk2::Atk::Selection	PACKAGE = Gtk2::Atk::Selection	PREFIX = atk_selection_

gboolean atk_selection_add_selection (AtkSelection *selection, gint i);

gboolean atk_selection_clear_selection (AtkSelection *selection);

AtkObject_noinc* atk_selection_ref_selection (AtkSelection *selection, gint i);

gint atk_selection_get_selection_count (AtkSelection *selection);

gboolean atk_selection_is_child_selected (AtkSelection *selection, gint i);

gboolean atk_selection_remove_selection (AtkSelection *selection, gint i);

gboolean atk_selection_select_all_selection (AtkSelection *selection);
