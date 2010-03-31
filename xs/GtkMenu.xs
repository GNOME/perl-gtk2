/*
 * Copyright (c) 2003-2005, 2010 by the gtk2-perl team (see the file AUTHORS)
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
#include <gperl_marshal.h>


/*
 * yet another special case that isn't appropriate for either
 * GPerlClosure or GPerlCallback --- the menu position function has
 * mostly output parameters, so we need to change the callbacks's
 * signature for perl, getting multiple return values from the stack.
 * this one's easy, though.
 */

/* this is public so that other extensions which use GtkMenuPosFunc (e.g.
 * libgnomeui) don't need to reimplement it. */
void
gtk2perl_menu_position_func (GtkMenu * menu,
                             gint * x,
                             gint * y,
                             gboolean * push_in,
                             GPerlCallback * callback)
{
	int n;
	dGPERL_CALLBACK_MARSHAL_SP;

	GPERL_CALLBACK_MARSHAL_INIT (callback);

	ENTER;
	SAVETMPS;

	PUSHMARK (SP);

	EXTEND (SP, 3);
	PUSHs (sv_2mortal (newSVGtkMenu (menu)));
	PUSHs (sv_2mortal (newSViv (*x)));
	PUSHs (sv_2mortal (newSViv (*y)));
	if (callback->data)
		XPUSHs (sv_2mortal (newSVsv (callback->data)));

	PUTBACK;

	n = call_sv (callback->func, G_ARRAY);

	SPAGAIN;

	if (n < 2 || n > 3)
		croak ("menu position callback must return two integers "
		       "(x, and y) or two integers and a boolean (x, y, and "
		       "push_in)");

	/* POPs and POPi take things off the *end* of the stack! */
	if (n > 2) {
		SV *sv = POPs;
		*push_in = sv_2bool (sv);
	}
	if (n > 1) *y = POPi;
	if (n > 0) *x = POPi;

	PUTBACK;
	FREETMPS;
	LEAVE;
}

static GPerlCallback *
gtk2perl_menu_detach_func_create (SV *func, SV *data)
{
	GType param_types [2];
	param_types[0] = GTK_TYPE_WIDGET;
	param_types[1] = GTK_TYPE_MENU;
	return gperl_callback_new (func, data, G_N_ELEMENTS (param_types),
				   param_types, 0);
}

static void
gtk2perl_menu_detach_func (GtkWidget *attach_widget,
                           GtkMenu *menu)
{
	GPerlCallback *callback;

	callback = g_object_get_data (G_OBJECT (attach_widget),
	                              "__gtk2perl_menu_detach_func__");

	if (callback)
		gperl_callback_invoke (callback, NULL, attach_widget, menu);
}

MODULE = Gtk2::Menu	PACKAGE = Gtk2::Menu	PREFIX = gtk_menu_

GtkWidget*
gtk_menu_new (class)
    C_ARGS:
	/* void */

=for apidoc
If C<$menu_pos_func> is not C<undef> it's called as

    ($x, $y, $push_in) = &$menu_pos_func ($menu, $x, $y, $data)

C<$x>,C<$y> inputs are a proposed position based on the mouse pointer
(not actually documented in the Gtk manuals).  The return should be a
desired C<$x>,C<$y>, and an optional C<$push_in> flag.  If C<$push_in>
is true then Gtk will adjust C<$x>,C<$y> if necessary so the menu is
fully visible in the screen width and height.

C<$menu_pos_func> and C<$data> are stored in C<$menu> and may be
called again later for a C<< $menu->reposition >> or some obscure
things like a changed C<set_screen> while torn-off.  A further
C<< $menu->popup >> call replaces C<$menu_pos_func> and C<$data>.
=cut
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
	if (!gperl_sv_is_defined (menu_pos_func)) {
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
		/* The menu will store the callback we give it, and can
		 * conceivably invoke the callback multiple times
		 * (repositioning, changing screens, etc).  Each call to
		 * gtk_menu_popup() replaces the function pointer.  So,
		 * if we use a weak reference, we can leak multiple callbacks;
		 * if we use object data, we can clean up the ones we install
		 * and reinstall.  Not likely, of course, but there are
		 * pathological programmers out there. */
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

void
gtk_menu_attach_to_widget (menu, attach_widget, detacher)
	GtkMenu *menu
	GtkWidget *attach_widget
	SV *detacher
    PREINIT:
	GPerlCallback *callback;
    CODE:
	callback = gtk2perl_menu_detach_func_create (detacher, NULL);

	g_object_set_data_full (G_OBJECT (attach_widget),
	                        "__gtk2perl_menu_detach_func__",
			        callback,
	                        (GDestroyNotify) gperl_callback_destroy);

	gtk_menu_attach_to_widget (menu,
	                           attach_widget,
	                           gtk2perl_menu_detach_func);

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

#if GTK_CHECK_VERSION(2,4,0)

void gtk_menu_attach (GtkMenu *menu, GtkWidget *child, guint left_attach, guint right_attach, guint top_attach, guint bottom_attach);

void gtk_menu_set_monitor (GtkMenu *menu, gint monitor_num);

#endif

#if GTK_CHECK_VERSION(2,6,0)

##  GList* gtk_menu_get_for_attach_widget (GtkWidget *widget);
void
gtk_menu_get_for_attach_widget (class, widget)
	GtkWidget *widget
    PREINIT:
	GList *list, *i;
    PPCODE:
	list = gtk_menu_get_for_attach_widget (widget);
	for (i = list; i; i = i->next)
		XPUSHs (sv_2mortal (newSVGtkMenu (i->data)));

#endif

#if GTK_CHECK_VERSION (2, 14, 0)

const gchar* gtk_menu_get_accel_path (GtkMenu *menu);

gint gtk_menu_get_monitor (GtkMenu *menu);

#endif /* 2.14 */
