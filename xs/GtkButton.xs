/*
 * $Header$
 */

#include "gtk2perl.h"

MODULE = Gtk2::Button	PACKAGE = Gtk2::Button	PREFIX = gtk_button_

GtkWidget *
gtk_button_news (class, label=NULL)
	SV * class
	const gchar * label
    ALIAS:
	Gtk2::Button::new = 0
	Gtk2::Button::new_with_mnemonic = 1
    CODE:
	if (label)
		RETVAL = gtk_button_new_with_mnemonic (label);
	else
		RETVAL = gtk_button_new ();
    OUTPUT:
	RETVAL

GtkWidget *
gtk_button_new_with_label (class, label)
	SV * class
	const gchar * label
    C_ARGS:
	label

GtkWidget *
gtk_button_new_from_stock (class, stock_id)
	SV * class
	const gchar * stock_id
    C_ARGS:
	stock_id

void
gtk_button_pressed (button)
	GtkButton * button

void
gtk_button_released (button)
	GtkButton * button

void
gtk_button_clicked (button)
	GtkButton * button

void
gtk_button_enter (button)
	GtkButton * button

void
gtk_button_leave (button)
	GtkButton * button

void
gtk_button_set_relief (button, newstyle)
	GtkButton * button
	GtkReliefStyle  newstyle

GtkReliefStyle
gtk_button_get_relief (button)
	GtkButton * button


void
gtk_button_set_label (button, label)
	GtkButton * button
	const gchar * label

# had G_CONST_RETURN
const gchar *
gtk_button_get_label (button)
	GtkButton * button

void
gtk_button_set_use_underline (button, use_underline)
	GtkButton * button
	gboolean     use_underline

gboolean
gtk_button_get_use_underline (button)
	GtkButton * button

void
gtk_button_set_use_stock (button, use_stock)
	GtkButton * button
	gboolean     use_stock

gboolean
gtk_button_get_use_stock (button)
	GtkButton * button
