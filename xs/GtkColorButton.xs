#include "gtk2perl.h"
 
MODULE = Gtk2::ColorButton	PACKAGE = Gtk2::ColorButton	PREFIX = gtk_color_button_

## GtkWidget *gtk_color_button_new (void);
## GtkWidget *gtk_color_button_new_with_color (GdkColor *color);
GtkWidget *
gtk_color_button_new (class, GdkColor*color=NULL)
    ALIAS:
	new_with_color = 1
    CODE:
	if (ix == 1)
		RETVAL = gtk_color_button_new_with_color (color);
	else
		RETVAL = gtk_color_button_new ();
    OUTPUT:
	RETVAL

void gtk_color_button_set_color (GtkColorButton *color_button, GdkColor *color);

void gtk_color_button_set_alpha (GtkColorButton *color_button, guint16 alpha);

void gtk_color_button_get_color (GtkColorButton *color_button, GdkColor *color);

guint16 gtk_color_button_get_alpha (GtkColorButton *color_button);

void gtk_color_button_set_use_alpha (GtkColorButton *color_button, gboolean use_alpha);

gboolean gtk_color_button_get_use_alpha (GtkColorButton *color_button);

void gtk_color_button_set_title (GtkColorButton *color_button, const gchar *title);

const gchar *gtk_color_button_get_title (GtkColorButton *color_button);

