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

## void gtk_tooltips_set_tip (GtkTooltips *tooltips, GtkWidget *widget, const gchar *tip_text, const gchar *tip_private)
void
gtk_tooltips_set_tip (tooltips, widget, tip_text, tip_private)
	GtkTooltips * tooltips
	GtkWidget   * widget
	const gchar * tip_text
	const gchar * tip_private

## GtkTooltipsData* gtk_tooltips_data_get (GtkWidget *widget)
void
gtk_tooltips_data_get (class, widget)
	SV        * class
	GtkWidget * widget
    PREINIT:
	GtkTooltipsData * ret = NULL;
	HV              * hv;
    PPCODE:
	ret = gtk_tooltips_data_get(widget);
	if( !ret )
		XSRETURN_UNDEF;
	hv = newHV();
	hv_store(hv, "tooltips", 8, newSVGtkTooltips(ret->tooltips),0);
	hv_store(hv, "widget", 6, newSVGtkWidget(GTK_WIDGET(ret->widget)),0);
	hv_store(hv, "tip_text", 8, newSVpv(ret->tip_text, PL_na),0);
	hv_store(hv, "tip_private", 11, newSVpv(ret->tip_private, PL_na),0);
	XPUSHs(sv_2mortal(newRV_noinc((SV*)hv)));

## void gtk_tooltips_force_window (GtkTooltips *tooltips)
void
gtk_tooltips_force_window (tooltips)
	GtkTooltips * tooltips

## void _gtk_tooltips_toggle_keyboard_mode (GtkWidget *widget)
#void
#_gtk_tooltips_toggle_keyboard_mode (widget)
#	GtkWidget * widget

