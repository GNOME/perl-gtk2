/*
 * $Header$
 */

#include "gtk2perl.h"

MODULE = Gtk2::ImageMenuItem	PACKAGE = Gtk2::ImageMenuItem	PREFIX = gtk_image_menu_item_

## GtkWidget* gtk_image_menu_item_new (void)
## GtkWidget* gtk_image_menu_item_new_with_mnemonic (const gchar *label)
GtkWidget *
gtk_image_menu_item_news (class, label=NULL)
	SV * class
	const gchar * label
    ALIAS:
	Gtk2::ImageMenuItem::new = 0
	Gtk2::ImageMenuItem::new_with_mnemonic = 1
    CODE:
	if( label )
		RETVAL = gtk_image_menu_item_new_with_mnemonic(label);
	else
		RETVAL = gtk_image_menu_item_new();
    OUTPUT:
	RETVAL

## GtkWidget* gtk_image_menu_item_new_with_label (const gchar *label)
GtkWidget *
gtk_image_menu_item_new_with_label (class, label)
	SV          * class
	const gchar * label
    C_ARGS:
	label

## GtkWidget* gtk_image_menu_item_new_from_stock (const gchar *stock_id, GtkAccelGroup *accel_group)
GtkWidget *
gtk_image_menu_item_new_from_stock (class, stock_id, accel_group)
	SV            * class
	const gchar   * stock_id
	GtkAccelGroup * accel_group
    C_ARGS:
	stock_id, accel_group

## void gtk_image_menu_item_set_image (GtkImageMenuItem *image_menu_item, GtkWidget *image)
void
gtk_image_menu_item_set_image (image_menu_item, image)
	GtkImageMenuItem * image_menu_item
	GtkWidget        * image

## GtkWidget* gtk_image_menu_item_get_image (GtkImageMenuItem *image_menu_item)
GtkWidget *
gtk_image_menu_item_get_image (image_menu_item)
	GtkImageMenuItem * image_menu_item

