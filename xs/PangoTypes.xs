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

##  gboolean pango_language_matches (PangoLanguage *language, const char *range_list)
gboolean
pango_language_matches (language, range_list)
	PangoLanguage *language
	const char *range_list
    ALIAS:
	Gnome2::Pango::Language::matches = 0
    CLEANUP:
	PERL_UNUSED_VAR (ix);

MODULE = Gtk2::Pango::Types	PACKAGE = Gtk2::Pango::Matrix	PREFIX = pango_matrix_

#if PANGO_CHECK_VERSION (1, 5, 0) /* FIXME: 1.6 */

double
xx (matrix, new = 0)
	PangoMatrix *matrix
	double new
    ALIAS:
	Gtk2::Pango::Matrix::xy = 1
	Gtk2::Pango::Matrix::yx = 2
	Gtk2::Pango::Matrix::yy = 3
	Gtk2::Pango::Matrix::x0 = 4
	Gtk2::Pango::Matrix::y0 = 5
    CODE:
	RETVAL = 0.0;

	switch (ix) {
		case 0: RETVAL = matrix->xx; break;
		case 1: RETVAL = matrix->xy; break;
		case 2: RETVAL = matrix->yx; break;
		case 3: RETVAL = matrix->yy; break;
		case 4: RETVAL = matrix->x0; break;
		case 5: RETVAL = matrix->y0; break;
		default: g_assert_not_reached ();
	}

	if (items == 2) {
		switch (ix) {
			case 0: matrix->xx = new; break;
			case 1: matrix->xy = new; break;
			case 2: matrix->yx = new; break;
			case 3: matrix->yy = new; break;
			case 4: matrix->x0 = new; break;
			case 5: matrix->y0 = new; break;
			default: g_assert_not_reached ();
		}
	}
    OUTPUT:
	RETVAL

PangoMatrix_own *
pango_matrix_new (class, xx = 1., xy = 0., yx = 0., yy = 1., x0 = 0., y0 = 0.)
	double xx
	double xy
	double yx
	double yy
	double x0
	double y0
    CODE:
	RETVAL = g_new0 (PangoMatrix, 1);
	RETVAL->xx = xx;
	RETVAL->xy = xy;
	RETVAL->yx = yx;
	RETVAL->yy = yy;
	RETVAL->x0 = x0;
	RETVAL->y0 = y0;
    OUTPUT:
	RETVAL

##  void pango_matrix_translate (PangoMatrix *matrix, double tx, double ty)
void
pango_matrix_translate (matrix, tx, ty)
	PangoMatrix *matrix
	double tx
	double ty

##  void pango_matrix_scale (PangoMatrix *matrix, double scale_x, double scale_y)
void
pango_matrix_scale (matrix, scale_x, scale_y)
	PangoMatrix *matrix
	double scale_x
	double scale_y

##  void pango_matrix_rotate (PangoMatrix *matrix, double degrees)
void
pango_matrix_rotate (matrix, degrees)
	PangoMatrix *matrix
	double degrees

##  void pango_matrix_concat (PangoMatrix *matrix, PangoMatrix *new_matrix)
void
pango_matrix_concat (matrix, new_matrix)
	PangoMatrix *matrix
	PangoMatrix *new_matrix

#endif
