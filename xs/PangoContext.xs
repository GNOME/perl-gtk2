#include "gtk2perl.h"

MODULE = Gtk2::Pango::Context	PACKAGE = Gtk2::Pango::Context	PREFIX = pango_context_

###  PangoContext *pango_context_new (void) 
#PangoContext_noinc *
#pango_context_new (class)
#	SV * class
#    C_ARGS:
#	

###  void pango_context_set_font_map (PangoContext *context, PangoFontMap *font_map) 
#void
#pango_context_set_font_map (context, font_map)
#	PangoContext *context
#	PangoFontMap *font_map

###  void pango_context_list_families (PangoContext *context, PangoFontFamily ***families, int *n_families) 
#void
#pango_context_list_families (context, families, n_families)
#	PangoContext *context
#	PangoFontFamily ***families
#	int *n_families

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

###  GList *pango_itemize (PangoContext *context, const char *text, int start_index, int length, PangoAttrList *attrs, PangoAttrIterator *cached_iter) 
#GList *
#pango_itemize (context, text, start_index, length, attrs, cached_iter)
#	PangoContext *context
#	const char *text
#	int start_index
#	int length
#	PangoAttrList *attrs
#	PangoAttrIterator *cached_iter
#
