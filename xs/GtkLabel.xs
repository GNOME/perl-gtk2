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


MODULE = Gtk2::Label	PACKAGE = Gtk2::Label	PREFIX = gtk_label_


GtkWidget *
gtk_label_new (class, str=NULL)
	SV * class
	const gchar * str
    C_ARGS:
	str
    CLEANUP:
	UNUSED(class);

GtkWidget *
gtk_label_new_with_mnemonic (class, str)
	SV * class
	const gchar * str
    C_ARGS:
	str
    CLEANUP:
	UNUSED(class);

### gtk_label_[gs]et_text ---- string does *not* include any embedded stuff
void
gtk_label_set_text (label, str)
	GtkLabel      * label
	const gchar    * str

const gchar *
gtk_label_get_text (label)
	GtkLabel      * label

void gtk_label_set_attributes (GtkLabel * label, PangoAttrList * attrs)

# can return NULL, but we don't have a boxed _ornull OUTPUT variant. :-/
PangoAttrList * gtk_label_get_attributes    (GtkLabel      * label);

### gtk_label_[gs]et_label ---- string includes any embedded stuff
void
gtk_label_set_label (label, str)
	GtkLabel * label
	const gchar * str

const gchar *
gtk_label_get_label (label)
	GtkLabel * label

void
gtk_label_set_markup (label, str)
	GtkLabel      * label
	const gchar   * str

void
gtk_label_set_use_markup (label, setting)
	GtkLabel      * label
	gboolean        setting

gboolean
gtk_label_get_use_markup (label)
	GtkLabel      * label

void
gtk_label_set_use_underline (label, setting)
	GtkLabel      * label
	gboolean        setting

gboolean
gtk_label_get_use_underline (label)
	GtkLabel      * label


void
gtk_label_set_markup_with_mnemonic (label, str)
	GtkLabel * label
	const gchar * str

guint
gtk_label_get_mnemonic_keyval (label)
	GtkLabel * label

void
gtk_label_set_mnemonic_widget (label, widget)
	GtkLabel * label
	GtkWidget * widget

GtkWidget *
gtk_label_get_mnemonic_widget (label)
	GtkLabel * label

void
gtk_label_set_text_with_mnemonic (label, str)
	GtkLabel * label
	const gchar * str

void
gtk_label_set_justify (label, jtype)
	GtkLabel         * label
	GtkJustification   jtype

GtkJustification
gtk_label_get_justify (label)
	GtkLabel         * label

void
gtk_label_set_pattern (label, pattern)
	GtkLabel         * label
	const gchar      * pattern

void
gtk_label_set_line_wrap (label, wrap)
	GtkLabel         * label
	gboolean           wrap

gboolean
gtk_label_get_line_wrap (label)
	GtkLabel         * label

void
gtk_label_set_selectable (label, setting)
	GtkLabel * label
	gboolean setting

gboolean
gtk_label_get_selectable (label)
	GtkLabel * label

void
gtk_label_select_region (label, start_offset=-1, end_offset=-1)
	GtkLabel         * label
	gint               start_offset
	gint               end_offset


 #gboolean gtk_label_get_selection_bounds           (GtkLabel         * label,
 #                                                   gint             * start,
 #                                                   gint             * end)
## done by hand because we don't want to return the boolean...  either there's
## a list or not.
void
gtk_label_get_selection_bounds (label)
	GtkLabel * label
	PREINIT:
	gint start, end;
	PPCODE:
	if (!gtk_label_get_selection_bounds (label, &start, &end))
		XSRETURN_UNDEF;
	EXTEND (SP, 2);
	PUSHs (sv_2mortal (newSViv (start)));
	PUSHs (sv_2mortal (newSViv (end)));


PangoLayout *
gtk_label_get_layout (label)
	GtkLabel * label


void gtk_label_get_layout_offsets (GtkLabel * label, OUTLIST gint x, OUTLIST gint y)
