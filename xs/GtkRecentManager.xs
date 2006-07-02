/* 
 * Copyright (C) 2006 by the gtk2-perl team (see the file AUTHORS for a
 * complete listing)
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with this library; if not, write to the
 * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
 * Boston, MA 02111-1307, USA.
 */

#include "gtk2perl.h"

/*
struct _GtkRecentData
{
  gchar *display_name;
  gchar *description;

  gchar *mime_type;

  gchar *app_name;
  gchar *app_exec;

  gchar **groups;

  gboolean is_private;
};
 */

static GtkRecentData *
SvGtkRecentData (SV *sv)
{
  GtkRecentData *data;
  HV *hv;
  SV **svp;

  if (!sv || !SvOK (sv) || !SvROK (sv) || SvTYPE (SvRV (sv)) != SVt_PVHV)
	  croak ("invalid recent data - expecting a hash reference");

  hv = (HV *) SvRV (sv);
  
  data = gperl_alloc_temp (sizeof (GtkRecentData));

  if ((svp = hv_fetch (hv, "display_name", 12, 0)))
	  data->display_name = SvGChar (*svp);

  if ((svp = hv_fetch (hv, "description", 11, 0)))
	  data->description = SvGChar (*svp);

  if ((svp = hv_fetch (hv, "mime_type", 9, 0)))
	  data->mime_type = SvGChar (*svp);

  if ((svp = hv_fetch (hv, "app_name", 8, 0)))
	  data->app_name = SvGChar (*svp);

  if ((svp = hv_fetch (hv, "app_exec", 8, 0)))
	  data->app_exec = SvGChar (*svp);

  if ((svp = hv_fetch (hv, "is_private", 10, 0)))
	  data->is_private = SvIV (*svp);

#if 0 /* FIXME */
  if ((svp = hv_fetch (hv, "groups", 6, 0)))
	  data->groups = SvGStrv (*svp);
#endif
  
  return data;
}

MODULE = Gtk2::RecentManager	PACKAGE = Gtk2::RecentManager	PREFIX = gtk_recent_manager_


=for enum GtkRecentManagerError
=cut

GtkRecentManager_noinc *
gtk_recent_manager_new (class)
    C_ARGS:
        /* void */

GtkRecentManager *
gtk_recent_manager_get_default (class)
    C_ARGS:
        /* void */

GtkRecentManager *
gtk_recent_manager_get_for_screen (class, GdkScreen *screen)
    C_ARGS:
        screen

void
gtk_recent_manager_set_screen (GtkRecentManager *manager, GdkScreen *screen)

gboolean
gtk_recent_manager_add_item (GtkRecentManager *manager, const gchar *uri)

gboolean
gtk_recent_manager_add_full (GtkRecentManager *manager, const gchar *uri, SV *data)
    C_ARGS:
        manager, uri, SvGtkRecentData (data)

=for apidoc __gerror__
=cut
void
gtk_recent_manager_remove_item (GtkRecentManager *manager, const gchar *uri)
    PREINIT:
        GError *error = NULL;
    CODE:
        gtk_recent_manager_remove_item (manager, uri, &error);
	if (error)
		gperl_croak_gerror (NULL, error);

=for apidoc __gerror__
=cut
GtkRecentInfo *
gtk_recent_manager_lookup_item (GtkRecentManager *manager, const gchar *uri)
    PREINIT:
        GError *error = NULL;
    CODE:
        RETVAL = gtk_recent_manager_lookup_item (manager, uri, &error);
	if (error)
		gperl_croak_gerror (NULL, error);
    OUTPUT:
        RETVAL

gboolean
gtk_recent_manager_has_item (GtkRecentManager *manager, const gchar *uri)

=for apidoc __gerror__
=cut
void
gtk_recent_manager_move_item (manager, old_uri, new_uri)
	GtkRecentManager *manager
	const gchar *old_uri
	const gchar_ornull *new_uri
    PREINIT:
        GError *error = NULL;
    CODE:
        gtk_recent_manager_move_item (manager, old_uri, new_uri, &error);
	if (error)
		gperl_croak_gerror (NULL, error);

void
gtk_recent_manager_set_limit (GtkRecentManager *manager, gint limit)

gint
gtk_recent_manager_get_limit (GtkRecentManager *manager)

=for apidoc
=for signature (items) = $manager->get_items
=cut
void
gtk_recent_manager_get_items (GtkRecentManager *manager)
    PREINIT:
        GList *items, *l;
    PPCODE:
        items = gtk_recent_manager_get_items (manager);
	for (l = items; l != NULL; l = l->next) {
		GtkRecentInfo *info = l->data;

		XPUSHs (sv_2mortal (newSVGtkRecentInfo (info)));

		gtk_recent_info_unref (info);
	}
	g_list_free (items);

=for apidoc __gerror__
=cut
gint
gtk_recent_manager_purge_items (GtkRecentManager *manager)
    PREINIT:
        GError *error = NULL;
    CODE:
        RETVAL = gtk_recent_manager_purge_items (manager, &error);
	if (error)
		gperl_croak_gerror (NULL, error);
    OUTPUT:
        RETVAL

#
# GtkRecentInfo
#


