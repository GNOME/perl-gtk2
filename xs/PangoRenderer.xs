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

MODULE = Gtk2::Pango::Renderer	PACKAGE = Gtk2::Pango::Renderer	PREFIX = pango_renderer_

BOOT:
	PERL_UNUSED_VAR (file);

#if PANGO_CHECK_VERSION (1, 8, 0)

void pango_renderer_draw_layout (PangoRenderer *renderer, PangoLayout *layout, int x, int y);

# FIXME: Need PangoLayoutLine bindings.
# void pango_renderer_draw_layout_line (PangoRenderer *renderer, PangoLayoutLine *line, int x, int y);

# FIXME: We do have typemaps for PangoGlyphString, but no way to actually get
#        one.  pango_shape() would be about the only function that returns one,
#        AFAICT.
# void pango_renderer_draw_glyphs (PangoRenderer *renderer, PangoFont *font, PangoGlyphString *glyphs, int x, int y);

void pango_renderer_draw_rectangle (PangoRenderer *renderer, PangoRenderPart part, int x, int y, int width, int height);

void pango_renderer_draw_error_underline (PangoRenderer *renderer, int x, int y, int width, int height);

void pango_renderer_draw_trapezoid (PangoRenderer *renderer, PangoRenderPart part, double y1_, double x11, double x21, double y2, double x12, double x22);

void pango_renderer_draw_glyph (PangoRenderer *renderer, PangoFont *font, PangoGlyph glyph, double x, double y);

void pango_renderer_activate (PangoRenderer *renderer);

void pango_renderer_deactivate (PangoRenderer *renderer);

void pango_renderer_part_changed (PangoRenderer *renderer, PangoRenderPart part);

# FIXME: PangoColor not usable at the moment.  Maybe just bind it as an
#        anonmous array reference?
# void pango_renderer_set_color (PangoRenderer *renderer, PangoRenderPart part, const PangoColor_ornull *color);
# PangoColor_ornull *pango_renderer_get_color (PangoRenderer *renderer, PangoRenderPart part);

void pango_renderer_set_matrix (PangoRenderer *renderer, const PangoMatrix_ornull *matrix);

const PangoMatrix_ornull *pango_renderer_get_matrix (PangoRenderer *renderer);

#endif /* 1.8.0 */
