/*
 * Copyright (c) 2006 by the gtk2-perl team (see the file AUTHORS)
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Library General Public
 * License as published by the Free Software Foundation; either
 * version 2.1 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Library General Public License for more details.
 *
 * You should have received a copy of the GNU Library General Public
 * License along with this library; if not, write to the
 * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
 * Boston, MA  02111-1307  USA.
 *
 * $Id$
 */

#include "gtk2perl.h"

MODULE = Gtk2::IMMultiContext	PACKAGE = Gtk2::IMMulticontext	PREFIX = gtk_im_multicontext_

GtkIMContext_noinc * gtk_im_multicontext_new (class)
    C_ARGS:
        /*void*/

void gtk_im_multicontext_append_menuitems (GtkIMMulticontext *context, GtkMenuShell *menushell);
