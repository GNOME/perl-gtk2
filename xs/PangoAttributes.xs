/*
 * Copyright (c) 2005 by the gtk2-perl team (see the file AUTHORS)
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

#if 0
##typedef struct {
##	PangoAttribute * attr;
##	gboolean         own;
##} Gtk2PerlPangoAttrBox;
##
##static Gtk2PerlPangoAttrBox *
##gtk2perl_pango_attr_box_new (PangoAttribute * attr,
##			     gboolean         own)
##{
##	Gtk2PerlPangoAttrBox * box = g_new (Gtk2PerlPangoAttrBox, 1);
##	box->attr = attr;
##	box->own  = own;
##	return box;
##}
##
##static void
##gtk2perl_pango_attr_box_free (Gtk2PerlPangoAttrBox * box)
##{
##	if (box) {
##		if (box->own)
##			pango_attribute_destroy (box->attr);
##		g_free (box);
##	}
##}
##
##static SV *
##gtk2perl_sv_from_pango_attribute (PangoAttribute * attr,
##				  gboolean         own)
##{
##	Gtk2PerlPangoAttrBox * box =
##		gtk2perl_pango_attr_box_new (attr, own);
##	const char * pkg;
##	/* the interface is designed to allow extensibility by registering
##	 * new PangoAttrType values, but pango doesn't allow us to query
##	 * those.  so, we'll just hardcode these for now. */
##	switch (attr->klass->type) {
##	    case PANGO_ATTR_INVALID:
##		/* er, what to do here? */
##		break;
##	    case PANGO_ATTR_LANGUAGE:      pkg = "Gtk2::Pango::AttrLanguage"; break;
##	    case PANGO_ATTR_FAMILY:        pkg = "Gtk2::Pango::AttrFamily"; break;
##	    case PANGO_ATTR_STYLE:         pkg = "Gtk2::Pango::AttrStyle"; break;
##	    case PANGO_ATTR_WEIGHT:        pkg = "Gtk2::Pango::AttrWeight"; break;
##	    case PANGO_ATTR_VARIANT:       pkg = "Gtk2::Pango::AttrVariant"; break;
##	    case PANGO_ATTR_STRETCH:       pkg = "Gtk2::Pango::AttrStretch"; break;
##	    case PANGO_ATTR_SIZE:          pkg = "Gtk2::Pango::AttrSize"; break;
##	    case PANGO_ATTR_FONT_DESC:     pkg = "Gtk2::Pango::AttrFontDesc"; break;
##	    case PANGO_ATTR_FOREGROUND:    pkg = "Gtk2::Pango::AttrForeground"; break;
##	    case PANGO_ATTR_BACKGROUND:    pkg = "Gtk2::Pango::AttrForeground"; break;
##	    case PANGO_ATTR_UNDERLINE:     pkg = "Gtk2::Pango::AttrUnderline"; break;
##	    case PANGO_ATTR_STRIKETHROUGH: pkg = "Gtk2::Pango::AttrStrikethrough"; break;
##	    case PANGO_ATTR_RISE:          pkg = "Gtk2::Pango::AttrInt"; break;
##	    case PANGO_ATTR_SHAPE:         pkg = "Gtk2::Pango::AttrShape"; break;
##	    case PANGO_ATTR_SCALE:         pkg = "Gtk2::Pango::AttrFloat"; break;
##	    default:
##		warn ("unknown PangoAttribute class %d, using base class",
##		      attr->klass->type);
##		pkg = "Gtk2::Pango::Attribute";
##		break;
##	}
##
##	return sv_setref_pv (newSV(0), pkg, box);
##}
##
##static PangoAttribute *
##gtk2perl_pango_attribute_from_sv (SV * sv)
##{
##	Gtk2PerlPangoAttrBox * box;
##
##	if (!sv || !SvOK (sv))
##		return NULL;
##
##	if ((!SvRV (sv)) || (!sv_derived_from (sv, "Gtk2::Pango::Attribute")))
##		croak ("%s is not a Gtk2::Pango::Attribute",
##		       gperl_format_variable_for_output (sv));
##
##	box = INT2PTR (Gtk2PerlPangoAttrBox*, SvIV (SvRV (sv)));
##	return box->attr;	
##}
##
##
##typedef PangoAttribute PangoAttribute_own;
##
###define SvPangoAttribute(sv)  gtk2perl_pango_attribute_from_sv ((sv))
###define newSVPangoAttribute(attr)  gtk2perl_sv_from_pango_attribute ((attr), FALSE)
###define newSVPangoAttribute_own(attr)  gtk2perl_sv_from_pango_attribute ((attr), TRUE)
##
##
##MODULE = Gtk2::Pango::Attributes	PACKAGE = Gtk2::Pango::Color	PREFIX = pango_color_
##
####
####/* PangoColor */
####
#### these are automatic, thanks to Glib::Boxed
#####define PANGO_TYPE_COLOR pango_color_get_type ()
####GType       pango_color_get_type (void) G_GNUC_CONST;
####PangoColor *pango_color_copy     (const PangoColor *src);
####void        pango_color_free     (PangoColor       *color);
##
##PangoColor_copy *
##new (class, ...)
##    PREINIT:
##	PangoColor color = {0, 0, 0};
##    CODE:
##	if (items == 1) {
##		/* that's cool */
##	} else if (items == 4) {
##		/* initializers */
##		color.red   = (guint16) SvIV (ST (1));
##		color.green = (guint16) SvIV (ST (2));
##		color.blue  = (guint16) SvIV (ST (3));
##	} else {
##		/* that's not cool. */
##		croak ("Usage:  $color = Gtk2::Pango::Color->new\n"
##		       "        $color = Gtk2::Pango::Color->new ($red, $green, $blue)\n"
##		       "    ");
##	}
##	RETVAL = &color;
##    OUTPUT:
##	RETVAL
##
####gboolean pango_color_parse (PangoColor *color, const char *spec);
##PangoColor_copy *
##pango_color_parse (class, const gchar * spec)
##    PREINIT:
##	PangoColor color;
##    CODE:
##	if (! pango_color_parse (&color, spec))
##		XSRETURN_UNDEF;
##	RETVAL = &color;
##    OUTPUT:
##	RETVAL
##
#### FIXME pod for both signatures of all three methods...
##guint16
##red (PangoColor * color, ...)
##    ALIAS:
##	green = 1
##	blue = 2
##    CODE:
##	switch (ix) {
##	    case 0: RETVAL = color->red; break;
##	    case 1: RETVAL = color->green; break;
##	    case 2: RETVAL = color->blue; break;
##	    default:
##		g_assert_not_reached ();
##	}
##	if (items > 1) {
##		guint16 newval = SvIV (ST (1));
##		switch (ix) {
##		    case 0: color->red = newval; break;
##		    case 1: color->green = newval; break;
##		    case 2: color->blue = newval; break;
##		}
##	}
##    OUTPUT:
##	RETVAL
##
##
##MODULE = Gtk2::Pango::Attributes	PACKAGE = Gtk2::Pango::Attribute	PREFIX = pango_attribute_
##
####=for enum Gtk2::Pango::AttrType;
####=cut
####
####=for enum Gtk2::Pango::Underline;
####=cut
####
####/* Attributes */
####
#### FIXME
#### FIXME  the attributes are a bunch of small types without GTypes.
#### FIXME  bindings here will be "interesting".
#### FIXME
##
##void
##DESTROY (SV * sv)
##    PREINIT:
##	Gtk2PerlPangoAttrBox * box;
##    CODE:
##	box = INT2PTR (Gtk2PerlPangoAttrBox*, SvIV (SvRV (sv)));
##	gtk2perl_pango_attr_box_free (box);
##
####typedef struct _PangoAttribute    PangoAttribute;
####typedef struct _PangoAttrClass    PangoAttrClass;
####				  
####typedef struct _PangoAttrString   PangoAttrString;
####typedef struct _PangoAttrLanguage PangoAttrLanguage;
####typedef struct _PangoAttrInt      PangoAttrInt;
####typedef struct _PangoAttrFloat    PangoAttrFloat;
####typedef struct _PangoAttrColor    PangoAttrColor;
####typedef struct _PangoAttrFontDesc PangoAttrFontDesc;
####typedef struct _PangoAttrShape    PangoAttrShape;
####
####struct _PangoAttribute
####{
####  const PangoAttrClass *klass;
####  guint start_index;
####  guint end_index;
####};
##
##guint
##start_index (PangoAttribute * attr, ...)
##    ALIAS:
##	end_index = 1
##    CODE:
##	RETVAL = ix == 0 ? attr->start_index : attr->end_index;
##	if (items > 1) {
##		guint new_index = SvIV (ST (1));
##		if (ix == 0)
##			attr->start_index = new_index;
##		else
##			attr->end_index = new_index;
##	}
##    OUTPUT:
##	RETVAL
##
####typedef gboolean (*PangoAttrFilterFunc) (PangoAttribute *attribute,
####					 gpointer        data);
##
##
#### FIXME  not sure what to do with this
####PangoAttrType    pango_attr_type_register (const gchar          *name);
##
##PangoAttribute_own * pango_attribute_copy (PangoAttribute * attr)
##
#### this is automatic
####void             pango_attribute_destroy       (PangoAttribute       *attr);
##
##gboolean pango_attribute_equal (PangoAttribute * attr1, PangoAttribute * attr2)
##
##
##MODULE = Gtk2::Pango::Attributes	PACKAGE = Gtk2::Pango::AttrLanguage	PREFIX = pango_attr_language_
##
##BOOT:
##	gperl_set_isa ("Gtk2::Pango::AttrLanguage", "Gtk2::Pango::Attribute");
##
##PangoAttribute_own * pango_attr_language_new (class, PangoLanguage *language);
##    C_ARGS:
##	language
##
##PangoLanguage *
##value (PangoAttribute * attr, ...)
##    CODE:
##	RETVAL = ((PangoAttrLanguage*)attr)->value;
##	if (items > 1) {
##		/* from the pango source, this is all we need to do. */
##		((PangoAttrLanguage*)attr)->value = SvPangoLanguage (ST (1));
##	}
##    OUTPUT:
##	RETVAL
##
##
##MODULE = Gtk2::Pango::Attributes	PACKAGE = Gtk2::Pango::AttrString
##
##BOOT:
##	gperl_set_isa ("Gtk2::Pango::AttrString", "Gtk2::Pango::Attribute");
##
##gchar *
##value (PangoAttribute * attr, ...)
##    CODE:
##	RETVAL = ((PangoAttrString*)attr)->value;
##	if (items > 1) {
##		/* this feels evil... */
##		g_free (((PangoAttrString*)attr)->value);
##		((PangoAttrString*)attr)->value = g_strdup (SvGChar (ST (1)));
##	}
##    OUTPUT:
##	RETVAL
##
##MODULE = Gtk2::Pango::Attributes	PACKAGE = Gtk2::Pango::AttrFamily	PREFIX = pango_attr_family_
##
##BOOT:
##	gperl_set_isa ("Gtk2::Pango::AttrFamily", "Gtk2::Pango::AttrString");
##
##
##PangoAttribute_own * pango_attr_family_new (class, const char *family);
##    C_ARGS:
##	family
##
##
##
##MODULE = Gtk2::Pango::Attributes	PACKAGE = Gtk2::Pango::AttrColor
##
##BOOT:
##	gperl_set_isa ("Gtk2::Pango::AttrColor", "Gtk2::Pango::Attribute");
##
####struct _PangoAttrColor
####{
####  PangoAttribute attr;
####  PangoColor color;
####};
##
## ##
## ## the PangoAttrColor holds an actual color, not a pointer...
## ## how can we make it editable from perl?  you can replace it,
## ## but you get a copy back and editing it does nothing...
## ##
##PangoColor_copy *
##value (PangoAttribute * attr, ...)
##    CODE:
##	RETVAL = &((PangoAttrColor*)attr)->color;
##	if (items > 1) {
##		PangoColor * color = SvPangoColor (ST (1));
##		((PangoAttrColor*)attr)->color = *color;
##	}
##    OUTPUT:
##	RETVAL
##
##MODULE = Gtk2::Pango::Attributes	PACKAGE = Gtk2::Pango::AttrForeground	PREFIX = pango_attr_foreground_
##
##BOOT:
##	gperl_set_isa ("Gtk2::Pango::AttrForeground", "Gtk2::Pango::AttrColor");
##
##PangoAttribute_own * pango_attr_foreground_new (class, guint16 red, guint green, guint16 blue);
##    C_ARGS:
##	red, green, blue
##
##MODULE = Gtk2::Pango::Attributes	PACKAGE = Gtk2::Pango::AttrBackground	PREFIX = pango_attr_background_
##
##BOOT:
##	gperl_set_isa ("Gtk2::Pango::AttrBackground", "Gtk2::Pango::AttrColor");
##
##PangoAttribute_own * pango_attr_background_new (class, guint16 red, guint green, guint16 blue);
##    C_ARGS:
##	red, green, blue
##
##
##MODULE = Gtk2::Pango::Attributes	PACKAGE = Gtk2::Pango::AttrSize	PREFIX = pango_attr_size_
##
##BOOT:
##	gperl_set_isa ("Gtk2::Pango::AttrSize", "Gtk2::Pango::Attribute");
##
##PangoAttribute_own * pango_attr_size_new (class, int size)
##    C_ARGS:
##	size
##
##int
##value (PangoAttribute * attr, ...)
##    ALIAS:
##	absolute = 1
##    PREINIT:
##	/* later versions of pango use PangoAttrSize rather than
##	 * PangoAttrInt... */
##	PangoAttrInt * attrsize;
##    CODE:
##	attrsize = (PangoAttrInt *) attr;
##	RETVAL = attrsize->value;
##	if (items > 1)
##		attrsize->value = SvIV (ST (1));
##    OUTPUT:
##	RETVAL
##
##
##MODULE = Gtk2::Pango::Attributes	PACKAGE = Gtk2::Pango::AttrStyle	PREFIX = pango_attr_style_
##
##BOOT:
##	gperl_set_isa ("Gtk2::Pango::AttrStyle", "Gtk2::Pango::Attribute");
##
##PangoAttribute_own * pango_attr_style_new (class, PangoStyle style)
##    C_ARGS:
##	style
##
##PangoStyle
##value (PangoAttribute * attr, ...)
##    CODE:
##	RETVAL = ((PangoAttrInt*) attr)->value;
##	if (items > 1)
##		((PangoAttrInt*) attr)->value = SvPangoStyle (ST (1));
##    OUTPUT:
##	RETVAL
##
##MODULE = Gtk2::Pango::Attributes	PACKAGE = Gtk2::Pango::AttrWeight	PREFIX = pango_attr_weight_
##
##BOOT:
##	gperl_set_isa ("Gtk2::Pango::AttrWeight", "Gtk2::Pango::Attribute");
##
##PangoAttribute_own * pango_attr_weight_new (class, PangoWeight weight)
##    C_ARGS:
##	weight
##
##PangoWeight
##value (PangoAttribute * attr, ...)
##    CODE:
##	RETVAL = ((PangoAttrInt*) attr)->value;
##	if (items > 1)
##		((PangoAttrInt*) attr)->value = SvPangoWeight (ST (1));
##    OUTPUT:
##	RETVAL
##
##MODULE = Gtk2::Pango::Attributes	PACKAGE = Gtk2::Pango::AttrVariant	PREFIX = pango_attr_variant_
##
##BOOT:
##	gperl_set_isa ("Gtk2::Pango::AttrVariant", "Gtk2::Pango::Attribute");
##
##PangoAttribute_own * pango_attr_variant_new (class, PangoVariant variant)
##    C_ARGS:
##	variant
##
##PangoVariant
##value (PangoAttribute * attr, ...)
##    CODE:
##	RETVAL = ((PangoAttrInt*) attr)->value;
##	if (items > 1)
##		((PangoAttrInt*) attr)->value = SvPangoVariant (ST (1));
##    OUTPUT:
##	RETVAL
##
##MODULE = Gtk2::Pango::Attributes	PACKAGE = Gtk2::Pango::AttrStretch	PREFIX = pango_attr_stretch_
##
##BOOT:
##	gperl_set_isa ("Gtk2::Pango::AttrStretch", "Gtk2::Pango::Attribute");
##
##PangoAttribute_own * pango_attr_stretch_new (class, PangoStretch stretch)
##    C_ARGS:
##	stretch
##
##PangoStretch
##value (PangoAttribute * attr, ...)
##    CODE:
##	RETVAL = ((PangoAttrInt*) attr)->value;
##	if (items > 1)
##		((PangoAttrInt*) attr)->value = SvPangoStretch (ST (1));
##    OUTPUT:
##	RETVAL
##
##MODULE = Gtk2::Pango::Attributes	PACKAGE = Gtk2::Pango::AttrUnderline	PREFIX = pango_attr_underline_
##
##BOOT:
##	gperl_set_isa ("Gtk2::Pango::AttrUnderline", "Gtk2::Pango::Attribute");
##
##PangoAttribute_own * pango_attr_underline_new (class, PangoUnderline underline)
##    C_ARGS:
##	underline
##
##PangoUnderline
##value (PangoAttribute * attr, ...)
##    CODE:
##	RETVAL = ((PangoAttrInt*) attr)->value;
##	if (items > 1)
##		((PangoAttrInt*) attr)->value = SvPangoUnderline (ST (1));
##    OUTPUT:
##	RETVAL
##
##MODULE = Gtk2::Pango::Attributes	PACKAGE = Gtk2::Pango::AttrStrikethrough	PREFIX = pango_attr_strikethrough_
##
##BOOT:
##	gperl_set_isa ("Gtk2::Pango::AttrStrikethrough", "Gtk2::Pango::Attribute");
##
##PangoAttribute_own * pango_attr_strikethrough_new (class, gboolean strikethrough)
##    C_ARGS:
##	strikethrough
##
##gboolean
##value (PangoAttribute * attr, ...)
##    CODE:
##	RETVAL = ((PangoAttrInt*) attr)->value;
##	if (items > 1)
##		((PangoAttrInt*) attr)->value = SvTRUE (ST (1));
##    OUTPUT:
##	RETVAL
##
##MODULE = Gtk2::Pango::Attributes	PACKAGE = Gtk2::Pango::AttrFontDesc	PREFIX = pango_attr_font_desc_
##
##BOOT:
##	gperl_set_isa ("Gtk2::Pango::AttrFontDesc", "Gtk2::Pango::Attribute");
##
##PangoAttribute_own * pango_attr_font_desc_new (class, PangoFontDescription * font_desc)
##    C_ARGS:
##	font_desc
##
##PangoFontDescription *
##desc (PangoAttribute * attr, ...)
##    CODE:
##	RETVAL = ((PangoAttrFontDesc*) attr)->desc;
##	if (items > 1) {
##		pango_font_description_free (((PangoAttrFontDesc*) attr)->desc);
##		((PangoAttrFontDesc*) attr)->desc =
##			pango_font_description_copy (SvPangoFontDescription (ST (1)));
##	}
##    OUTPUT:
##	RETVAL
##
##MODULE = Gtk2::Pango::Attributes	PACKAGE = Gtk2::Pango::AttrScale	PREFIX = pango_attr_scale_
##
##BOOT:
##	gperl_set_isa ("Gtk2::Pango::AttrScale", "Gtk2::Pango::Attribute");
##
##PangoAttribute_own * pango_attr_scale_new (class, float scale)
##    C_ARGS:
##	scale
##
##float
##value (PangoAttribute * attr, ...)
##    CODE:
##	RETVAL = ((PangoAttrFloat*) attr)->value;
##	if (items > 1)
##		((PangoAttrFloat*) attr)->value = SvNV (ST (1));
##    OUTPUT:
##	RETVAL
##
##MODULE = Gtk2::Pango::Attributes	PACKAGE = Gtk2::Pango::AttrRise	PREFIX = pango_attr_rise_
##
##BOOT:
##	gperl_set_isa ("Gtk2::Pango::AttrRise", "Gtk2::Pango::Attribute");
##
##PangoAttribute_own * pango_attr_rise_new (class, int rise)
##    C_ARGS:
##	rise
##
##int
##value (PangoAttribute * attr, ...)
##    PREINIT:
##	PangoAttrInt * attrint;
##    CODE:
##	attrint = (PangoAttrInt *) attr;
##	RETVAL = attrint->value;
##	if (items > 1)
##		attrint->value = SvIV (ST (1));
##    OUTPUT:
##	RETVAL
##
##
##MODULE = Gtk2::Pango::Attributes	PACKAGE = Gtk2::Pango::AttrShape	PREFIX = pango_attr_shape_
##
##BOOT:
##	gperl_set_isa ("Gtk2::Pango::AttrShape", "Gtk2::Pango::Attribute");
##
#### FIXME  SvPangoRectangle is not currently implemented
##
######PangoAttribute *pango_attr_shape_new         (const PangoRectangle       *ink_rect,
######					      const PangoRectangle       *logical_rect);
####PangoAttribute_own *
####pango_attr_shape_new (class, PangoRectangle *ink_rect, PangoRectangle *logical_rect)
####    C_ARGS:
####	ink_rect, logical_rect
##
####struct _PangoAttrShape
####{
####  PangoAttribute attr;
####  PangoRectangle ink_rect;
####  PangoRectangle logical_rect;
####};
##PangoRectangle *
##ink_rect (PangoAttribute * attr, ...)
##    ALIAS:
##	logical_rect = 1
##    PREINIT:
##	PangoAttrShape * attrshape;
##    CODE:
##	attrshape = (PangoAttrShape *) attr;
##	RETVAL = ix == 0 ? &(attrshape->ink_rect) : &(attrshape->logical_rect);
##	/*
##	if (items > 1) {
##		PangoRectangle * rect = SvPangoRectangle (ST (1));
##		if (ix == 0)
##			attrshape->ink_rect = *rect;
##		else
##			attrshape->logical_rect = *rect;
##	}
##	*/
##    OUTPUT:
##	RETVAL
##
##
##
##MODULE = Gtk2::Pango::Attributes	PACKAGE = Gtk2::Pango::AttrList	PREFIX = pango_attr_list_
##
#### FIXME  cant meaningfully bind PangoAttrList until we bind PangoAttribute.
##
##=for position DESCRIPTION
##
##=head1 DESCRIPTION
##
##Gtk2::Pango::AttrList is a collection of Gtk2::Pango::Attributes.  These
##attributes annotate text with styles.
##
##NOTE:  The various PangoAttribute types are not yet bound, so it is not
##possible at this time to create and manipulate a Gtk2::Pango::AttrList
##directly.  You can, however, use AttrLists you get from other functions,
##and can create an AttrList with C<Gtk2::Pango::parse_markup>.
##
##=cut
##
####  PangoAttrList is a registered boxed type, so these are handled
####  automatically by Glib::Boxed.
####GType              pango_attr_list_get_type      (void) G_GNUC_CONST;
####PangoAttrList *    pango_attr_list_copy          (PangoAttrList  *list);
####void               pango_attr_list_ref           (PangoAttrList  *list);
####void               pango_attr_list_unref         (PangoAttrList  *list);
##
##PangoAttrList_own * pango_attr_list_new (class)
##    C_ARGS:
##	/*void*/
##   
##void pango_attr_list_insert (PangoAttrList *list, PangoAttribute *attr);
##
##void pango_attr_list_insert_before (PangoAttrList *list, PangoAttribute *attr);
##
##void pango_attr_list_change (PangoAttrList *list, PangoAttribute *attr);
##
##void pango_attr_list_splice (PangoAttrList *list, PangoAttrList *other, gint pos, gint len);
##
####PangoAttrList *pango_attr_list_filter (PangoAttrList       *list,
####				       PangoAttrFilterFunc  func,
####				       gpointer             data);
####
####
####  FIXME  PangoAttrIterator is not a boxed type, but is an opaque type.
####typedef struct _PangoAttrIterator PangoAttrIterator;
####PangoAttrIterator *pango_attr_list_get_iterator  (PangoAttrList  *list);
####
####void               pango_attr_iterator_range    (PangoAttrIterator     *iterator,
####                                                 gint                  *start,
####                                                 gint                  *end);
####gboolean           pango_attr_iterator_next     (PangoAttrIterator     *iterator);
####PangoAttrIterator *pango_attr_iterator_copy     (PangoAttrIterator     *iterator);
####void               pango_attr_iterator_destroy  (PangoAttrIterator     *iterator);
####PangoAttribute *   pango_attr_iterator_get      (PangoAttrIterator     *iterator,
####                                                 PangoAttrType          type);
####void               pango_attr_iterator_get_font (PangoAttrIterator     *iterator,
####                                                 PangoFontDescription  *desc,
####						 PangoLanguage        **language,
####                                                 GSList               **extra_attrs);
####GSList *          pango_attr_iterator_get_attrs (PangoAttrIterator     *iterator);
#endif

MODULE = Gtk2::Pango::Attributes	PACKAGE = Gtk2::Pango	PREFIX = pango_

# don't clobber the pod for Gtk2::Pango!
=for object Gtk2::Pango::AttrList
=cut

##gboolean pango_parse_markup (const char                 *markup_text,
##                             int                         length,
##                             gunichar                    accel_marker,
##                             PangoAttrList             **attr_list,
##                             char                      **text,
##                             gunichar                   *accel_char,
##                             GError                    **error);
##
=for apidoc __gerror__
=for signature ($attr_list, $text, $accel_char) = Gtk2::Pango->parse_markup ($markup_text, $accel_marker)
Parses marked-up text to create a plaintext string and an attribute list.

If I<$accel_marker> is supplied and nonzero, the given character will mark the
character following it as an accelerator.  For example, the accel marker might
be an ampersand or underscore.  All characters marked as an acclerator will
receive a PANGO_UNDERLINE_LOW attribute, and the first character so marked will
be returned in I<$accel_char>.  Two I<$accel_marker> characters following each
other reduce to a single literal I<$accel_marker> character.
=cut
void
pango_parse_markup (class, const gchar_length * markup_text, int length(markup_text), gunichar accel_marker=0)
    PREINIT:
	PangoAttrList * attr_list;
	char * text;
	gunichar accel_char;
	GError * error = NULL;
    PPCODE:
	if (! pango_parse_markup (markup_text, XSauto_length_of_markup_text,
				  accel_marker, &attr_list, &text,
				  &accel_char, &error))
		gperl_croak_gerror (NULL, error);
	EXTEND (SP, 3);
	PUSHs (sv_2mortal (newSVPangoAttrList (attr_list)));
	PUSHs (sv_2mortal (newSVGChar (text)));
	g_free (text);
	if (accel_char) {
		/* adapted from Glib/typemap */
		gchar temp[6];
		gint length = g_unichar_to_utf8 (accel_char, temp);
		PUSHs (sv_2mortal (newSVpv (temp, length)));
		SvUTF8_on (ST (2));
	}

