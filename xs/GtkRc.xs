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

/* TODO: this is very alpha and very un-understood. */

MODULE = Gtk2::Rc	PACKAGE = Gtk2::Rc	PREFIX = gtk_rc_

## void _gtk_rc_init (void)

## void gtk_rc_add_default_file (const gchar *filename)
void
gtk_rc_add_default_file (class, filename)
	GPerlFilename filename
    C_ARGS:
	filename

## void gtk_rc_set_default_files (gchar **filenames)
=for apidoc
=signature Gtk2::Rc->set_default_files (file1, ...)
=arg file1 (string) The first rc file to be read
=arg ... (__hide__)
Sets the list of files that GTK+ will read at the end of Gtk2->init.
=cut
void
gtk_rc_set_default_files (class, ...)
    PREINIT:
	gchar **filenames = NULL;
    CODE:
	filenames = g_new0(gchar*, items);
	for( items--; items > 0; items-- )
		filenames[items] = gperl_filename_from_sv (ST(items));
	gtk_rc_set_default_files(filenames);
	g_free(filenames);
	

## GtkStyle* gtk_rc_get_style (GtkWidget *widget)
GtkStyle*
gtk_rc_get_style (widget)
	GtkWidget *widget

# TODO: GType not in type map
## GtkStyle* gtk_rc_get_style_by_paths (GtkSettings *settings, const char *widget_path, const char *class_path, GType type)
#GtkStyle*
#gtk_rc_get_style_by_paths (settings, widget_path, class_path, type)
#	GtkSettings *settings
#	const char *widget_path
#	const char *class_path
#	GType type

## gboolean gtk_rc_reparse_all_for_settings (GtkSettings *settings, gboolean force_load)
gboolean
gtk_rc_reparse_all_for_settings (settings, force_load)
	GtkSettings *settings
	gboolean force_load

# TODO: GScanner * not in typemap
## gchar* gtk_rc_find_pixmap_in_path (GtkSettings *settings, GScanner *scanner, const gchar *pixmap_file)
#gchar*
#gtk_rc_find_pixmap_in_path (settings, scanner, pixmap_file)
#	GtkSettings *settings
#	GScanner *scanner
#	const gchar *pixmap_file

## void gtk_rc_parse (const gchar *filename)
void
gtk_rc_parse (class, filename)
	GPerlFilename filename
    C_ARGS:
	filename

## void gtk_rc_parse_string (const gchar *rc_string)
void
gtk_rc_parse_string (class, rc_string)
	const gchar * rc_string
    C_ARGS:
	rc_string

## gboolean gtk_rc_reparse_all (void)
gboolean
gtk_rc_reparse_all (class)
    C_ARGS:
	/* void */

## void gtk_rc_add_widget_name_style (GtkRcStyle *rc_style, const gchar *pattern)
void
gtk_rc_add_widget_name_style (rc_style, pattern)
	GtkRcStyle *rc_style
	const gchar *pattern

## void gtk_rc_add_widget_class_style (GtkRcStyle *rc_style, const gchar *pattern)
void
gtk_rc_add_widget_class_style (rc_style, pattern)
	GtkRcStyle *rc_style
	const gchar *pattern

## void gtk_rc_add_class_style (GtkRcStyle *rc_style, const gchar *pattern)
void
gtk_rc_add_class_style (rc_style, pattern)
	GtkRcStyle *rc_style
	const gchar *pattern

## gchar* gtk_rc_find_module_in_path (const gchar *module_file)
gchar_own *
gtk_rc_find_module_in_path (class, module_file)
	const gchar * module_file
    C_ARGS:
	module_file

## gchar* gtk_rc_get_theme_dir (void)
gchar_own *
gtk_rc_get_theme_dir (class)
    C_ARGS:
	/* void */

## gchar* gtk_rc_get_module_dir (void)
gchar_own *
gtk_rc_get_module_dir (class)
    C_ARGS:
	/* void */

## gchar* gtk_rc_get_im_module_path (void)
gchar_own *
gtk_rc_get_im_module_path (class)
    C_ARGS:
	/* void */

## gchar* gtk_rc_get_im_module_file (void)
gchar_own *
gtk_rc_get_im_module_file (class)
    C_ARGS:
	/* void */

# TODO: GScanner * not in type map
## GScanner* gtk_rc_scanner_new (void)
#GScanner*
#gtk_rc_scanner_new (void)
#	void

# TODO: GScanner * not in type map
## guint gtk_rc_parse_color (GScanner *scanner, GdkColor *color)
#guint
#gtk_rc_parse_color (scanner, color)
#	GScanner *scanner
#	GdkColor *color

# TODO: GScanner * not in type map
## guint gtk_rc_parse_state (GScanner *scanner, GtkStateType *state)
#guint
#gtk_rc_parse_state (scanner, state)
#	GScanner *scanner
#	GtkStateType *state

# TODO: GScanner * not in type map
## guint gtk_rc_parse_priority (GScanner *scanner, GtkPathPriorityType *priority)
#guint
#gtk_rc_parse_priority (scanner, priority)
#	GScanner *scanner
#	GtkPathPriorityType *priority

MODULE = Gtk2::Rc	PACKAGE = Gtk2::RcStyle	PREFIX = gtk_rc_style_

## void _gtk_rc_reset_styles (GtkSettings *settings)

SV *
members (GtkRcStyle * style)
    ALIAS:
	name           = 0
	xthickness     = 1
	ythickness     = 2
    CODE:
	switch (ix) {
		case 0: RETVAL = newSVGChar (style->name); break;
		case 1: RETVAL = newSViv (style->xthickness); break;
		case 2: RETVAL = newSViv (style->ythickness); break;
		default: RETVAL = NULL;
	}
    OUTPUT:
	RETVAL

const gchar *
bg_pixmap_name (GtkRcStyle * style, GtkStateType state)
    CODE:
	RETVAL = style->bg_pixmap_name[state];
    OUTPUT:
	RETVAL

GtkRcFlags
color_flags (GtkRcStyle * style, GtkStateType state, SV * newval=NULL)
    CODE:
	RETVAL = style->color_flags[state];
	if (newval)
		style->color_flags[state] = SvGtkRcFlags (newval);
    OUTPUT:
	RETVAL

GdkColor_copy *
colors (GtkRcStyle * style, GtkStateType state, GdkColor_ornull * newcolor=NULL)
    ALIAS:
	fg          = 0
	bg          = 1
	text        = 2
	base        = 3
    CODE:
	switch (ix) {
	    case 0: RETVAL = &(style->fg[state]); break;
	    case 1: RETVAL = &(style->bg[state]); break;
	    case 2: RETVAL = &(style->text[state]); break;
	    case 3: RETVAL = &(style->base[state]); break;
	}
	if (newcolor) {
		switch (ix) {
		    case 0: style->fg[state]   = *newcolor; break;
		    case 1: style->bg[state]   = *newcolor; break;
		    case 2: style->text[state] = *newcolor; break;
		    case 3: style->base[state] = *newcolor; break;
		}
	}
    OUTPUT:
	RETVAL

## GtkRcStyle* gtk_rc_style_new (void)
GtkRcStyle_noinc *
gtk_rc_style_new (class)
    C_ARGS:
	/*void*/

# GtkRcStyle* gtk_rc_style_copy (GtkRcStyle *orig)
GtkRcStyle_noinc *
gtk_rc_style_copy (orig)
	GtkRcStyle * orig

PangoFontDescription *
get_font_desc (rcstyle)
	GtkRcStyle * rcstyle
    CODE:
	RETVAL = rcstyle->font_desc;

void
set_font_desc(rcstyle, fd)
	GtkRcStyle * rcstyle
	PangoFontDescription * fd
    CODE:
	rcstyle->font_desc = fd;

# should happen automagically
## void gtk_rc_style_ref (GtkRcStyle *rc_style)
## void gtk_rc_style_unref (GtkRcStyle *rc_style)

