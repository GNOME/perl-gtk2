#include "gtk2perl.h"

MODULE = Gtk2::Gdk::Cursor	PACKAGE = Gtk2::Gdk::Cursor	PREFIX = gdk_cursor_

#if GTK_CHECK_VERSION(2,2,0)

# ## GdkCursor* gdk_cursor_new_for_display (GdkDisplay *display, GdkCursorType cursor_type)
#GdkCursor*
#gdk_cursor_new_for_display (class, display, cursor_type)
#	SV * class
#	GdkDisplay *display
#	GdkCursorType cursor_type
#    C_ARGS:
#	display, cursor_type
#
# ## GdkDisplay* gdk_cursor_get_display (GdkCursor *cursor)
#GdkDisplay*
#gdk_cursor_get_display (cursor)
#	GdkCursor *cursor

#endif

 ## GdkCursor* gdk_cursor_new (GdkCursorType cursor_type)
GdkCursor_own*
gdk_cursor_new (class, cursor_type)
	SV * class
	GdkCursorType cursor_type
    C_ARGS:
	cursor_type

 ## GdkCursor* gdk_cursor_new_from_pixmap (GdkPixmap *source, GdkPixmap *mask, GdkColor *fg, GdkColor *bg, gint x, gint y)
GdkCursor_own*
gdk_cursor_new_from_pixmap (class, source, mask, fg, bg, x, y)
	SV * class
	GdkPixmap *source
	GdkPixmap *mask
	GdkColor *fg
	GdkColor *bg
	gint x
	gint y
    C_ARGS:
	source, mask, fg, bg, x, y

 ## these are handled by GBoxed and the perl SV reference count
 ## GdkCursor* gdk_cursor_ref (GdkCursor *cursor)
 ## void gdk_cursor_unref (GdkCursor *cursor)

