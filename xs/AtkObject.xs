/*
 * Copyright (c) 2005 by the gtk2-perl team (see the file AUTHORS)
 *
 * Licensed under the LGPL, see LICENSE file for more information.
 *
 * $Header$
 */

#include "gtk2perl.h"

MODULE = Gtk2::Atk::Object	PACKAGE = Gtk2::Atk::Object	PREFIX = atk_object_

const gchar* atk_object_get_name (AtkObject *accessible);

const gchar* atk_object_get_description (AtkObject *accessible);

AtkObject* atk_object_get_parent (AtkObject *accessible);

gint atk_object_get_n_accessible_children (AtkObject *accessible);

AtkObject_noinc* atk_object_ref_accessible_child (AtkObject *accessible, gint i);

AtkRelationSet_noinc* atk_object_ref_relation_set (AtkObject *accessible);

AtkRole atk_object_get_role (AtkObject *accessible);

AtkLayer atk_object_get_layer (AtkObject *accessible);

gint atk_object_get_mdi_zorder (AtkObject *accessible);

AtkStateSet_noinc* atk_object_ref_state_set (AtkObject *accessible);

gint atk_object_get_index_in_parent (AtkObject *accessible);

void atk_object_set_name (AtkObject *accessible, const gchar *name);

void atk_object_set_description (AtkObject *accessible, const gchar *description);

void atk_object_set_parent (AtkObject *accessible, AtkObject *parent);

void atk_object_set_role (AtkObject *accessible, AtkRole role);

# FIXME
# guint atk_object_connect_property_change_handler (AtkObject *accessible, AtkPropertyChangeHandler *handler);
# void atk_object_remove_property_change_handler (AtkObject *accessible, guint handler_id);

void atk_object_notify_state_change (AtkObject *accessible, AtkStateType state, gboolean value);

# FIXME
# void atk_object_initialize (AtkObject *accessible, gpointer data);

# FIXME
# const gchar* atk_role_get_name (AtkRole role);
# AtkRole atk_role_for_name (const gchar *name);

#if ATK_CHECK_VERSION (1, 1, 0)

gboolean atk_object_add_relationship (AtkObject *object, AtkRelationType relationship, AtkObject *target);

gboolean atk_object_remove_relationship (AtkObject *object, AtkRelationType relationship, AtkObject *target);

# FIXME
# const gchar* atk_role_get_localized_name (AtkRole role);

#endif
