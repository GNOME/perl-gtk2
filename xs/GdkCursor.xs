/*
 * Copyright (c) 2003 by the gtk2-perl team (see the file AUTHORS)
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
 * $Header$
 */

#include "gtk2perl.h"

MODULE = Gtk2::Gdk::Cursor	PACKAGE = Gtk2::Gdk::Cursor	PREFIX = gdk_cursor_

GdkCursorType
gdk_cursor_type (cursor)
	GdkCursor *cursor
    CODE:
	RETVAL = cursor->type;
    OUTPUT:
	RETVAL

#if GTK_CHECK_VERSION(2,2,0)

## GdkCursor* gdk_cursor_new_for_display (GdkDisplay *display, GdkCursorType cursor_type)
GdkCursor_own*
gdk_cursor_new_for_display (class, display, cursor_type)
	GdkDisplay *display
	GdkCursorType cursor_type
    C_ARGS:
	display, cursor_type

## GdkDisplay* gdk_cursor_get_display (GdkCursor *cursor)
GdkDisplay*
gdk_cursor_get_display (cursor)
	GdkCursor *cursor

#endif

 ## GdkCursor* gdk_cursor_new (GdkCursorType cursor_type)
GdkCursor_own*
gdk_cursor_new (class, cursor_type)
	GdkCursorType cursor_type
    C_ARGS:
	cursor_type

 ## GdkCursor* gdk_cursor_new_from_pixmap (GdkPixmap *source, GdkPixmap *mask, GdkColor *fg, GdkColor *bg, gint x, gint y)
GdkCursor_own*
gdk_cursor_new_from_pixmap (class, source, mask, fg, bg, x, y)
	GdkPixmap *source
	GdkPixmap *mask
	GdkColor *fg
	GdkColor *bg
	gint x
	gint y
    C_ARGS:
	source, mask, fg, bg, x, y


#if GTK_CHECK_VERSION(2, 3, 1) /* FIXME 2.4 */

## GdkCursor * gdk_cursor_new_from_pixbuf (GdkDisplay *display, GdkPixbuf  *pixbuf, gint x, gint y)
GdkCursor_own *
gdk_cursor_new_from_pixbuf (class, display, pixbuf, x, y)
	GdkDisplay *display
	GdkPixbuf  *pixbuf
	gint x
	gint y
    C_ARGS:
	display, pixbuf, x, y

#endif
