/*
 * Copyright (c) 2003 by the gtk2-perl team (see the file AUTHORS)
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Library General Public
 * License as published by the Free Software Foundation; either
 * version 2 of the License, or (at your option) any later version.
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



/*
 * yet another special case that isn't appropriate for either
 * GPerlClosure or GPerlCallback --- the menu position function has
 * mostly output parameters, so we need to change the callbacks's
 * signature for perl, getting multiple return values from the stack.
 * this one's easy, though.
 */

void
gtk2perl_menu_position_func (GtkMenu * menu,
                             gint * x,
                             gint * y,
                             gboolean * push_in,
                             GPerlCallback * callback)
{
	dSP;
	int n;

	ENTER;
	SAVETMPS;

	PUSHMARK (SP);

	XPUSHs (sv_2mortal (newSVGtkMenu (menu)));
	XPUSHs (sv_2mortal (newSViv (*x)));
	XPUSHs (sv_2mortal (newSViv (*y)));
	XPUSHs (sv_2mortal (newSViv (*push_in)));
	XPUSHs (sv_2mortal (callback->data ? callback->data : &PL_sv_undef));

	PUTBACK;

	n = call_sv (callback->func, G_ARRAY);

	SPAGAIN;

	if (n < 2)
		croak ("menu position callback must return two integers (x, and y) or three integers (x, y, and push_in)");

	/* POPi takes things off the *end* of the stack! */
	if (n > 2) *push_in = POPi;
	if (n > 1) *y = POPi;
	if (n > 0) *x = POPi;

	FREETMPS;
	LEAVE;
}



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
	if (menu_pos_func == NULL || menu_pos_func == &PL_sv_undef) {
		gtk_menu_popup (menu, parent_menu_shell, parent_menu_item,
		                NULL, NULL, button, activate_time);
	} else {
		GPerlCallback * callback;
		/* we don't need to worry about the callback arg types since
		 * we already have to marshall this callback ourselves. */
		callback = gperl_callback_new (menu_pos_func, data, 0, NULL, 0);
		gtk_menu_popup (menu, parent_menu_shell, parent_menu_item,
		        (GtkMenuPositionFunc) gtk2perl_menu_position_func,
			callback, button, activate_time);
		/* NOTE: this isn't a proper destructor, as it could leak
		 *    if replaced somewhere else.  on the other hand, how
		 *    likely is that? */
		g_object_set_data_full (G_OBJECT (menu), "_menu_pos_callback",
		                        callback,
		                        (GDestroyNotify)
		                             gperl_callback_destroy);
	}

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

GtkWidget *
gtk_menu_get_attach_widget (menu)
	GtkMenu	* menu

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


#if GTK_CHECK_VERSION(2,2,0)

##void gtk_menu_set_screen (GtkMenu *menu, GdkScreen *screen)
void
gtk_menu_set_screen (menu, screen)
	GtkMenu   * menu
	GdkScreen * screen

#endif
