/*
 * $Header$
 */

#include "gtk2perl.h"

MODULE = Gtk2::Toolbar	PACKAGE = Gtk2::Toolbar	PREFIX = gtk_toolbar_

## GtkWidget* gtk_toolbar_new (void)
GtkWidget *
gtk_toolbar_new (class)
	SV * class
    C_ARGS:

# TODO: GtkSignalFunc not in typemap
## GtkWidget* gtk_toolbar_prepend_item (GtkToolbar *toolbar, const char *text, const char *tooltip_text, const char *tooltip_private_text, GtkWidget *icon, GtkSignalFunc callback, gpointer user_data)
#GtkWidget *
#gtk_toolbar_prepend_item (toolbar, text, tooltip_text, tooltip_private_text, icon, callback, user_data)
#	GtkToolbar    * toolbar
#	const char    * text
#	const char    * tooltip_text
#	const char    * tooltip_private_text
#	GtkWidget     * icon
#	GtkSignalFunc   callback
#	gpointer        user_data

# TODO: GtkSignalFunc not in typemap
## GtkWidget* gtk_toolbar_insert_item (GtkToolbar *toolbar, const char *text, const char *tooltip_text, const char *tooltip_private_text, GtkWidget *icon, GtkSignalFunc callback, gpointer user_data, gint position)
#GtkWidget *
#gtk_toolbar_insert_item (toolbar, text, tooltip_text, tooltip_private_text, icon, callback, user_data, position)
#	GtkToolbar    * toolbar
#	const char    * text
#	const char    * tooltip_text
#	const char    * tooltip_private_text
#	GtkWidget     * icon
#	GtkSignalFunc   callback
#	gpointer        user_data
#	gint            position

## void gtk_toolbar_prepend_space (GtkToolbar *toolbar)
void
gtk_toolbar_prepend_space (toolbar)
	GtkToolbar * toolbar

## void gtk_toolbar_insert_space (GtkToolbar *toolbar, gint position)
void
gtk_toolbar_insert_space (toolbar, position)
	GtkToolbar * toolbar
	gint         position

## void gtk_toolbar_remove_space (GtkToolbar *toolbar, gint position)
void
gtk_toolbar_remove_space (toolbar, position)
	GtkToolbar * toolbar
	gint         position

# TODO: GtkSignalFunc not in typemap
## GtkWidget* gtk_toolbar_prepend_element (GtkToolbar *toolbar, GtkToolbarChildType type, GtkWidget *widget, const char *text, const char *tooltip_text, const char *tooltip_private_text, GtkWidget *icon, GtkSignalFunc callback, gpointer user_data)
#GtkWidget *
#gtk_toolbar_prepend_element (toolbar, type, widget, text, tooltip_text, tooltip_private_text, icon, callback, user_data)
#	GtkToolbar          * toolbar
#	GtkToolbarChildType   type
#	GtkWidget           * widget
#	const char          * text
#	const char          * tooltip_text
#	const char          * tooltip_private_text
#	GtkWidget           * icon
#	GtkSignalFunc         callback
#	gpointer              user_data

# TODO: GtkSignalFunc not in typemap
## GtkWidget* gtk_toolbar_insert_element (GtkToolbar *toolbar, GtkToolbarChildType type, GtkWidget *widget, const char *text, const char *tooltip_text, const char *tooltip_private_text, GtkWidget *icon, GtkSignalFunc callback, gpointer user_data, gint position)
#GtkWidget *
#gtk_toolbar_insert_element (toolbar, type, widget, text, tooltip_text, tooltip_private_text, icon, callback, user_data, position)
#	GtkToolbar          * toolbar
#	GtkToolbarChildType   type
#	GtkWidget           * widget
#	const char          * text
#	const char          * tooltip_text
#	const char          * tooltip_private_text
#	GtkWidget           * icon
#	GtkSignalFunc         callback
#	gpointer              user_data
#	gint                  position

## void gtk_toolbar_prepend_widget (GtkToolbar *toolbar, GtkWidget *widget, const char *tooltip_text, const char *tooltip_private_text)
void
gtk_toolbar_prepend_widget (toolbar, widget, tooltip_text, tooltip_private_text)
	GtkToolbar * toolbar
	GtkWidget  * widget
	const char * tooltip_text
	const char * tooltip_private_text

## void gtk_toolbar_insert_widget (GtkToolbar *toolbar, GtkWidget *widget, const char *tooltip_text, const char *tooltip_private_text, gint position)
void
gtk_toolbar_insert_widget (toolbar, widget, tooltip_text, tooltip_private_text, position)
	GtkToolbar * toolbar
	GtkWidget  * widget
	const char * tooltip_text
	const char * tooltip_private_text
	gint         position

## void gtk_toolbar_set_style (GtkToolbar *toolbar, GtkToolbarStyle style)
void
gtk_toolbar_set_style (toolbar, style)
	GtkToolbar      * toolbar
	GtkToolbarStyle   style

## void gtk_toolbar_set_icon_size (GtkToolbar *toolbar, GtkIconSize icon_size)
void
gtk_toolbar_set_icon_size (toolbar, icon_size)
	GtkToolbar  * toolbar
	GtkIconSize   icon_size

## void gtk_toolbar_set_tooltips (GtkToolbar *toolbar, gboolean enable)
void
gtk_toolbar_set_tooltips (toolbar, enable)
	GtkToolbar * toolbar
	gboolean     enable

## void gtk_toolbar_unset_style (GtkToolbar *toolbar)
void
gtk_toolbar_unset_style (toolbar)
	GtkToolbar * toolbar

## void gtk_toolbar_unset_icon_size (GtkToolbar *toolbar)
void
gtk_toolbar_unset_icon_size (toolbar)
	GtkToolbar * toolbar

## GtkOrientation gtk_toolbar_get_orientation (GtkToolbar *toolbar)
GtkOrientation
gtk_toolbar_get_orientation (toolbar)
	GtkToolbar * toolbar

## GtkToolbarStyle gtk_toolbar_get_style (GtkToolbar *toolbar)
GtkToolbarStyle
gtk_toolbar_get_style (toolbar)
	GtkToolbar * toolbar

## GtkIconSize gtk_toolbar_get_icon_size (GtkToolbar *toolbar)
GtkIconSize
gtk_toolbar_get_icon_size (toolbar)
	GtkToolbar * toolbar

## gboolean gtk_toolbar_get_tooltips (GtkToolbar *toolbar)
gboolean
gtk_toolbar_get_tooltips (toolbar)
	GtkToolbar * toolbar

##GtkWidget* gtk_toolbar_append_item (GtkToolbar *toolbar, const char *text, const char *tooltip_text, const char *tooltip_private_text, GtkWidget *icon, GtkSignalFunc callback, gpointer user_data)
#GtkWidget *
#gtk_toolbar_append_item (toolbar, text, tooltip_text, tooltip_private_text, icon, callback, user_data)
#	GtkToolbar    * toolbar
#	const char    * text
#	const char    * tooltip_text
#	const char    * tooltop_private_text
#	GtkWidget     * icon
#	GtkSignalFunc   callback
#	gpointer        user_data

##GtkWidget* gtk_toolbar_insert_stock (GtkToolbar *toolbar, const gchar *stock_id, const char *tooltip_text, const char *tooltip_private_text, GtkSignalFunc callback, gpointer user_data, gint position)
#GtkWidget *
#gtk_toolbar_insert_stock (toolbar, stock_id, tooltip_text, tooltip_private_text, callback, user_data, position)
#	GtkToolbar    * toolbar
#	const gchar   * stock_id
#	const char    * tooltip_text
#	const char    * tooltop_private_text
#	GtkSignalFunc   callback
#	gpointer        user_data
#	gint            position


##void gtk_toolbar_append_space (GtkToolbar *toolbar)
void
gtk_toolbar_append_space (toolbar)
	GtkToolbar * toolbar

##GtkWidget* gtk_toolbar_append_element (GtkToolbar *toolbar, GtkToolbarChildType type, GtkWidget *widget, const char *text, const char *tooltip_text, const char *tooltip_private_text, GtkWidget *icon, GtkSignalFunc callback, gpointer user_data)
#GtkWidget *
#gtk_toolbar_append_element (toolbar, type, widget, text, tooltip_text, tooltip_private_text, icon, callback, user_data)
#	GtkToolbar          * toolbar
#	GtkToolbarChildType * type
#	GtkWidget           * widget
#	const char          * text
#	const char          * tooltip_text
#	const char          * tooltip_private_text
#	GtkWidget           * icon
#	GtkSignalFunc         callback
#	gpointer              user_data

##void gtk_toolbar_append_widget (GtkToolbar *toolbar, GtkWidget *widget, const char *tooltip_text, const char *tooltip_private_text)
void
gtk_toolbar_append_widget (toolbar, widget, tooltip_text, tooltip_private_text)
	GtkToolbar * toolbar
	GtkWidget  * widget
	const char * tooltip_text
	const char * tooltip_private_text

##void gtk_toolbar_set_orientation (GtkToolbar *toolbar, GtkOrientation orientation)
void
gtk_toolbar_set_orientation (toolbar, orientation)
	GtkToolbar     * toolbar
	GtkOrientation   orientation

