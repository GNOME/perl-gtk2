#include "gtk2perl.h"

MODULE = Gtk2::Pango::Font	PACKAGE = Gtk2::Pango

### some constants...
double
constant (class)
	SV * class
    ALIAS:
	Gtk2::Pango::scale          = 1
	Gtk2::Pango::scale_xx_small = 2
	Gtk2::Pango::scale_x_small  = 3
	Gtk2::Pango::scale_small    = 4
	Gtk2::Pango::scale_medium   = 5
	Gtk2::Pango::scale_large    = 6
	Gtk2::Pango::scale_x_large  = 7
	Gtk2::Pango::scale_xx_large = 8
    CODE:
	switch (ix) {
		case 1: RETVAL = (double)PANGO_SCALE; break;
		case 2: RETVAL = PANGO_SCALE_XX_SMALL; break;
		case 3: RETVAL = PANGO_SCALE_X_SMALL; break;
		case 4: RETVAL = PANGO_SCALE_SMALL; break;
		case 5: RETVAL = PANGO_SCALE_MEDIUM; break;
		case 6: RETVAL = PANGO_SCALE_LARGE; break;
		case 7: RETVAL = PANGO_SCALE_X_LARGE; break;
		case 8: RETVAL = PANGO_SCALE_XX_LARGE; break;
	}
    OUTPUT:
	RETVAL

MODULE = Gtk2::Pango::Font	PACKAGE = Gtk2::Pango::FontDescription	PREFIX = pango_font_description_

##PangoFontDescription* pango_font_description_new (void)
PangoFontDescription *
pango_font_description_new (class)
	SV * class
    C_ARGS:

## guint pango_font_description_hash (const PangoFontDescription *desc)
guint
pango_font_description_hash (desc)
	PangoFontDescription *desc

## gboolean pango_font_description_equal (const PangoFontDescription *desc1, const PangoFontDescription *desc2)
gboolean
pango_font_description_equal (desc1, desc2)
	PangoFontDescription *desc1
	PangoFontDescription *desc2

# should be taken care of automagically
## void pango_font_description_free (PangoFontDescription *desc)
## void pango_font_descriptions_free (PangoFontDescription **descs, int n_descs)

## void pango_font_description_set_family (PangoFontDescription *desc, const char *family)
void
pango_font_description_set_family (desc, family)
	PangoFontDescription *desc
	const char *family

## void pango_font_description_set_family_static (PangoFontDescription *desc, const char *family)
void
pango_font_description_set_family_static (desc, family)
	PangoFontDescription *desc
	const char *family

## void pango_font_description_set_style (PangoFontDescription *desc, PangoStyle style)
void
pango_font_description_set_style (desc, style)
	PangoFontDescription *desc
	PangoStyle style

## PangoStyle pango_font_description_get_style (const PangoFontDescription *desc)
PangoStyle
pango_font_description_get_style (desc)
	PangoFontDescription *desc

## void pango_font_description_set_variant (PangoFontDescription *desc, PangoVariant variant)
void
pango_font_description_set_variant (desc, variant)
	PangoFontDescription *desc
	PangoVariant variant

## PangoVariant pango_font_description_get_variant (const PangoFontDescription *desc)
PangoVariant
pango_font_description_get_variant (desc)
	PangoFontDescription *desc

## void pango_font_description_set_weight (PangoFontDescription *desc, PangoWeight weight)
void
pango_font_description_set_weight (desc, weight)
	PangoFontDescription *desc
	PangoWeight weight

## PangoWeight pango_font_description_get_weight (const PangoFontDescription *desc)
PangoWeight
pango_font_description_get_weight (desc)
	PangoFontDescription *desc

## void pango_font_description_set_stretch (PangoFontDescription *desc, PangoStretch stretch)
void
pango_font_description_set_stretch (desc, stretch)
	PangoFontDescription *desc
	PangoStretch stretch

## PangoStretch pango_font_description_get_stretch (const PangoFontDescription *desc)
PangoStretch
pango_font_description_get_stretch (desc)
	PangoFontDescription *desc

## void pango_font_description_set_size (PangoFontDescription *desc, gint size)
void
pango_font_description_set_size (desc, size)
	PangoFontDescription *desc
	gint size

## gint pango_font_description_get_size (const PangoFontDescription *desc)
gint
pango_font_description_get_size (desc)
	PangoFontDescription *desc

## PangoFontMask pango_font_description_get_set_fields (const PangoFontDescription *desc)
PangoFontMask
pango_font_description_get_set_fields (desc)
	PangoFontDescription *desc

## void pango_font_description_unset_fields (PangoFontDescription *desc, PangoFontMask to_unset)
void
pango_font_description_unset_fields (desc, to_unset)
	PangoFontDescription *desc
	PangoFontMask to_unset

## void pango_font_description_merge (PangoFontDescription *desc, const PangoFontDescription *desc_to_merge, gboolean replace_existing)
void
pango_font_description_merge (desc, desc_to_merge, replace_existing)
	PangoFontDescription *desc
	PangoFontDescription *desc_to_merge
	gboolean replace_existing

## void pango_font_description_merge_static (PangoFontDescription *desc, const PangoFontDescription *desc_to_merge, gboolean replace_existing)
void
pango_font_description_merge_static (desc, desc_to_merge, replace_existing)
	PangoFontDescription *desc
	PangoFontDescription *desc_to_merge
	gboolean replace_existing

## gboolean pango_font_description_better_match (const PangoFontDescription *desc, const PangoFontDescription *old_match, const PangoFontDescription *new_match)
gboolean
pango_font_description_better_match (desc, old_match, new_match)
	PangoFontDescription *desc
	PangoFontDescription *old_match
	PangoFontDescription *new_match


##PangoFontDescription *pango_font_description_from_string (const char *str)
PangoFontDescription *
pango_font_description_from_string (class, str)
	SV         * class
	const char * str
    C_ARGS:
	str

## char * pango_font_description_to_string (const PangoFontDescription *desc)
char *
pango_font_description_to_string (desc)
	PangoFontDescription *desc

## char * pango_font_description_to_filename (const PangoFontDescription *desc)
char *
pango_font_description_to_filename (desc)
	PangoFontDescription *desc

MODULE = Gtk2::Pango::Font	PACKAGE = Gtk2::Pango::FontMetrics	PREFIX = pango_font_metrics_

# should happen automagicly
## void pango_font_metrics_unref (PangoFontMetrics *metrics)

## int pango_font_metrics_get_ascent (PangoFontMetrics *metrics)
int
pango_font_metrics_get_ascent (metrics)
	PangoFontMetrics *metrics

## int pango_font_metrics_get_descent (PangoFontMetrics *metrics)
int
pango_font_metrics_get_descent (metrics)
	PangoFontMetrics *metrics

## int pango_font_metrics_get_approximate_char_width (PangoFontMetrics *metrics)
int
pango_font_metrics_get_approximate_char_width (metrics)
	PangoFontMetrics *metrics

## int pango_font_metrics_get_approximate_digit_width (PangoFontMetrics *metrics)
int
pango_font_metrics_get_approximate_digit_width (metrics)
	PangoFontMetrics *metrics

## PangoFontMetrics * pango_font_get_metrics (PangoFont *font, PangoLanguage *language)
PangoFontMetrics *
pango_font_get_metrics (font, language)
	PangoFont *font
	PangoLanguage *language

MODULE = Gtk2::Pango::Font	PACKAGE = Gtk2::Pango::FontFamily	PREFIX = pango_font_family_

## void pango_font_family_list_faces (PangoFontFamily *family, PangoFontFace ***faces, int *n_faces)
void
pango_font_family_list_faces (family)
	PangoFontFamily *family
    PREINIT:
	PangoFontFace ** faces;
	int 	         n_faces;
    PPCODE:
	pango_font_family_list_faces(family, &faces, &n_faces);
	if( n_faces < 1 || faces == NULL )
		XSRETURN_EMPTY;
	else
	{
		EXTEND(SP,n_faces);
		for( ; n_faces >= 0; n_faces-- )
			PUSHs(sv_2mortal(newSVPangoFontFace(faces[n_faces])));
	}
	g_free(faces);

#MODULE = Gtk2::Pango::Font	PACKAGE = Gtk2::Pango::Font	PREFIX = pango_font_
#
### PangoCoverage * pango_font_get_coverage (PangoFont *font, PangoLanguage *language)
#PangoCoverage *
#pango_font_get_coverage (font, language)
#	PangoFont *font
#	PangoLanguage *language
#
### PangoEngineShape * pango_font_find_shaper (PangoFont *font, PangoLanguage *language, guint32 ch)
#PangoEngineShape *
#pango_font_find_shaper (font, language, ch)
#	PangoFont *font
#	PangoLanguage *language
#	guint32 ch
#
### void pango_font_get_glyph_extents (PangoFont *font, PangoGlyph glyph, PangoRectangle *ink_rect, PangoRectangle *logical_rect)
#void
#pango_font_get_glyph_extents (font, glyph, ink_rect, logical_rect)
#	PangoFont *font
#	PangoGlyph glyph
#	PangoRectangle *ink_rect
#	PangoRectangle *logical_rect
#
