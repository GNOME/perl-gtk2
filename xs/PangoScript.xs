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

/* ------------------------------------------------------------------------- */

GType
gtk2perl_pango_script_iter_get_type (void)
{
	static GType t = 0;
	if (!t)
		t = g_boxed_type_register_static ("PangoScriptIter",
		      (GBoxedCopyFunc) g_boxed_copy,
		      (GBoxedFreeFunc) pango_script_iter_free);
	return t;
}

/* ------------------------------------------------------------------------- */

MODULE = Gtk2::Pango::Script	PACKAGE = Gtk2::Pango::Script	PREFIX = pango_script_

##  PangoScript pango_script_for_unichar (gunichar ch)
PangoScript
pango_script_for_unichar (class, ch)
	gunichar ch
    C_ARGS:
	ch

##  PangoLanguage * pango_script_get_sample_language (PangoScript script)
PangoLanguage_ornull *
pango_script_get_sample_language (class, script)
	PangoScript script
    C_ARGS:
	script

MODULE = Gtk2::Pango::Script	PACKAGE = Gtk2::Pango::ScriptIter	PREFIX = pango_script_iter_

##  Using gchar instead of char here all over the place to enforce utf8.

##  PangoScriptIter * pango_script_iter_new (const char *text, int length)
PangoScriptIter *
pango_script_iter_new (class, text)
	const gchar *text
    CODE:
	RETVAL = pango_script_iter_new (text, strlen (text));
    OUTPUT:
	RETVAL

=for apidoc

Returns the bounds and the script for the region pointed to by I<$iter>.

=cut
##  void pango_script_iter_get_range (PangoScriptIter *iter, G_CONST_RETURN char **start, G_CONST_RETURN char **end, PangoScript *script)
void
pango_script_iter_get_range (iter)
	PangoScriptIter *iter
    PREINIT:
	gchar *start = NULL;
	gchar *end = NULL;
	PangoScript script;
    PPCODE:
	pango_script_iter_get_range (iter,
	                             (const char **) &start,
	                             (const char **) &end,
	                             &script);
	EXTEND (sp, 3);
	PUSHs (sv_2mortal (newSVGChar (start)));
	PUSHs (sv_2mortal (newSVGChar (end)));
	PUSHs (sv_2mortal (newSVPangoScript (script)));

##  gboolean pango_script_iter_next (PangoScriptIter *iter)
gboolean
pango_script_iter_next (iter)
	PangoScriptIter *iter

##  void pango_script_iter_free (PangoScriptIter *iter)

MODULE = Gtk2::Pango::Script	PACKAGE = Gtk2::Pango::Language	PREFIX = pango_language_

##  gboolean pango_language_includes_script (PangoLanguage *language, PangoScript script)
gboolean
pango_language_includes_script (language, script)
	PangoLanguage *language
	PangoScript script
