/*
 * Copyright (c) 2005 by the gtk2-perl team (see the file AUTHORS)
 *
 * Licensed under the LGPL, see LICENSE file for more information.
 *
 * $Header$
 */

#include "gtk2perl.h"

MODULE = Gtk2::Atk::Image	PACKAGE = Gtk2::Atk::Image	PREFIX = atk_image_

const gchar* atk_image_get_image_description (AtkImage *image);

void atk_image_get_image_size (AtkImage *image, OUTLIST gint width, OUTLIST gint height);

gboolean atk_image_set_image_description (AtkImage *image, const gchar *description);

void atk_image_get_image_position (AtkImage *image, OUTLIST gint x, OUTLIST gint y, AtkCoordType coord_type);
