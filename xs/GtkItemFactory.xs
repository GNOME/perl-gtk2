#include "gtk2perl.h"


/*
 * whee!  since the Callback1 form does not have data at the end and all that
 * fun stuff, so we can't use the spiffy generic GPerlCallback marshaller i
 * just wrote, or even the GPerlClosure stuff that would be rather useful.
 */
static void
gtk2perl_item_factory_item_activate (GtkWidget * widget,
                                     GPerlCallback * callback)
{
	guint callback_action;
	SV * data;
	dSP; 

	if (callback->func == NULL || callback->func == &PL_sv_undef)
		return;

	callback_action = (guint)
		g_object_get_data (G_OBJECT (widget), "_callback_action");

	ENTER;
	SAVETMPS;

	PUSHMARK (SP);
	XPUSHs (callback->data ? callback->data : &PL_sv_undef);
	XPUSHs (sv_2mortal (newSViv (callback_action)));
	XPUSHs (sv_2mortal (newSVGtkWidget (widget)));
	PUTBACK;

	call_sv (callback->func, G_DISCARD);

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

const gchar*
gtk_item_factory_path_from_widget (class, widget)
	SV * class
	GtkWidget *widget
    C_ARGS:
	widget

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
_create_item (ifactory, path, accel, action, type, extra, clean_path, callback_sv, callback_data)
	GtkItemFactory * ifactory
	gchar * path
	gchar * accel
	gint action
	gchar * type
	SV * extra
	char * clean_path
	SV * callback_sv
	SV * callback_data
    PREINIT:
	GtkItemFactoryEntry entry = {0, };
    CODE:
	entry.path = path;
	entry.accelerator = accel;
	entry.callback = NULL;
	entry.callback_action = action;
	entry.item_type = type;
	entry.extra_data = extra; /* FIXME this will leak!!  need to honor
	                             this only when useful (see docs) */
	gtk_item_factory_create_item (ifactory, &entry, NULL, 1);
	if (callback_sv && callback_sv != &PL_sv_undef) {
		/* set up the callback.  we need to pass two bits of data.  
		 * rather than add yet another ugly hack to GPerlClosure, 
		 * we'll use a GPerlCallback. */
		GPerlCallback * callback;
		GtkWidget * widget;

		widget = gtk_item_factory_get_item (ifactory, clean_path);

		/* we'll be marshalling this ourselves, so don't worry about
		 * the argtypes array. */
		callback = gperl_callback_new (callback_sv, callback_data,
		                               0, NULL, 0);

		g_object_set_data (G_OBJECT (widget), "_callback_action", 
		                   (gpointer)action);

		g_signal_connect_data (G_OBJECT (widget), "activate",
		             G_CALLBACK (gtk2perl_item_factory_item_activate),
			     callback,
			     (GClosureNotify)gperl_callback_destroy,
		             0);
	}


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


###  gpointer gtk_item_factory_popup_data (GtkItemFactory *ifactory) 
#gpointer
#gtk_item_factory_popup_data (ifactory)
#	GtkItemFactory *ifactory

###  gpointer gtk_item_factory_popup_data_from_widget (GtkWidget *widget) 
#gpointer
#gtk_item_factory_popup_data_from_widget (widget)
#	GtkWidget *widget

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
