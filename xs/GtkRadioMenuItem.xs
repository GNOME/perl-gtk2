/*
 * $Header$
 */

#include "gtk2perl.h"

MODULE = Gtk2::RadioMenuItem	PACKAGE = Gtk2::RadioMenuItem	PREFIX = gtk_radio_menu_item_

# TODO: GSList not in typemap
## GtkWidget* gtk_radio_menu_item_new (GSList *group)
## GtkWidget* gtk_radio_menu_item_new_with_label (GSList *group, const gchar *label)
#GtkWidget *
#gtk_radio_menu_item_new (class, group, label=NULL)
#	SV          * class
#	GSList      * group
#	const gchar * label
#  CODE:
##	if( label )
#	{
#		RETVAL = gtk_radio_menu_item_new(group);
#	}
##	else
#	{
#		RETVAL = gtk_radio_menu_item_new_with_label(group, label);
#	}
#    OUTPUT:
#	RETVAL

# TODO: GSList not in typemap
## GtkWidget* gtk_radio_menu_item_new_with_mnemonic (GSList *group, const gchar *label)
#GtkWidget *
#gtk_radio_menu_item_new_with_mnemonic (group, label)
#	GSList      * group
#	const gchar * label

# TODO: GSList not in typemap
## GSList* gtk_radio_menu_item_get_group (GtkRadioMenuItem *radio_menu_item)
#GSList *
#gtk_radio_menu_item_get_group (radio_menu_item)
#	GtkRadioMenuItem * radio_menu_item

# TODO: GSList not in typemap
## void gtk_radio_menu_item_set_group (GtkRadioMenuItem *radio_menu_item, GSList *group)
#void
#gtk_radio_menu_item_set_group (radio_menu_item, group)
#	GtkRadioMenuItem * radio_menu_item
#	GSList           * group

