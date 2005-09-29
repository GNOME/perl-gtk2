/*
 * Copyright (c) 2005 by the gtk2-perl team (see the file AUTHORS)
 *
 * Licensed under the LGPL, see LICENSE file for more information.
 *
 * $Header$
 */

#include "gtk2perl.h"

MODULE = Gtk2::Atk::Value	PACKAGE = Gtk2::Atk::Value	PREFIX = atk_value_

# void atk_value_get_current_value (AtkValue *obj, GValue *value);
# void atk_value_get_maximum_value (AtkValue *obj, GValue *value);
# void atk_value_get_minimum_value (AtkValue *obj, GValue *value);
SV *
atk_value_get_current_value (obj)
	AtkValue *obj
    ALIAS:
	Gtk2::Atk::Value::get_maximum_value = 1
	Gtk2::Atk::Value::get_minimum_value = 2
    PREINIT:
	GValue *value = NULL;
    CODE:
	switch (ix) {
	    case 0:
		atk_value_get_current_value (obj, value);
		break;

	    case 1:
		atk_value_get_maximum_value (obj, value);
		break;

	    case 2:
		atk_value_get_minimum_value (obj, value);
		break;
	}

	RETVAL = gperl_sv_from_value (value);
	g_value_unset (value);
    OUTPUT:
	RETVAL

# FIXME
# gboolean atk_value_set_current_value (AtkValue *obj, const GValue *value);
