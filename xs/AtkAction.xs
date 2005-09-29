/*
 * Copyright (c) 2005 by the gtk2-perl team (see the file AUTHORS)
 *
 * Licensed under the LGPL, see LICENSE file for more information.
 *
 * $Header$
 */

#include "gtk2perl.h"

MODULE = Gtk2::Atk::Action	PACKAGE = Gtk2::Atk::Action	PREFIX = atk_action_

gboolean atk_action_do_action (AtkAction *action, gint i);

gint atk_action_get_n_actions (AtkAction *action);

const gchar* atk_action_get_description (AtkAction *action, gint i);

const gchar* atk_action_get_name (AtkAction *action, gint i);

const gchar* atk_action_get_keybinding (AtkAction *action, gint i);

gboolean atk_action_set_description (AtkAction *action, gint i, const gchar *desc);

#if ATK_CHECK_VERSION (1, 1, 0)

const gchar* atk_action_get_localized_name (AtkAction *action, gint i);

#endif
