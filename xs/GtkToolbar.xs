/*
 * Copyright (c) 2003 by the gtk2-perl team (see the file AUTHORS)
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Library General Public
 * License as published by the Free Software Foundation; either
 * version 2.1 of the License, or (at your option) any later version.
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
most of the insert/append/prepend functions do the same thing with one minor
change, or a change of signature.  all of them (except the ones dealing with
spaces because they're trivial) are corralled through 
gtk2perl_toolbar_insert_internal in a vain attempt to reduce code bloat
and duplicated code.
*/


typedef enum {
	ITEM,
	STOCK,
	ELEMENT,
	WIDGET
} WhichInsert;

typedef enum {
	PREPEND,
	APPEND,
	INSERT,
} WhichOp;

static GtkWidget *
gtk2perl_toolbar_insert_internal (GtkToolbar * toolbar,
                                  SV * type,
				  SV * widget,
                                  SV * text,
				  SV * tooltip_text,
				  SV * tooltip_private_text,
				  SV * icon,
				  SV * callback,
				  SV * user_data,
				  SV * position,
				  WhichInsert which,
				  WhichOp op)
{
	GtkWidget * w = NULL;
	const char * real_tooltip_text = NULL;
	const char * real_tooltip_private_text = NULL;

	if (tooltip_text && tooltip_text != &PL_sv_undef)
		real_tooltip_text = SvGChar (tooltip_text);

	if (tooltip_private_text && tooltip_private_text != &PL_sv_undef)
		real_tooltip_private_text = SvGChar (tooltip_private_text);

	switch (which) {
	    case STOCK:
		w = gtk_toolbar_insert_stock (toolbar, SvGChar (text),
		                              real_tooltip_text,
		                              real_tooltip_private_text,
		                              NULL, NULL, 
		                              SvIV (position));
		break;
	    case ITEM:
		{
		const gchar * real_text = SvGChar (text);
		GtkWidget * real_icon = SvGtkWidget_ornull (icon);
		switch (op) {
		    case PREPEND:
			w = gtk_toolbar_prepend_item (toolbar, real_text,
			                             real_tooltip_text,
			                             real_tooltip_private_text,
			                             real_icon, NULL, NULL);
			break;
		    case APPEND:
			w = gtk_toolbar_append_item (toolbar, real_text,
			                             real_tooltip_text,
			                             real_tooltip_private_text,
			                             real_icon, NULL, NULL);
			break;
		    case INSERT:
			w = gtk_toolbar_insert_item (toolbar, real_text,
			                             real_tooltip_text,
			                             real_tooltip_private_text,
			                             real_icon, NULL, NULL, 
			                             SvIV (position));
			break;
		}
		}
		break;
	    case ELEMENT:
		{
		GtkToolbarChildType real_type = SvGtkToolbarChildType(type);
		const gchar * real_text = SvGChar (text);
		GtkWidget * real_widget = SvGtkWidget_ornull (widget);
		GtkWidget * real_icon = SvGtkWidget_ornull (icon);
		switch (op) {
		    case PREPEND:
			w = gtk_toolbar_prepend_element (toolbar, real_type,
			                                 real_widget,
							 real_text,
							 real_tooltip_text,
							 real_tooltip_private_text,
							 real_icon,
							 NULL, NULL);
			break;
		    case APPEND:
			w = gtk_toolbar_append_element (toolbar, real_type,
			                                real_widget,
						        real_text,
						        real_tooltip_text,
						        real_tooltip_private_text,
						        real_icon,
						        NULL, NULL);
			break;
		    case INSERT:
			w = gtk_toolbar_insert_element (toolbar, real_type,
			                                real_widget,
						        real_text,
						        real_tooltip_text,
						        real_tooltip_private_text,
						        real_icon,
						        NULL, NULL,
			                                SvIV (position));
			break;
		}
		}
		break;
	    case WIDGET:
		{
		w = SvGtkWidget_ornull (widget);
		switch (op) {
		    case PREPEND:
			gtk_toolbar_prepend_widget (toolbar, w,
			                            real_tooltip_text,
			                            real_tooltip_private_text);
			break;
		    case APPEND:
			gtk_toolbar_append_widget (toolbar, w,
			                           real_tooltip_text,
			                           real_tooltip_private_text);
			break;
		    case INSERT:
			gtk_toolbar_insert_widget (toolbar, w,
			                           real_tooltip_text,
			                           real_tooltip_private_text,
						   SvIV (position));
			break;
		}
		}
		break;
	}
	if (callback && callback != &PL_sv_undef)
		gperl_signal_connect (newSVGtkWidget (w), "clicked",
		                      callback, user_data, 0);

	return w;
}


MODULE = Gtk2::Toolbar	PACKAGE = Gtk2::Toolbar	PREFIX = gtk_toolbar_

## GtkWidget* gtk_toolbar_new (void)
GtkWidget *
gtk_toolbar_new (class)
	SV * class
    C_ARGS:
	/* void */
    CLEANUP:
	UNUSED(class);

##GtkWidget* gtk_toolbar_append_item (GtkToolbar *toolbar, const char *text, const char *tooltip_text, const char *tooltip_private_text, GtkWidget *icon, GtkSignalFunc callback, gpointer user_data)
GtkWidget *
gtk_toolbar_append_item (toolbar, text, tooltip_text, tooltip_private_text, icon, callback=NULL, user_data=NULL)
	GtkToolbar * toolbar
	SV         * text
	SV         * tooltip_text
	SV         * tooltip_private_text
	SV         * icon
	SV         * callback
	SV         * user_data
    CODE:
	RETVAL = gtk2perl_toolbar_insert_internal (toolbar,
	                                           NULL, /* type */
	                                           NULL, /* widget */
	                                           text,
	                                           tooltip_text,
	                                           tooltip_private_text,
	                                           icon,
	                                           callback,
	                                           user_data,
	                                           NULL, /* position */
	                                           ITEM,
	                                           APPEND);
    OUTPUT:
	RETVAL

## GtkWidget* gtk_toolbar_prepend_item (GtkToolbar *toolbar, const char *text, const char *tooltip_text, const char *tooltip_private_text, GtkWidget *icon, GtkSignalFunc callback, gpointer user_data)
GtkWidget *
gtk_toolbar_prepend_item (toolbar, text, tooltip_text, tooltip_private_text, icon, callback=NULL, user_data=NULL)
	GtkToolbar * toolbar
	SV         * text
	SV         * tooltip_text
	SV         * tooltip_private_text
	SV         * icon
	SV         * callback
	SV         * user_data
    CODE:
	RETVAL = gtk2perl_toolbar_insert_internal (toolbar,
	                                           NULL, /* type */
	                                           NULL, /* widget */
	                                           text,
	                                           tooltip_text,
	                                           tooltip_private_text,
	                                           icon,
	                                           callback,
	                                           user_data,
	                                           NULL, /* position */
	                                           ITEM,
	                                           PREPEND);
    OUTPUT:
	RETVAL


GtkWidget *
gtk_toolbar_insert_item (toolbar, text, tooltip_text, tooltip_private_text, icon, callback, user_data, position)
	GtkToolbar    * toolbar
	SV            * text
	SV            * tooltip_text
	SV            * tooltip_private_text
	SV            * icon
	SV            * callback
	SV            * user_data
	SV            * position
    CODE:
	RETVAL = gtk2perl_toolbar_insert_internal (toolbar,
	                                           NULL, /* type, */
	                                           NULL, /* widget, */
	                                           text,
	                                           tooltip_text,
	                                           tooltip_private_text,
	                                           icon,
	                                           callback,
	                                           user_data,
	                                           position,
	                                           ITEM,
	                                           INSERT);
    OUTPUT:
	RETVAL


##GtkWidget* gtk_toolbar_insert_stock (GtkToolbar *toolbar, const gchar *stock_id, const char *tooltip_text, const char *tooltip_private_text, GtkSignalFunc callback, gpointer user_data, gint position)
GtkWidget *
gtk_toolbar_insert_stock (toolbar, stock_id, tooltip_text, tooltip_private_text, callback, user_data, position)
	GtkToolbar    * toolbar
	SV            * stock_id
	SV            * tooltip_text
	SV            * tooltip_private_text
	SV            * callback
	SV            * user_data
	SV            * position
    CODE:
	RETVAL = gtk2perl_toolbar_insert_internal (toolbar,
	                                           NULL, /* type, */
	                                           NULL, /* widget, */
	                                           stock_id,
	                                           tooltip_text,
	                                           tooltip_private_text,
	                                           NULL, /* icon, */
	                                           callback,
	                                           user_data,
	                                           position,
	                                           STOCK,
	                                           INSERT);
    OUTPUT:
	RETVAL


## GtkWidget* gtk_toolbar_prepend_element (GtkToolbar *toolbar, GtkToolbarChildType type, GtkWidget *widget, const char *text, const char *tooltip_text, const char *tooltip_private_text, GtkWidget *icon, GtkSignalFunc callback, gpointer user_data)
GtkWidget *
gtk_toolbar_prepend_element (toolbar, type, widget, text, tooltip_text, tooltip_private_text, icon, callback=NULL, user_data=NULL)
	GtkToolbar * toolbar
	SV         * type
	SV         * widget
	SV         * text
	SV         * tooltip_text
	SV         * tooltip_private_text
	SV         * icon
	SV         * callback
	SV         * user_data
    CODE:
	RETVAL = gtk2perl_toolbar_insert_internal (toolbar,
	                                           type,
	                                           widget,
	                                           text,
	                                           tooltip_text,
	                                           tooltip_private_text,
	                                           icon,
	                                           callback,
	                                           user_data,
	                                           NULL, /* position, */
	                                           ELEMENT,
	                                           PREPEND);
    OUTPUT:
	RETVAL

## GtkWidget* gtk_toolbar_insert_element (GtkToolbar *toolbar, GtkToolbarChildType type, GtkWidget *widget, const char *text, const char *tooltip_text, const char *tooltip_private_text, GtkWidget *icon, GtkSignalFunc callback, gpointer user_data, gint position)
GtkWidget *
gtk_toolbar_insert_element (toolbar, type, widget, text, tooltip_text, tooltip_private_text, icon, callback, user_data, position)
	GtkToolbar * toolbar
	SV         * type
	SV         * widget
	SV         * text
	SV         * tooltip_text
	SV         * tooltip_private_text
	SV         * icon
	SV         * callback
	SV         * user_data
        SV         * position
    CODE:
	RETVAL = gtk2perl_toolbar_insert_internal (toolbar,
	                                           type,
	                                           widget,
	                                           text,
	                                           tooltip_text,
	                                           tooltip_private_text,
	                                           icon,
	                                           callback,
	                                           user_data,
	                                           position,
	                                           ELEMENT,
	                                           INSERT);
    OUTPUT:
	RETVAL

##GtkWidget* gtk_toolbar_append_element (GtkToolbar *toolbar, GtkToolbarChildType type, GtkWidget *widget, const char *text, const char *tooltip_text, const char *tooltip_private_text, GtkWidget *icon, GtkSignalFunc callback, gpointer user_data)
GtkWidget *
gtk_toolbar_append_element (toolbar, type, widget, text, tooltip_text, tooltip_private_text, icon, callback=NULL, user_data=NULL)
	GtkToolbar * toolbar
	SV         * type
	SV         * widget
	SV         * text
	SV         * tooltip_text
	SV         * tooltip_private_text
	SV         * icon
	SV         * callback
	SV         * user_data
    CODE:
	RETVAL = gtk2perl_toolbar_insert_internal (toolbar,
	                                           type,
	                                           widget,
	                                           text,
	                                           tooltip_text,
	                                           tooltip_private_text,
	                                           icon,
	                                           callback,
	                                           user_data,
	                                           NULL, /* position, */
	                                           ELEMENT,
	                                           APPEND);
    OUTPUT:
	RETVAL

## void gtk_toolbar_prepend_widget (GtkToolbar *toolbar, GtkWidget *widget, const char *tooltip_text, const char *tooltip_private_text)
void
gtk_toolbar_prepend_widget (toolbar, widget, tooltip_text, tooltip_private_text)
	GtkToolbar * toolbar
	SV         * widget
	SV         * tooltip_text
	SV         * tooltip_private_text
    CODE:
	gtk2perl_toolbar_insert_internal (toolbar,
	                                  NULL, /* type, */
	                                  widget,
	                                  NULL, /* text, */
	                                  tooltip_text,
	                                  tooltip_private_text,
	                                  NULL, /* icon, */
	                                  NULL, /* callback, */
	                                  NULL, /* user_data, */
	                                  NULL, /* position, */
	                                  WIDGET,
	                                  PREPEND);

## void gtk_toolbar_insert_widget (GtkToolbar *toolbar, GtkWidget *widget, const char *tooltip_text, const char *tooltip_private_text, gint position)
void
gtk_toolbar_insert_widget (toolbar, widget, tooltip_text, tooltip_private_text, position)
	GtkToolbar * toolbar
	SV         * widget
	SV         * tooltip_text
	SV         * tooltip_private_text
	SV         * position
    CODE:
	gtk2perl_toolbar_insert_internal (toolbar,
	                                  NULL, /* type, */
	                                  widget,
	                                  NULL, /* text, */
	                                  tooltip_text,
	                                  tooltip_private_text,
	                                  NULL, /* icon, */
	                                  NULL, /* callback, */
	                                  NULL, /* user_data, */
	                                  position,
	                                  WIDGET,
	                                  INSERT);

##void gtk_toolbar_append_widget (GtkToolbar *toolbar, GtkWidget *widget, const char *tooltip_text, const char *tooltip_private_text)
void
gtk_toolbar_append_widget (toolbar, widget, tooltip_text, tooltip_private_text)
	GtkToolbar * toolbar
	SV         * widget
	SV         * tooltip_text
	SV         * tooltip_private_text
    CODE:
	gtk2perl_toolbar_insert_internal (toolbar,
	                                  NULL, /* type, */
	                                  widget,
	                                  NULL, /* text, */
	                                  tooltip_text,
	                                  tooltip_private_text,
	                                  NULL, /* icon, */
	                                  NULL, /* callback, */
	                                  NULL, /* user_data, */
	                                  NULL, /* position, */
	                                  WIDGET,
	                                  APPEND);

## void gtk_toolbar_prepend_space (GtkToolbar *toolbar)
void
gtk_toolbar_prepend_space (toolbar)
	GtkToolbar * toolbar

## void gtk_toolbar_insert_space (GtkToolbar *toolbar, gint position)
void
gtk_toolbar_insert_space (toolbar, position)
	GtkToolbar * toolbar
	gint         position

##void gtk_toolbar_append_space (GtkToolbar *toolbar)
void
gtk_toolbar_append_space (toolbar)
	GtkToolbar * toolbar

## void gtk_toolbar_remove_space (GtkToolbar *toolbar, gint position)
void
gtk_toolbar_remove_space (toolbar, position)
	GtkToolbar * toolbar
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


##void gtk_toolbar_set_orientation (GtkToolbar *toolbar, GtkOrientation orientation)
void
gtk_toolbar_set_orientation (toolbar, orientation)
	GtkToolbar     * toolbar
	GtkOrientation   orientation

