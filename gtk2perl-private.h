/*
 * Copyright (C) 2003-2006 by the gtk2-perl team (see the file AUTHORS for the
 * full list)
 *
 * This library is free software; you can redistribute it and/or modify it
 * under the terms of the GNU Library General Public License as published by
 * the Free Software Foundation; either version 2.1 of the License, or (at your
 * option) any later version.
 *
 * This library is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Library General Public
 * License for more details.
 *
 * You should have received a copy of the GNU Library General Public License
 * along with this library; if not, write to the Free Software Foundation,
 * Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307  USA.
 *
 * THIS IS A PRIVATE HEADER FOR USE ONLY IN Gtk2 ITSELF.
 *
 * $Header$
 */

#ifndef _GTK2PERL_PRIVATE_H_
#define _GTK2PERL_PRIVATE_H_

#include "gtk2perl.h"

/* Implemented in GtkItemFactory.xs. */
GPerlCallback * gtk2perl_translate_func_create (SV * func, SV * data);
gchar * gtk2perl_translate_func (const gchar *path, gpointer data);

/* Implemented in GtkRecentManager.xs */
const gchar ** gtk2perl_sv_to_strv (SV *sv);
SV * gtk2perl_sv_from_strv (const gchar **strv);

#if GTK_CHECK_VERSION (2, 6, 0)
/* Implemented in GtkTreeView.xs. */
GPerlCallback * gtk2perl_tree_view_row_separator_func_create (SV * func,
							      SV * data);
gboolean gtk2perl_tree_view_row_separator_func (GtkTreeModel *model,
				                GtkTreeIter  *iter,
				                gpointer      data);
#endif

/* Implemented in PangoAttributes.xs. */
void gtk2perl_pango_attribute_register_custom_type (PangoAttrType type, const char *package);

#define GTK2PERL_PANGO_ATTR_REGISTER_CUSTOM_TYPE(attr, package)	\
{								\
	static gboolean type_registered_already = FALSE;	\
	if (!type_registered_already) {				\
		gtk2perl_pango_attribute_register_custom_type	\
			((attr)->klass->type, package);		\
		type_registered_already = TRUE;			\
	}							\
}

#define GTK2PERL_PANGO_ATTR_STORE_INDICES(offset, attr)	\
	if (items == offset + 2) {			\
		guint start = SvUV (ST (offset));	\
		guint end = SvUV (ST (offset + 1));	\
		attr->start_index = start;		\
		attr->end_index = end;			\
	}

#endif /* _GTK2PERL_PRIVATE_H_ */
