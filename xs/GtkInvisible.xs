/*
 * $Header$
 */

#include "gtk2perl.h"

/*
FIXME this is an internal widget and we should not export it.
*/

MODULE = Gtk2::Invisible	PACKAGE = Gtk2::Invisible	PREFIX = gtk_invisible_

## GtkWidget* gtk_invisible_new (void)
GtkWidget *
gtk_invisible_new (class)
	SV * class
    C_ARGS:

##if GTK_CHECK_VERSION(2,2,0)
#
##GtkWidget * gtk_invisible_new_for_screen (GdkScreen *screen)
#GtkWidget *
#gtk_invisible_new_for_screen (screen)
#	GdkScreen *screen
#
##void gtk_invisible_set_screen (GtkInvisible *invisible, GdkScreen *screen)
#void gtk_invisible_set_screen (invisible, screen)
#	GtkInvisible *invisible
#	GdkScreen *screen
#
##GdkScreen * gtk_invisible_get_screen (GtkInvisible *invisible)
#GdkScreen * gtk_invisible_get_screen (invisible)
#	GtkInvisible *invisible
#
##endif
