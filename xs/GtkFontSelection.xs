/*
 * $Header$
 */

#include "gtk2perl.h"

MODULE = Gtk2::FontSelection	PACKAGE = Gtk2::FontSelection	PREFIX = gtk_font_selection_

## GtkWidget* gtk_font_selection_new (void)
GtkWidget *
gtk_font_selection_new (class)
	SV * class
    C_ARGS:

## gchar* gtk_font_selection_get_font_name (GtkFontSelection *fontsel)
gchar *
gtk_font_selection_get_font_name (fontsel)
	GtkFontSelection * fontsel

## GdkFont* gtk_font_selection_get_font (GtkFontSelection *fontsel)
GdkFont *
gtk_font_selection_get_font (fontsel)
	GtkFontSelection * fontsel

## gboolean gtk_font_selection_set_font_name (GtkFontSelection *fontsel, const gchar *fontname)
gboolean
gtk_font_selection_set_font_name (fontsel, fontname)
	GtkFontSelection * fontsel
	const gchar      * fontname

## void gtk_font_selection_set_preview_text (GtkFontSelection *fontsel, const gchar *text)
void
gtk_font_selection_set_preview_text (fontsel, text)
	GtkFontSelection * fontsel
	const gchar      * text

## G_CONST_RETURN gchar* gtk_font_selection_get_preview_text (GtkFontSelection *fontsel)
const gchar *
gtk_font_selection_get_preview_text (fontsel)
	GtkFontSelection * fontsel

MODULE = Gtk2::FontSelection	PACKAGE = Gtk2::FontSelectionDialog	PREFIX = gtk_font_selection_dialog_

## GtkWidget* gtk_font_selection_dialog_new (const gchar *title)
GtkWidget *
gtk_font_selection_dialog_new (class, title)
	SV          * class
	const gchar * title
    C_ARGS:
	title

GtkWidget *
members_get (fsd)
	GtkFontSelectionDialog * fsd
    ALIAS:
	Gtk2::FontSelectionDialog::ok_button = 1
	Gtk2::FontSelectionDialog::apply_button = 2
	Gtk2::FontSelectionDialog::cancel_button = 3
    CODE:
	switch(ix)
	{
		case 1:	RETVAL = fsd->ok_button; break;
		case 2:	RETVAL = fsd->apply_button; break;
		case 3:	RETVAL = fsd->cancel_button; break;
		default: croak("unhandled case in members_get - shouldn't happen");
	}
    OUTPUT:
	RETVAL

# TODO: ?
##GtkType gtk_font_selection_dialog_get_type (void) G_GNUC_CONST
#GtkType
#gtk_font_selection_dialog_get_type ()

##gchar* gtk_font_selection_dialog_get_font_name (GtkFontSelectionDialog *fsd)
gchar *
gtk_font_selection_dialog_get_font_name (fsd)
	GtkFontSelectionDialog * fsd

##GdkFont* gtk_font_selection_dialog_get_font (GtkFontSelectionDialog *fsd)
GdkFont *
gtk_font_selection_dialog_get_font (fsd)
	GtkFontSelectionDialog * fsd

##gboolean gtk_font_selection_dialog_set_font_name (GtkFontSelectionDialog *fsd, const gchar *fontname)
gboolean
gtk_font_selection_dialog_set_font_name (fsd, fontname)
	GtkFontSelectionDialog * fsd
	gchar                  * fontname

##void gtk_font_selection_dialog_set_preview_text (GtkFontSelectionDialog *fsd, const gchar *text)
void
gtk_font_selection_dialog_set_preview_text (fsd, text)
	GtkFontSelectionDialog * fsd
	gchar                  * text

##G_CONST_RETURN gchar* gtk_font_selection_dialog_get_preview_text (GtkFontSelectionDialog *fsd)
const gchar *
gtk_font_selection_dialog_get_preview_text (fsd)
	GtkFontSelectionDialog * fsd

