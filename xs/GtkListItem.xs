#include "gtk2perl.h"

MODULE = Gtk2::Foo	PACKAGE = Gtk2::Foo	PREFIX = gtk_foo_

##  GtkWidget* gtk_list_item_new (void) 
##  GtkWidget* gtk_list_item_new_with_label (const gchar *label) 
GtkWidget *
gtk_list_item_new (class, label=NULL)
	SV    * class
	gchar * label
    CODE:
	if( label )
		RETVAL = gtk_list_item_new_with_label(label);
	else
		RETVAL = gtk_list_item_new();
    OUTPUT:
	RETVAL

##  void gtk_list_item_select (GtkListItem *list_item) 
void
gtk_list_item_select (list_item)
	GtkListItem * list_item

##  void gtk_list_item_deselect (GtkListItem *list_item) 
void
gtk_list_item_deselect (list_item)
	GtkListItem * list_item

