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
 * a custom marshaler for the item factory callbacks
 */
static void
gtk2perl_item_factory_item_activate (gpointer    nothing,
				     guint       callback_action,
				     GtkWidget * widget)
{
	SV    * callback_sv;
	SV    * callback_data;

	dSP; 

	/* the the callback and it's data out of the widget */
	callback_sv = (SV*)g_object_get_data (
				G_OBJECT (widget), "_callback_sv");
	callback_data = (SV*)g_object_get_data (
				G_OBJECT (widget), "_callback_data");

	ENTER;
	SAVETMPS;

	PUSHMARK (SP);
	/* put the parameters on the stack (we're always type 1) */
	EXTEND (SP, 3);
	PUSHs (sv_2mortal (newSVsv (callback_data
	                            ? callback_data
	       	                    : &PL_sv_undef)));
	PUSHs (sv_2mortal (newSViv (callback_action)));
	PUSHs (sv_2mortal (newSVGtkWidget (widget)));
	PUTBACK;

	/* call the code in sv */
	call_sv (callback_sv, G_DISCARD);

	FREETMPS;
	LEAVE;
}


MODULE = Gtk2::ItemFactory	PACKAGE = Gtk2::ItemFactory	PREFIX = gtk_item_factory_


##  GtkItemFactory* gtk_item_factory_new (GType container_type, const gchar *path, GtkAccelGroup *accel_group) 
GtkItemFactory*
gtk_item_factory_new (class, container_type_package, path, accel_group)
	SV * class
	char * container_type_package
	const gchar *path
	GtkAccelGroup_ornull *accel_group
    PREINIT:
	GType container_type;
    CODE:
	UNUSED(class);
	container_type = gperl_type_from_package (container_type_package);
	RETVAL = gtk_item_factory_new (container_type, path, accel_group);
    OUTPUT:
	RETVAL

### deprecated
##  void gtk_item_factory_add_foreign (GtkWidget *accel_widget, const gchar *full_path, GtkAccelGroup *accel_group, guint keyval, GdkModifierType modifiers) 

GtkItemFactory_ornull*
gtk_item_factory_from_widget (class, widget)
	SV * class
	GtkWidget *widget
    C_ARGS:
	widget
    CLEANUP:
	UNUSED(class);

const gchar*
gtk_item_factory_path_from_widget (class, widget)
	SV * class
	GtkWidget *widget
    C_ARGS:
	widget
    CLEANUP:
	UNUSED(class);

GtkWidget_ornull*
gtk_item_factory_get_item (ifactory, path)
	GtkItemFactory *ifactory
	const gchar *path

GtkWidget_ornull*
gtk_item_factory_get_widget (ifactory, path)
	GtkItemFactory *ifactory
	const gchar *path

GtkWidget_ornull*
gtk_item_factory_get_widget_by_action (ifactory, action)
	GtkItemFactory *ifactory
	guint action

GtkWidget_ornull*
gtk_item_factory_get_item_by_action (ifactory, action)
	GtkItemFactory *ifactory
	guint action


### this is called by Gtk2::IconFactory::create_item, which is implemented
### in perl and mangles the arguments for us.
void
_create_item (ifactory, path, accelerator, callback_action, item_type, extra_data, clean_path, callback_sv, callback_data)
	GtkItemFactory * ifactory
	gchar * path
	gchar * accelerator
	gint    callback_action
	gchar * item_type
	SV    * extra_data
	char  * clean_path
	SV    * callback_sv
	SV    * callback_data
    PREINIT:
	GtkItemFactoryEntry   entry = {0, };
	GtkWidget           * widget = NULL;
    CODE:
	entry.path = path;
	entry.accelerator = accelerator;
	/* start out with no callback, we'll probably add one in a min */
	entry.callback = NULL;
	entry.callback_action = callback_action;
	entry.item_type = item_type;
	entry.extra_data = SvPOK (extra_data) ? SvGChar (extra_data) : NULL; 

	/* if the user supplied a callback then we'll need to call our
	 * marshaler in order to call it */
	if( SvTRUE(callback_sv) )
		entry.callback = gtk2perl_item_factory_item_activate;

	/* create the item in the normal manner now */
	gtk_item_factory_create_item (ifactory, &entry, NULL, 1);
	
	/* get the widget that was created by create_item (this is why
	 * we needed clean_path) */
	widget = gtk_item_factory_get_item (ifactory, clean_path);
	if ( widget )
	{
		/* put the sv we need to call into the widget */
		g_object_set_data_full (G_OBJECT (widget), "_callback_sv", 
					(gpointer)gperl_sv_copy(callback_sv),
				        (GtkDestroyNotify)gperl_sv_free);
		
		/* and put the callback data in there as well */
		g_object_set_data_full (G_OBJECT (widget), "_callback_data", 
					(gpointer)gperl_sv_copy(callback_data),
					(GtkDestroyNotify)gperl_sv_free);
	}
	else
		croak("ItemFactory couldn't retrieve widget it just created");


###### implemented in perl, see Gtk2.pm
#####  void gtk_item_factory_create_items (GtkItemFactory *ifactory, guint n_entries, GtkItemFactoryEntry *entries, gpointer callback_data) 

void
gtk_item_factory_delete_item (ifactory, path)
	GtkItemFactory *ifactory
	const gchar *path

#### FIXME how to handle GtkItemFactoryEntry?:
###  void gtk_item_factory_delete_entry (GtkItemFactory *ifactory, GtkItemFactoryEntry *entry) 
#void
#gtk_item_factory_delete_entry (ifactory, entry)
#	GtkItemFactory *ifactory
#	GtkItemFactoryEntry *entry

#### FIXME how to handle GtkItemFactoryEntry?:
#### FIXME get entries from stack or anon array?:  definitely no n_entries
###  void gtk_item_factory_delete_entries (GtkItemFactory *ifactory, guint n_entries, GtkItemFactoryEntry *entries) 
#void
#gtk_item_factory_delete_entries (ifactory, n_entries, entries)
#	GtkItemFactory *ifactory
#	guint n_entries
#	GtkItemFactoryEntry *entries


##  void gtk_item_factory_popup (GtkItemFactory *ifactory, guint x, guint y, guint mouse_button, guint32 time_) 
##  void gtk_item_factory_popup_with_data(GtkItemFactory *ifactory, gpointer popup_data, GtkDestroyNotify destroy, guint x, guint y, guint mouse_button, guint32 time_) 

### combination of gtk_item_factory_popup and gtk_item_factory_popup_with_data
void
gtk_item_factory_popup (ifactory, x, y, mouse_button, time_, popup_data=NULL)
	GtkItemFactory *ifactory
	guint x
	guint y
	guint mouse_button
	guint32 time_
	SV * popup_data
    PREINIT:
	SV * real_popup_data = NULL;
    CODE:
	if (popup_data && popup_data != &PL_sv_undef)
		real_popup_data = gperl_sv_copy (popup_data);
	gtk_item_factory_popup_with_data (ifactory,
	                                  real_popup_data, 
	                                  real_popup_data
	                                   ? (GDestroyNotify)gperl_sv_free
	                                   : NULL, 
	                                  x, y, mouse_button, time_);

### FIXME these will need special handling to fetch the data set
###       by $item_factory->popup
###  gpointer gtk_item_factory_popup_data (GtkItemFactory *ifactory) 
#gpointer
#gtk_item_factory_popup_data (ifactory)
#	GtkItemFactory *ifactory

###  gpointer gtk_item_factory_popup_data_from_widget (GtkWidget *widget) 
#gpointer
#gtk_item_factory_popup_data_from_widget (widget)
#	GtkWidget *widget

# FIXME
###  void gtk_item_factory_set_translate_func (GtkItemFactory *ifactory, GtkTranslateFunc func, gpointer data, GtkDestroyNotify notify) 
#void
#gtk_item_factory_set_translate_func (ifactory, func, data, notify)
#	GtkItemFactory *ifactory
#	GtkTranslateFunc func
#	gpointer data
#	GtkDestroyNotify notify


##
## deprecated
##
##  void gtk_item_factory_create_items_ac (GtkItemFactory *ifactory, guint n_entries, GtkItemFactoryEntry *entries, gpointer callback_data, guint callback_type) 
##  GtkItemFactory* gtk_item_factory_from_path (const gchar *path) 
##  void gtk_item_factory_create_menu_entries (guint n_entries, GtkMenuEntry *entries) 
##  void gtk_item_factories_path_delete (const gchar *ifactory_path, const gchar *path) 
