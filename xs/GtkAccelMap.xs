/*
 * Copyright (c) 2003 by the gtk2-perl team (see the file AUTHORS)
 *
 * Licensed under the LGPL, see LICENSE file for more information.
 *
 * TODO/FIXME: this whole thing needs fleshed out.
 *
 * $Header$
 */

#include "gtk2perl.h"

MODULE = Gtk2::AccelMap PACKAGE = Gtk2::AccelMap PREFIX = gtk_accel_map_

##  void gtk_accel_map_add_entry (const gchar *accel_path, guint accel_key, GdkModifierType accel_mods)
void
gtk_accel_map_add_entry (class, accel_path, accel_key, accel_mods)
	const gchar     * accel_path
	guint             accel_key
	GdkModifierType   accel_mods
    C_ARGS:
	accel_path, accel_key, accel_mods

##  gboolean gtk_accel_map_lookup_entry (const gchar *accel_path, GtkAccelKey *key)
##gboolean
##gtk_accel_map_lookup_entry (accel_path, key)
##	const gchar * accel_path
##	GtkAccelKey * key

##  gboolean gtk_accel_map_change_entry (const gchar *accel_path, guint accel_key, GdkModifierType accel_mods, gboolean replace)
gboolean
gtk_accel_map_change_entry (class, accel_path, accel_key, accel_mods, replace)
	const gchar     * accel_path
	guint             accel_key
	GdkModifierType   accel_mods
	gboolean          replace
    C_ARGS:
	accel_path, accel_key, accel_mods, replace

##  void gtk_accel_map_load (const gchar *file_name)
void
gtk_accel_map_load (class, file_name)
	const gchar * file_name
    C_ARGS:
	file_name

##  void gtk_accel_map_save (const gchar *file_name)
void
gtk_accel_map_save (class, file_name)
	const gchar * file_name
    C_ARGS:
	file_name


##  void gtk_accel_map_load_fd (gint fd)
void
gtk_accel_map_load_fd (class, fd)
	gint fd
    C_ARGS:
	fd

##  void gtk_accel_map_load_scanner (GScanner *scanner)
##void
##gtk_accel_map_load_scanner (scanner)
##	GScanner *scanner

##  void gtk_accel_map_save_fd (gint fd)
void
gtk_accel_map_save_fd (class, fd)
	gint fd
    C_ARGS:
	fd

##  void gtk_accel_map_add_filter (const gchar *filter_pattern)
## TODO: until foreach's are impelemented this is useless
##void
##gtk_accel_map_add_filter (class, filter_pattern)
##	const gchar * filter_pattern
##    C_ARGS:
##	filter_pattern

##  void gtk_accel_map_foreach (gpointer data, GtkAccelMapForeach foreach_func)
##void
##gtk_accel_map_foreach (data, foreach_func)
##	gpointer data
##	GtkAccelMapForeach foreach_func

##  void gtk_accel_map_foreach_unfiltered (gpointer data, GtkAccelMapForeach foreach_func)
##void
##gtk_accel_map_foreach_unfiltered (data, foreach_func)
##	gpointer data
##	GtkAccelMapForeach foreach_func
