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

MODULE = Gtk2::Gdk::Keys PACKAGE = Gtk2::Gdk::Keymap PREFIX = gtk_keymap_

##  GdkKeymap* gdk_keymap_get_default (void) 
GdkKeymap*
gdk_keymap_get_default (class)
    C_ARGS:
	/* (void) */

#if GTK_CHECK_VERSION(2,2,0)

##  GdkKeymap* gdk_keymap_get_for_display (GdkDisplay *display) 
GdkKeymap*
gdk_keymap_get_for_display (class, display)
	GdkDisplay *display
    C_ARGS:
	display

#endif

##guint
##gdk_keymap_lookup_key (keymap, key)
##	GdkKeymap          * keymap
##	const GdkKeymapKey * key

##  gboolean gdk_keymap_translate_keyboard_state (GdkKeymap *keymap, guint hardware_keycode, GdkModifierType state, gint group, guint *keyval, gint *effective_group, gint *level, GdkModifierType *consumed_modifiers) 
=for apidoc
=for signature (keyval, effective_group,level, consumed_modifiers) = $keymap->translate_keyboard_state (hardware_keycode, state, group)
=cut
void
gdk_keymap_translate_keyboard_state (keymap, hardware_keycode, state, group)
	GdkKeymap       * keymap
	guint             hardware_keycode
	GdkModifierType   state
	gint              group
    PREINIT:
	guint           keyval;
	gint            effective_group;
	gint            level;
	GdkModifierType consumed_modifiers;
    PPCODE:
	if (!gdk_keymap_translate_keyboard_state (keymap, hardware_keycode, 
						  state, group, &keyval, 
						  &effective_group, &level,
						  &consumed_modifiers))
		XSRETURN_EMPTY;
	EXTEND (SP, 4);
	PUSHs (sv_2mortal (newSViv (keyval)));
	PUSHs (sv_2mortal (newSViv (effective_group)));
	PUSHs (sv_2mortal (newSViv (level)));
	PUSHs (sv_2mortal (newSVGdkModifierType (consumed_modifiers)));

##  gboolean gdk_keymap_get_entries_for_keyval (GdkKeymap *keymap, guint keyval, GdkKeymapKey **keys, gint *n_keys) 
##=for apidoc
##=for signature keys = $keymap->get_entries_for_keyval (keyval)
##Returns keys, a list of Gtk2::GdkKeymapkey's.
##
##Obtains a list of keycode/group/level combinations that will generate keyval. Groups and levels are two kinds of keyboard mode; in general, the level determines whether the top or bottom symbol on a key is used, and the group determines whether the left or right symbol is used. On US keyboards, the shift key changes the keyboard level, and there are no groups. A group switch key might convert a keyboard between Hebrew to English modes, for example. GdkEventKey contains a group field that indicates the active keyboard group. The level is computed from the modifier mask.
##=cut
##void
##gdk_keymap_get_entries_for_keyval (keymap, keyval)
##	GdkKeymap    *  keymap
##	guint           keyval
##    PREINIT:
##	GdkKeymapKey * keys;
##	gint           n_keys;
##	int            i;
##    PPCODE:
##	if (!gdk_keymap_get_entries_for_keyval (keymap, keyval, &keys, &n_keys))
##		XSRETURN_EMPTY;
##	EXTEND (SP, n_keys);
##	for ( i = 0; items = n_keys; n_keys--)
##		PUSHs (sv_2mortal (newGdkKeymapKey (keys[i])));
##	g_free (keys);

##  gboolean gdk_keymap_get_entries_for_keycode (GdkKeymap *keymap, guint hardware_keycode, GdkKeymapKey **keys, guint **keyvals, gint *n_entries) 
##=for apidoc
##=for signature ({key1, keyval1 }, {...}) = $keymap->get_entires_for_keycode ($hardware_keycode)
##=cut
##void
##gdk_keymap_get_entries_for_keycode (keymap, hardware_keycode)
##	GdkKeymap * keymap
##	guint       hardware_keycode
##    PREINIT:
##	GdkKeymapKey * keys;
##	guint        * keyvals;
##	gint           n_entries;
##	int            i;
##	HV           * hv;
##    PPCODE:
##	if (!gdk_keymap_get_entries_for_keycode (keymap, hardware_keycode, 
##						 &keys, &keyvals, &n_entries))
##		XSRETURN_EMPTY;
##	EXTEND (SP, n_entries);
##	for (i = 0; i < n_entries; i++)
##	{
##		hv = newHV ();
##		hv_store (hv, "key", 3, newGdkKeymapKey (keys[i]), 0);
##		hv_store (hv, "keyval", 6, newSViv (keyvals[i]), 0);
##		XPUSHs (sv_2mortal (newRV_noinc ((SV*) hv)));
##	}
	
PangoDirection
gdk_keymap_get_direction (keymap)
	GdkKeymap *keymap


MODULE = Gtk2::Gdk::Keys PACKAGE = Gtk2::Gdk PREFIX = gdk_

gchar *
gdk_keyval_name (class, keyval)
	guint keyval
    C_ARGS:
	keyval

##  guint gdk_keyval_from_name (const gchar *keyval_name) 
guint
gdk_keyval_from_name (class, keyval_name)
	const gchar * keyval_name
    C_ARGS:
	keyval_name

##  void gdk_keyval_convert_case (guint symbol, guint *lower, guint *upper) 
=for apidoc
=for signature (lower, upper) = Gtk2::Gdk::Keyval->convert_case ($symbol)
=cut
void
gdk_keyval_convert_case (class, symbol)
	guint symbol
    PREINIT:
	guint lower;
	guint upper;
    PPCODE:
	gdk_keyval_convert_case (symbol, &lower, &upper);
	EXTEND (SP, 2);
	PUSHs (sv_2mortal (newSViv (lower)));
	PUSHs (sv_2mortal (newSViv (upper)));

##  guint gdk_keyval_to_upper (guint keyval) G_GNUC_CONST 
guint
gdk_keyval_to_upper (class, keyval)
	guint keyval
    C_ARGS:
	keyval

##  guint gdk_keyval_to_lower (guint keyval) G_GNUC_CONST 
guint
gdk_keyval_to_lower (class, keyval)
	guint keyval
    C_ARGS:
	keyval

##  gboolean gdk_keyval_is_upper (guint keyval) G_GNUC_CONST 
gboolean
gdk_keyval_is_upper (class, keyval)
	guint keyval
    C_ARGS:
	keyval

##  gboolean gdk_keyval_is_lower (guint keyval) G_GNUC_CONST 
gboolean
gdk_keyval_is_lower (class, keyval)
	guint keyval
    C_ARGS:
	keyval

##  guint32 gdk_keyval_to_unicode (guint keyval) G_GNUC_CONST 
guint32
gdk_keyval_to_unicode (class, keyval)
	guint keyval
    C_ARGS:
	keyval

##  guint gdk_unicode_to_keyval (guint32 wc) G_GNUC_CONST 
guint
gdk_unicode_to_keyval (class, wc)
	guint32 wc
    C_ARGS:
	wc

