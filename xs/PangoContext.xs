/*
 * Copyright (c) 2003-2004 by the gtk2-perl team (see the file AUTHORS)
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

MODULE = Gtk2::Pango::Context	PACKAGE = Gtk2::Pango::Context	PREFIX = pango_context_

 ## applications have no cause to use pango_context_new() -- it is intended
 ## to be used by backends.  i seriously doubt anyone would want to write a
 ## pango backend in Perl, unless they want something that's really slow.
 ## higher-level APIs are used to create contexts appropriate for the desired
 ## backend, e.g. $gtkwidget->create_pango_context.
##  PangoContext *pango_context_new (void) 

 ## same thing goes for pango_context_set_font_map.
##  void pango_context_set_font_map (PangoContext *context, PangoFontMap *font_map) 

#if PANGO_CHECK_VERSION (1, 5, 1) /* FIXME: 1.6 */

##  PangoFontMap *pango_context_get_font_map (PangoContext *context)
PangoFontMap *
pango_context_get_font_map (context)
	PangoContext *context

#endif

###  void pango_context_list_families (PangoContext *context, PangoFontFamily ***families, int *n_families) 
=for apidoc
=for signature @families = $context->list_families
=cut
void
pango_context_list_families (context)
	PangoContext *context
    PREINIT:
	PangoFontFamily **families = NULL;
	int n_families;
    PPCODE:
	pango_context_list_families (context, &families, &n_families);
	if (n_families > 0) {
		int i;
		EXTEND (SP, n_families);
		for (i = 0 ; i < n_families ; i++)
			PUSHs (sv_2mortal (newSVPangoFontFamily (families[i])));
		g_free (families);
	}

##  PangoFont * pango_context_load_font (PangoContext *context, const PangoFontDescription *desc) 
### may return NULL....
PangoFont_noinc *
pango_context_load_font (context, desc)
	PangoContext *context
	PangoFontDescription_ornull *desc
    CODE:
	RETVAL = pango_context_load_font (context, desc);
	if (!RETVAL)
		XSRETURN_UNDEF;
    OUTPUT:
	RETVAL

##  PangoFontset *pango_context_load_fontset (PangoContext *context, const PangoFontDescription *desc, PangoLanguage *language) 
PangoFontset_noinc *
pango_context_load_fontset (context, desc, language)
	PangoContext *context
	PangoFontDescription *desc
	PangoLanguage_ornull *language
    CODE:
	RETVAL = pango_context_load_fontset (context, desc, language);
	if (!RETVAL)
		XSRETURN_UNDEF;
    OUTPUT:
	RETVAL

##  PangoFontMetrics *pango_context_get_metrics (PangoContext *context, const PangoFontDescription *desc, PangoLanguage *language) 
PangoFontMetrics_own *
pango_context_get_metrics (context, desc, language)
	PangoContext *context
	PangoFontDescription *desc
	PangoLanguage_ornull *language

##  void pango_context_set_font_description (PangoContext *context, const PangoFontDescription *desc) 
void
pango_context_set_font_description (context, desc)
	PangoContext *context
	PangoFontDescription *desc

##  PangoFontDescription * pango_context_get_font_description (PangoContext *context) 
## caller must not alter the returned value!  should use use a copy instead?
PangoFontDescription *
pango_context_get_font_description (context)
	PangoContext *context

##  PangoLanguage *pango_context_get_language (PangoContext *context) 
PangoLanguage *
pango_context_get_language (context)
	PangoContext *context

##  void pango_context_set_language (PangoContext *context, PangoLanguage *language) 
void
pango_context_set_language (context, language)
	PangoContext *context
	PangoLanguage *language

##  void pango_context_set_base_dir (PangoContext *context, PangoDirection direction) 
void
pango_context_set_base_dir (context, direction)
	PangoContext *context
	PangoDirection direction

##  PangoDirection pango_context_get_base_dir (PangoContext *context) 
PangoDirection
pango_context_get_base_dir (context)
	PangoContext *context

# FIXME
###  GList *pango_itemize (PangoContext *context, const char *text, int start_index, int length, PangoAttrList *attrs, PangoAttrIterator *cached_iter) 
#GList *
#pango_itemize (context, text, start_index, length, attrs, cached_iter)
#	PangoContext *context
#	const char *text
#	int start_index
#	int length
#	PangoAttrList *attrs
#	PangoAttrIterator *cached_iter

#if PANGO_CHECK_VERSION (1, 5, 0) /* FIXME: 1.6 */

##  PangoMatrix * pango_context_get_matrix (PangoContext *context)
const PangoMatrix_ornull *
pango_context_get_matrix (context)
	PangoContext *context

##  void pango_context_set_matrix (PangoContext *context, PangoMatrix *matrix)
void
pango_context_set_matrix (context, matrix)
	PangoContext *context
	PangoMatrix_ornull *matrix

#endif
