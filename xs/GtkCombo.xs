/*
 * $Header$
 */

#include "gtk2perl.h"

MODULE = Gtk2::Combo	PACKAGE = Gtk2::Combo	PREFIX = gtk_combo_

## GtkWidget* gtk_combo_new (void)
GtkWidget*
gtk_combo_new (class)
	SV * class
    C_ARGS:

## void gtk_combo_disable_activate (GtkCombo* combo)
void
gtk_combo_disable_activate (combo)
	GtkCombo * combo

##void gtk_combo_set_value_in_list (GtkCombo* combo, gboolean val, gboolean ok_if_empty)
void
gtk_combo_set_value_in_list (combo, val, ok_if_empty)
	GtkCombo * combo
	gboolean   val
	gboolean   ok_if_empty

##void gtk_combo_set_use_arrows (GtkCombo* combo, gboolean val)
void
gtk_combo_set_use_arrows (combo, val)
	GtkCombo * combo
	gboolean   val

##void gtk_combo_set_use_arrows_always (GtkCombo* combo, gboolean val)
void
gtk_combo_set_use_arrows_always (combo, val)
	GtkCombo * combo
	gboolean   val

##void gtk_combo_set_case_sensitive (GtkCombo* combo, gboolean val)
void
gtk_combo_set_case_sensitive (combo, val)
	GtkCombo * combo
	gboolean   val

##void gtk_combo_set_item_string (GtkCombo* combo, GtkItem* item, const gchar* item_value)
void
gtk_combo_set_item_string (combo, item, item_value)
	GtkCombo * combo
	GtkItem  * item
	gchar    * item_value

##void gtk_combo_set_popdown_strings (GtkCombo* combo, GList *strings)
void
gtk_combo_set_popdown_strings (combo, ...)
	GtkCombo * combo
    PREINIT:
	GList * strings = NULL;
    CODE:
	for( items--; items > 0; items-- )
		strings = g_list_prepend(strings, SvPV_nolen(ST(items)));
	if( strings )
	{
		gtk_combo_set_popdown_strings(combo, strings);
		g_list_free(strings);
	}

GtkWidget *
members (combo)
	GtkCombo * combo
    ALIAS:
	Gtk2::Combo::entry = 1
	Gtk2::Combo::list  = 2
    CODE:
	switch (ix) {
	    case 1: RETVAL = combo->entry; break;
	    case 2: RETVAL = combo->list;  break;
	}
    OUTPUT:
	RETVAL

