/*
 * Copyright (c) 2005 by the gtk2-perl team (see the file AUTHORS)
 *
 * Licensed under the LGPL, see LICENSE file for more information.
 *
 * $Header$
 */

#include "gtk2perl.h"

MODULE = Gtk2::Atk::StreamableContent	PACKAGE = Gtk2::Atk::StreamableContent	PREFIX = atk_streamable_content_

gint atk_streamable_content_get_n_mime_types (AtkStreamableContent *streamable);

const gchar* atk_streamable_content_get_mime_type (AtkStreamableContent *streamable, gint i);

# FIXME
# GIOChannel* atk_streamable_content_get_stream (AtkStreamableContent *streamable, const gchar *mime_type);
