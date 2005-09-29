/*
 * Copyright (c) 2005 by the gtk2-perl team (see the file AUTHORS)
 *
 * Licensed under the LGPL, see LICENSE file for more information.
 *
 * $Header$
 */

#include "gtk2perl.h"

MODULE = Gtk2::Atk::Component	PACKAGE = Gtk2::Atk::Component	PREFIX = atk_component_

# FIXME
# guint atk_component_add_focus_handler (AtkComponent *component, AtkFocusHandler handler);

gboolean atk_component_contains (AtkComponent *component, gint x, gint y, AtkCoordType coord_type);

AtkObject_noinc_ornull* atk_component_ref_accessible_at_point (AtkComponent *component, gint x, gint y, AtkCoordType coord_type);

void atk_component_get_extents (AtkComponent *component, OUTLIST gint x, OUTLIST gint y, OUTLIST gint width, OUTLIST gint height, AtkCoordType coord_type);

void atk_component_get_position (AtkComponent *component, OUTLIST gint x, OUTLIST gint y, AtkCoordType coord_type);

void atk_component_get_size (AtkComponent *component, OUTLIST gint width, OUTLIST gint height);

AtkLayer atk_component_get_layer (AtkComponent *component);

gint atk_component_get_mdi_zorder (AtkComponent *component);

gboolean atk_component_grab_focus (AtkComponent *component);

void atk_component_remove_focus_handler (AtkComponent *component, guint handler_id);

gboolean atk_component_set_extents (AtkComponent *component, gint x, gint y, gint width, gint height, AtkCoordType coord_type);

gboolean atk_component_set_position (AtkComponent *component, gint x, gint y, AtkCoordType coord_type);

gboolean atk_component_set_size (AtkComponent *component, gint width, gint height);
