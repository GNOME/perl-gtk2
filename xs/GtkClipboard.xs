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

/*
 * this entire object didn't exist in the original 2.0.0 release.  hrm.
 */
#ifdef GTK_TYPE_CLIPBOARD


#define DEFINE_QUARK(stem)	\
static GQuark								\
stem ## _quark (void) 							\
{									\
	static GQuark q = 0;						\
	if (q == 0)							\
		q = g_quark_from_static_string ("gtk2perl_" #stem );	\
	return q;							\
}

DEFINE_QUARK (clipboard_received);
DEFINE_QUARK (clipboard_text_received);
DEFINE_QUARK (clipboard_get);
DEFINE_QUARK (clipboard_clear);
DEFINE_QUARK (clipboard_user_data);

static void 
gtk2perl_clipboard_received_func (GtkClipboard *clipboard,
                                  GtkSelectionData *selection_data,
                                  gpointer data)
{
	GPerlCallback * callback = (GPerlCallback*)
			g_object_get_qdata (G_OBJECT (clipboard),
			                    clipboard_received_quark());
	gperl_callback_invoke (callback, NULL, clipboard, selection_data);

	PERL_UNUSED_VAR (data);
}

static void
gtk2perl_clipboard_text_received_func (GtkClipboard *clipboard,
                                       const gchar *text,
                                       gpointer data)
{
	GPerlCallback * callback = (GPerlCallback*)
			g_object_get_qdata (G_OBJECT (clipboard),
			                    clipboard_text_received_quark());
	gperl_callback_invoke (callback, NULL, clipboard, text);

	PERL_UNUSED_VAR (data);
}

static void
gtk2perl_clipboard_get_func (GtkClipboard *clipboard,
                             GtkSelectionData *selection_data,
                             guint info,
                             gpointer user_data_or_owner)
{
	GPerlCallback * callback = (GPerlCallback*)
			g_object_get_qdata (G_OBJECT (clipboard),
			                    clipboard_get_quark());
	gperl_callback_invoke (callback, NULL,
	                       clipboard, selection_data, info,
	                       user_data_or_owner);
}

static void
gtk2perl_clipboard_clear_func (GtkClipboard *clipboard,
                               gpointer user_data_or_owner)
{
	GPerlCallback * callback = (GPerlCallback*)
			g_object_get_qdata (G_OBJECT (clipboard),
			                    clipboard_clear_quark());
	gperl_callback_invoke (callback, NULL, clipboard, user_data_or_owner);
}

#endif /* defined GTK_TYPE_CLIPBOARD */

MODULE = Gtk2::Clipboard	PACKAGE = Gtk2::Clipboard	PREFIX = gtk_clipboard_

#ifdef GTK_TYPE_CLIPBOARD

##  GtkClipboard *gtk_clipboard_get (GdkAtom selection) 
GtkClipboard_noinc *
gtk_clipboard_get (class, selection)
	GdkAtom selection
    C_ARGS:
	selection

#if GTK_CHECK_VERSION(2,2,0)

##  GtkClipboard *gtk_clipboard_get_for_display (GdkDisplay *display, GdkAtom selection) 
GtkClipboard_noinc *
gtk_clipboard_get_for_display (class, display, selection)
	GdkDisplay *display
	GdkAtom selection
    C_ARGS:
	display, selection

##  GdkDisplay *gtk_clipboard_get_display (GtkClipboard *clipboard) 
GdkDisplay *
gtk_clipboard_get_display (clipboard)
	GtkClipboard *clipboard

#endif /* >=2.2.0 */

####  gboolean gtk_clipboard_set_with_data (GtkClipboard *clipboard, const GtkTargetEntry *targets, guint n_targets, GtkClipboardGetFunc get_func, GtkClipboardClearFunc clear_func, gpointer user_data) 
=for apidoc
=for arg target1 (Gtk2::TargetEntry) the first target entry
=for arg ... (__hide__)
=cut
gboolean
gtk_clipboard_set_with_data (clipboard, get_func, clear_func, user_data, target1, ...)
	GtkClipboard *clipboard
	SV * get_func
	SV * clear_func
	SV * user_data
    PREINIT:
	GtkTargetEntry *targets = NULL;
	guint n_targets;
	GPerlCallback * get_callback;
	GType get_param_types[] = {
		GTK_TYPE_CLIPBOARD,
		GTK_TYPE_SELECTION_DATA,
		G_TYPE_UINT,
		GPERL_TYPE_SV   /* since we're on the _data one */
	};
	GPerlCallback * clear_callback;
	GType clear_param_types[] = {
		GTK_TYPE_CLIPBOARD,
		GPERL_TYPE_SV   /* since we're on the _data one */
	};
	SV * real_user_data;
    CODE:
	GTK2PERL_STACK_ITEMS_TO_TARGET_ENTRY_ARRAY (4, targets, n_targets);
	/* WARNING: since we're piggybacking on the same callback for
	 *    the _with_data and _with_owner forms, the user_data arg
	 *    will go through the standard GSignal user data, and thus
	 *    we'll pass NULL to gperl_callback_new's user_data parameter.
	 *    this is not typical usage. */
	get_callback = gperl_callback_new (get_func, NULL,
	                                   4, get_param_types, G_TYPE_NONE);
	clear_callback = gperl_callback_new (clear_func, NULL,
	                                     2, clear_param_types, G_TYPE_NONE);
	real_user_data = newSVsv (user_data);

	RETVAL = gtk_clipboard_set_with_data (clipboard, targets, n_targets,
	                                      gtk2perl_clipboard_get_func,
	                                      gtk2perl_clipboard_clear_func,
	                                      real_user_data);
	if (!RETVAL) {
		gperl_callback_destroy (get_callback);
		gperl_callback_destroy (clear_callback);
		SvREFCNT_dec (real_user_data);
	} else {
		g_object_set_qdata_full (G_OBJECT (clipboard),
		                         clipboard_get_quark(),
		                         get_callback,
		                         (GDestroyNotify)
		                                gperl_callback_destroy);
		g_object_set_qdata_full (G_OBJECT (clipboard),
		                         clipboard_clear_quark(),
		                         clear_callback,
		                         (GDestroyNotify)
		                                gperl_callback_destroy);
		g_object_set_qdata_full (G_OBJECT (clipboard),
		                         clipboard_user_data_quark (),
		                         real_user_data,
		                         (GDestroyNotify)
		                                gperl_sv_free);
	}
    OUTPUT:
	RETVAL
    CLEANUP:
	g_free (targets);

##  gboolean gtk_clipboard_set_with_owner (GtkClipboard *clipboard, const GtkTargetEntry *targets, guint n_targets, GtkClipboardGetFunc get_func, GtkClipboardClearFunc clear_func, GObject *owner) 
=for apidoc
=for arg target1 (Gtk2::TargetEntry) the first target entry
=for arg ... (__hide__)
=cut
gboolean
gtk_clipboard_set_with_owner (clipboard, get_func, clear_func, owner, target1, ...)
	GtkClipboard *clipboard
	SV * get_func
	SV * clear_func
	GObject *owner
    PREINIT:
	GtkTargetEntry *targets = NULL;
	guint n_targets = 0;
	GPerlCallback * get_callback;
	GType get_param_types[] = {
		GTK_TYPE_CLIPBOARD,
		GTK_TYPE_SELECTION_DATA,
		G_TYPE_UINT,
		G_TYPE_OBJECT   /* since we're on the _owner one */
	};
	GPerlCallback * clear_callback;
	GType clear_param_types[] = {
		GTK_TYPE_CLIPBOARD,
		G_TYPE_OBJECT   /* since we're on the _owner one */
	};
    CODE:
	GTK2PERL_STACK_ITEMS_TO_TARGET_ENTRY_ARRAY (4, targets, n_targets);
	/* WARNING: since we're piggybacking on the same callback for
	 *    the _with_data and _with_owner forms, the owner arg
	 *    will go through the standard GSignal user data, and thus
	 *    we'll pass NULL to gperl_callback_new's user_data parameter.
	 *    this is not typical usage. 
	 *
	 *    you may be thinking that i should just use the same function
	 *    for both forms, like with signal_connect in Glib.  the 
	 *    difference here is that gtk will treat the owner differently --
	 *    you can query the owner -- so we have to call the proper one.
	 *    of course, we could put both of these in the same perl wrapper...
	 */
	get_callback = gperl_callback_new (get_func, NULL,
	                                   4, get_param_types, G_TYPE_NONE);
	clear_callback = gperl_callback_new (clear_func, NULL,
	                                     2, clear_param_types, G_TYPE_NONE);

	RETVAL = gtk_clipboard_set_with_owner (clipboard, targets, n_targets,
	                                       gtk2perl_clipboard_get_func,
	                                       gtk2perl_clipboard_clear_func,
	                                       owner);
	if (!RETVAL) {
		gperl_callback_destroy (get_callback);
		gperl_callback_destroy (clear_callback);
	} else {
		g_object_set_qdata_full (G_OBJECT (clipboard),
		                         clipboard_get_quark(),
		                         get_callback,
		                         (GDestroyNotify)
		                                gperl_callback_destroy);
		g_object_set_qdata_full (G_OBJECT (clipboard),
		                         clipboard_clear_quark(),
		                         clear_callback,
		                         (GDestroyNotify)
		                                gperl_callback_destroy);
	}
    OUTPUT:
	RETVAL

##  GObject *gtk_clipboard_get_owner (GtkClipboard *clipboard) 
###GObject_ornull *
GObject *
gtk_clipboard_get_owner (clipboard)
	GtkClipboard *clipboard

##  void gtk_clipboard_clear (GtkClipboard *clipboard) 
void
gtk_clipboard_clear (clipboard)
	GtkClipboard *clipboard

void gtk_clipboard_set_text (GtkClipboard *clipboard, const gchar_length *text, int length(text)) 

##  void gtk_clipboard_request_contents (GtkClipboard *clipboard, GdkAtom target, GtkClipboardReceivedFunc callback, gpointer user_data) 
void
gtk_clipboard_request_contents (clipboard, target, callback, user_data)
	GtkClipboard *clipboard
	GdkAtom target
	SV * callback
	SV * user_data
    PREINIT:
	GPerlCallback * real_callback;
	GType param_types[] = { GTK_TYPE_CLIPBOARD, GTK_TYPE_SELECTION_DATA };
    CODE:
	real_callback = gperl_callback_new (callback, user_data,
	                                    2, param_types, G_TYPE_NONE);
	g_object_set_qdata_full (G_OBJECT (clipboard),
	                         clipboard_received_quark (),
	                         real_callback,
	                         (GDestroyNotify) gperl_callback_destroy);
	gtk_clipboard_request_contents (clipboard, target, 
	                                gtk2perl_clipboard_received_func,
					real_callback);

##  void gtk_clipboard_request_text (GtkClipboard *clipboard, GtkClipboardTextReceivedFunc callback, gpointer user_data) 
void
gtk_clipboard_request_text (clipboard, callback, user_data)
	GtkClipboard *clipboard
	SV * callback
	SV * user_data
    PREINIT:
	GPerlCallback * real_callback;
	GType param_types[] = {
		GTK_TYPE_CLIPBOARD,
		G_TYPE_STRING
	};
    CODE:
	real_callback = gperl_callback_new (callback, user_data,
	                                    2, param_types, G_TYPE_NONE);
	g_object_set_qdata_full (G_OBJECT (clipboard),
	                         clipboard_text_received_quark (),
	                         real_callback,
	                         (GDestroyNotify) gperl_callback_destroy);
	gtk_clipboard_request_text (clipboard, 
				    gtk2perl_clipboard_text_received_func, 
				    real_callback);

##  GtkSelectionData *gtk_clipboard_wait_for_contents (GtkClipboard *clipboard, GdkAtom target) 
GtkSelectionData_own_ornull *
gtk_clipboard_wait_for_contents (clipboard, target)
	GtkClipboard *clipboard
	GdkAtom target

##  gchar * gtk_clipboard_wait_for_text (GtkClipboard *clipboard) 
gchar *
gtk_clipboard_wait_for_text (clipboard)
	GtkClipboard *clipboard
    CLEANUP:
	g_free (RETVAL);

##  gboolean gtk_clipboard_wait_is_text_available (GtkClipboard *clipboard) 
gboolean
gtk_clipboard_wait_is_text_available (clipboard)
	GtkClipboard *clipboard

#endif /* defined GTK_TYPE_CLIPBOARD */
