/*
 * Copyright (c) 2006 by the gtk2-perl team (see the file AUTHORS)
 *
 * Licensed under the LGPL, see LICENSE file for more information.
 *
 * $Header$
 */

#include "gtk2perl.h"

static GPerlCallback *
gtk2perl_print_settings_func_create (SV * func, SV * data)
{
	GType param_types [2];
	param_types[0] = G_TYPE_STRING;
	param_types[1] = G_TYPE_STRING;
	return gperl_callback_new (func, data, G_N_ELEMENTS (param_types),
				   param_types, 0);
}

static void
gtk2perl_print_settings_func (const gchar *key, const gchar *value, gpointer data)
{
	gperl_callback_invoke ((GPerlCallback *) data, NULL, key, value);
}

MODULE = Gtk2::PrintSettings	PACKAGE = Gtk2::PrintSettings	PREFIX = gtk_print_settings_

# GtkPrintSettings * gtk_print_settings_new (void);
GtkPrintSettings_noinc * gtk_print_settings_new (class)
    C_ARGS:
	/* void */

# Needed?
# GtkPrintSettings * gtk_print_settings_copy (GtkPrintSettings *other);

gboolean gtk_print_settings_has_key (GtkPrintSettings *settings, const gchar *key);

const gchar_ornull * gtk_print_settings_get (GtkPrintSettings *settings, const gchar *key);

void gtk_print_settings_set (GtkPrintSettings *settings, const gchar *key, const gchar_ornull *value);

void gtk_print_settings_unset (GtkPrintSettings *settings, const gchar *key);

# void gtk_print_settings_foreach (GtkPrintSettings *settings, GtkPrintSettingsFunc func, gpointer user_data);
void
gtk_print_settings_foreach (GtkPrintSettings *settings, SV *func, SV *data=NULL)
    PREINIT:
	GPerlCallback *callback;
    CODE:
	callback = gtk2perl_print_settings_func_create (func, data);
	gtk_print_settings_foreach (settings, gtk2perl_print_settings_func,
	                            callback);
	gperl_callback_destroy (callback);
