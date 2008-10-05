/*
 * Copyright (c) 2005 by the gtk2-perl team (see the file AUTHORS)
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

MODULE = Gtk2::Gdk::PixbufSimpleAnim	PACKAGE = Gtk2::Gdk::PixbufSimpleAnim	PREFIX = gdk_pixbuf_simple_anim_

GdkPixbufSimpleAnim_noinc *
gdk_pixbuf_simple_anim_new (class, gint width, gint height, gfloat rate)
    C_ARGS:
        width, height, rate

void gdk_pixbuf_simple_anim_add_frame (GdkPixbufSimpleAnim *animation, GdkPixbuf *pixbuf)

