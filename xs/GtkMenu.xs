/*
 * $Header$
 */

#include "gtk2perl.h"

MODULE = Gtk2::Menu	PACKAGE = Gtk2::Menu	PREFIX = gtk_menu_

GtkWidget*
gtk_menu_new (class)
	SV * class
    C_ARGS:

void
gtk_menu_popup (menu, parent_menu_shell, parent_menu_item, menu_pos_func, data, button, activate_time)
	GtkMenu	* menu
	GtkWidget_ornull * parent_menu_shell
	GtkWidget_ornull * parent_menu_item
	SV * menu_pos_func
	SV * data
	guint button
	guint activate_time
	###guint32 activate_time
    CODE:
	croak ("gtk_menu_popup -- binding not implemented");

void
gtk_menu_reposition (menu)
	GtkMenu	* menu

void
gtk_menu_popdown (menu)
	GtkMenu *menu

GtkWidget *
gtk_menu_get_active (menu)
	GtkMenu *menu

void
gtk_menu_set_active (menu, index)
	GtkMenu *menu
	guint index

void
gtk_menu_set_accel_group (menu, accel_group)
	GtkMenu	* menu
	GtkAccelGroup * accel_group

GtkAccelGroup*
gtk_menu_get_accel_group (menu)
	GtkMenu *menu

void
gtk_menu_set_accel_path (menu, accel_path)
	GtkMenu *menu
	const gchar *accel_path

 ##void	   gtk_menu_attach_to_widget	  (GtkMenu	       *menu,
 ##					   GtkWidget	       *attach_widget,
 ##					   GtkMenuDetachFunc	detacher);
 ##
void
gtk_menu_detach (menu)
	GtkMenu *menu

 ## GtkWidget* gtk_menu_get_attach_widget	  (GtkMenu	       *menu);

void
gtk_menu_set_tearoff_state (menu, torn_off)
	GtkMenu *menu
	gboolean torn_off

gboolean
gtk_menu_get_tearoff_state (menu)
	GtkMenu *menu

void
gtk_menu_set_title (menu, title)
	GtkMenu * menu
	const gchar * title

 ## void gtk_menu_reorder_child (GtkMenu *menu, GtkWidget *child, gint position)
void
gtk_menu_reorder_child (menu, child, position)
	GtkMenu *menu
	GtkWidget *child
	gint position

##gchar * gtk_menu_get_title (GtkMenu *menu)
const gchar *
gtk_menu_get_title (menu)
	GtkMenu * menu


##if GTK_CHECK_VERSION(2,2,0)
#
##void gtk_menu_set_screen (GtkMenu *menu, GdkScreen *screen)
#void
#gtk_menu_set_screen (menu, screen)
#	GtkMenu   * menu
#	GdkScreen * screen
#
##endif
