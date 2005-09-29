/*
 * Copyright (c) 2005 by the gtk2-perl team (see the file AUTHORS)
 *
 * Licensed under the LGPL, see LICENSE file for more information.
 *
 * $Header$
 */

#include "gtk2perl.h"

MODULE = Gtk2::Atk::Hypertext	PACKAGE = Gtk2::Atk::Hypertext	PREFIX = atk_hypertext_

AtkHyperlink* atk_hypertext_get_link (AtkHypertext *hypertext, gint link_index);

gint atk_hypertext_get_n_links (AtkHypertext *hypertext);

gint atk_hypertext_get_link_index (AtkHypertext *hypertext, gint char_index);
