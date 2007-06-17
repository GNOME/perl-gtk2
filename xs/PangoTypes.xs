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

MODULE = Gtk2::Pango::Types	PACKAGE = Gtk2::Pango	PREFIX = pango_

#if PANGO_CHECK_VERSION (1, 4, 0)

=for object Gtk2::Pango::Language
=cut

##  PangoDirection pango_find_base_dir (const gchar *text, gint length)
PangoDirection
pango_find_base_dir (class, text)
	const gchar *text
    C_ARGS:
	text, strlen (text)

#endif

#if PANGO_CHECK_VERSION (1, 16, 0)

=for object Gtk2::Pango::Font
=cut

=for apidoc __function__
=cut
int pango_units_from_double (double d);

=for apidoc __function__
=cut
double pango_units_to_double (int i);

=for apidoc __function__
=cut
##  void pango_extents_to_pixels (PangoRectangle *ink_rect, PangoRectangle *logical_rect)
void
pango_extents_to_pixels (PangoRectangle *ink_rect, PangoRectangle *logical_rect)
    PPCODE:
	pango_extents_to_pixels (ink_rect, logical_rect);
	EXTEND (SP, 2);
	PUSHs (sv_2mortal (newSVPangoRectangle (ink_rect)));
	PUSHs (sv_2mortal (newSVPangoRectangle (logical_rect)));

#endif

MODULE = Gtk2::Pango::Types	PACKAGE = Gtk2::Pango::Language	PREFIX = pango_language_

##  PangoLanguage * pango_language_from_string (const char *language)
PangoLanguage *
pango_language_from_string (class, language)
	const char *language
    CODE:
	RETVAL = pango_language_from_string (language);
    OUTPUT:
	RETVAL

##  const char * pango_language_to_string (PangoLanguage *language)
const char *
pango_language_to_string (language)
	PangoLanguage *language

# FIXME: WTF is the Gnome2::Pango::Language::matches alias doing here?  It's
# totally bogus, but has been in a stable release already ...
##  gboolean pango_language_matches (PangoLanguage *language, const char *range_list)
gboolean
pango_language_matches (language, range_list)
	PangoLanguage *language
	const char *range_list
    ALIAS:
	Gnome2::Pango::Language::matches = 0
    CLEANUP:
	PERL_UNUSED_VAR (ix);

#if PANGO_CHECK_VERSION (1, 16, 0)

##  PangoLanguage * pango_language_get_default (void)
PangoLanguage *
pango_language_get_default (class)
    C_ARGS:
	/* void */

#endif
