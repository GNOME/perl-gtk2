/*
 * Copyright (c) 2007 by the gtk2-perl team (see the file AUTHORS)
 *
 * Licensed under the LGPL, see LICENSE file for more information.
 *
 * $Id$
 */

#include "gtk2perl.h"

MODULE = Gtk2::Buildable	PACKAGE = Gtk2::Buildable	PREFIX = gtk_buildable_

# These two theoretically collide with Gtk2::Widget::set_name and get_name when
# dealing with Gtk2::Widgets.  Fortunately though, GtkWidget maps these vfuncs
# to gtk_widget_set_name and _get_name anyway.

void gtk_buildable_set_name (GtkBuildable *buildable, const gchar *name);

const gchar * gtk_buildable_get_name (GtkBuildable *buildable);

void gtk_buildable_add_child (GtkBuildable *buildable, GtkBuilder *builder, GObject *child, const gchar_ornull *type);

# void gtk_buildable_set_buildable_property (GtkBuildable *buildable, GtkBuilder *builder, const gchar *name, const GValue *value);
=for apidoc
=for signature $buildable->set_buildable_property ($builder, key => $value, ...)
=for arg ... (__hide__)
=cut
void
gtk_buildable_set_buildable_property (GtkBuildable *buildable, GtkBuilder *builder, ...)
    PREINIT:
	GValue value = {0,};
	int i;
    CODE:
#define OFFSET 2
	if (0 != ((items - OFFSET) % 2))
		croak ("set_property expects name => value pairs "
		       "(odd number of arguments detected)");

	for (i = OFFSET; i < items; i += 2) {
		gchar *name = SvGChar (ST (i));
		SV *newval = ST (i + 1);

		GParamSpec *pspec =
			g_object_class_find_property (G_OBJECT_GET_CLASS (buildable),
						      name);

		if (!pspec) {
			const char *classname =
				gperl_object_package_from_type (G_OBJECT_TYPE (buildable));
			if (!classname)
				classname = G_OBJECT_TYPE_NAME (buildable);
			croak ("type %s does not support property '%s'",
			       classname, name);
		}

		g_value_init (&value, G_PARAM_SPEC_VALUE_TYPE (pspec));
		gperl_value_from_sv (&value, newval);
		gtk_buildable_set_buildable_property (buildable, builder, name, &value);
		g_value_unset (&value);
	}
#undef OFFSET

# FIXME: How do we deal with ownership of the returned object?
GObject * gtk_buildable_construct_child (GtkBuildable *buildable, GtkBuilder *builder, const gchar *name);

# FIXME: Needed?  If so, how do we deal with GMarkupParser?
# gboolean gtk_buildable_custom_tag_start (GtkBuildable *buildable, GtkBuilder *builder, GObject *child, const gchar *tagname, GMarkupParser *parser, gpointer *data);
# void gtk_buildable_custom_tag_end (GtkBuildable *buildable, GtkBuilder *builder, GObject *child, const gchar *tagname, gpointer *data);
# void gtk_buildable_custom_finished (GtkBuildable *buildable, GtkBuilder *builder, GObject *child, const gchar *tagname, gpointer data);

void gtk_buildable_parser_finished (GtkBuildable *buildable, GtkBuilder *builder);

GObject * gtk_buildable_get_internal_child (GtkBuildable *buildable, GtkBuilder *builder, const gchar *childname);
