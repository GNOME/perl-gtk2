/*
 * Copyright (c) 2005 by the gtk2-perl team (see the file AUTHORS)
 *
 * Licensed under the LGPL, see LICENSE file for more information.
 *
 * $Header$
 */

#include "gtk2perl.h"

MODULE = Gtk2::Atk::Hyperlink	PACKAGE = Gtk2::Atk::Hyperlink	PREFIX = atk_hyperlink_

gchar_own* atk_hyperlink_get_uri (AtkHyperlink *link_, gint i);

AtkObject* atk_hyperlink_get_object (AtkHyperlink *link_, gint i);

gint atk_hyperlink_get_end_index (AtkHyperlink *link_);

gint atk_hyperlink_get_start_index (AtkHyperlink *link_);

gboolean atk_hyperlink_is_valid (AtkHyperlink *link_);

#if ATK_CHECK_VERSION (1, 2, 0)

gboolean atk_hyperlink_is_inline (AtkHyperlink *link_);

#endif

gint atk_hyperlink_get_n_anchors (AtkHyperlink *link_);

#if ATK_CHECK_VERSION (1, 4, 0)

gboolean atk_hyperlink_is_selected_link (AtkHyperlink *link_);

#endif
