#include "gtk2perl.h"

MODULE = Gtk2::Item	PACKAGE = Gtk2::Item	PREFIX = gtk_item_

## void gtk_item_select (GtkItem *item)
void
gtk_item_select (item)
	GtkItem * item

## void gtk_item_deselect (GtkItem *item)
void
gtk_item_deselect (item)
	GtkItem * item

## void gtk_item_toggle (GtkItem *item)
void
gtk_item_toggle (item)
	GtkItem * item

