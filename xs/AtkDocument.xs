/*
 * Copyright (c) 2005 by the gtk2-perl team (see the file AUTHORS)
 *
 * Licensed under the LGPL, see LICENSE file for more information.
 *
 * $Header$
 */

#include "gtk2perl.h"

MODULE = Gtk2::Atk::Document	PACKAGE = Gtk2::Atk::Document	PREFIX = atk_document_

const gchar* atk_document_get_document_type (AtkDocument *document);

# FIXME
# gpointer atk_document_get_document (AtkDocument *document);
