/*
 * $Header$
 */

#include "gtk2perl.h"

MODULE = Gtk2::Tooltips	PACKAGE = Gtk2::Tooltips	PREFIX = gtk_tooltips_

## GtkTooltips* gtk_tooltips_new (void)
GtkTooltips *
gtk_tooltips_new (class)
	SV * class
    C_ARGS:

## void gtk_tooltips_enable (GtkTooltips *tooltips)
void
gtk_tooltips_enable (tooltips)
	GtkTooltips * tooltips

## void gtk_tooltips_disable (GtkTooltips *tooltips)
void
gtk_tooltips_disable (tooltips)
	GtkTooltips * tooltips

## void gtk_tooltips_set_delay (GtkTooltips *tooltips, guint delay)
void
gtk_tooltips_set_delay (tooltips, delay)
	GtkTooltips * tooltips
	guint         delay

## void gtk_tooltips_set_tip (GtkTooltips *tooltips, GtkWidget *widget, const gchar *tip_text, const gchar *tip_private)
void
gtk_tooltips_set_tip (tooltips, widget, tip_text, tip_private)
	GtkTooltips * tooltips
	GtkWidget   * widget
	const gchar * tip_text
	const gchar * tip_private

# TODO: GtkTooltipsData * not in typemap
## GtkTooltipsData* gtk_tooltips_data_get (GtkWidget *widget)
#GtkTooltipsData *
#gtk_tooltips_data_get (widget)
#	GtkWidget * widget

## void gtk_tooltips_force_window (GtkTooltips *tooltips)
void
gtk_tooltips_force_window (tooltips)
	GtkTooltips * tooltips

## void _gtk_tooltips_toggle_keyboard_mode (GtkWidget *widget)
#void
#_gtk_tooltips_toggle_keyboard_mode (widget)
#	GtkWidget * widget

