/*
 * Copyright (c) 2003 by the gtk2-perl team (see the file AUTHORS)
 *
 * Licensed under the LGPL, see LICENSE file for more information.
 *
 * $Header$
 */

#include "gtk2perl.h"

MODULE = Gtk2::ToggleAction	PACKAGE = Gtk2::ToggleAction	PREFIX = gtk_toggle_action_

void gtk_toggle_action_toggled (GtkToggleAction *action);

void gtk_toggle_action_set_active (GtkToggleAction *action, gboolean is_active);

gboolean gtk_toggle_action_get_active (GtkToggleAction *action);

void gtk_toggle_action_set_draw_as_radio (GtkToggleAction *action, gboolean draw_as_radio);

gboolean gtk_toggle_action_get_draw_as_radio (GtkToggleAction *action);

