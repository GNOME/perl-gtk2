/*
 * Copyright (c) 2004 by the gtk2-perl team (see the file AUTHORS)
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

MODULE = Gtk2::Pango::FontMap	PACKAGE = Gtk2::Pango::FontMap	PREFIX = pango_font_map_

##  PangoFont * pango_font_map_load_font (PangoFontMap *fontmap, PangoContext *context, const PangoFontDescription *desc)
PangoFont_ornull *
pango_font_map_load_font (fontmap, context, desc)
	PangoFontMap *fontmap
	PangoContext *context
	const PangoFontDescription *desc

##  PangoFontset * pango_font_map_load_fontset (PangoFontMap *fontmap, PangoContext *context, const PangoFontDescription *desc, PangoLanguage *language)
PangoFontset_ornull *
pango_font_map_load_fontset (fontmap, context, desc, language)
	PangoFontMap *fontmap
	PangoContext *context
	const PangoFontDescription *desc
	PangoLanguage *language

##  void pango_font_map_list_families (PangoFontMap *fontmap, PangoFontFamily ***families, int *n_families)
void
pango_font_map_list_families (fontmap)
	PangoFontMap *fontmap
    PREINIT:
	PangoFontFamily **families = NULL;
	int n_families = 0, i;
    PPCODE:
	pango_font_map_list_families (fontmap, &families, &n_families);
	if (families) {
		EXTEND (sp, n_families);
		for (i = 0; i < n_families; i++)
			PUSHs (sv_2mortal (newSVPangoFontFamily (families[i])));
		g_free (families);
	}
