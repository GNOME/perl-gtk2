/*
 * Copyright (c) 2003 by the gtk2-perl team (see the file AUTHORS)
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Library General Public
 * License as published by the Free Software Foundation; either
 * version 2 of the License, or (at your option) any later version.
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

