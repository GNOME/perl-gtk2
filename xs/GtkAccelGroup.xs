/*
 * $Header$
 */

#include "gtk2perl.h"

MODULE = Gtk2::AccelGroup	PACKAGE = Gtk2::AccelGroup	PREFIX = gtk_accel_group_

## GtkAccelGroup* gtk_accel_group_new (void)
GtkAccelGroup *
gtk_accel_group_new (class)
	SV * class
    C_ARGS:

## void gtk_accel_group_lock (GtkAccelGroup *accel_group)
void
gtk_accel_group_lock (accel_group)
	GtkAccelGroup * accel_group

## void gtk_accel_group_unlock (GtkAccelGroup *accel_group)
void
gtk_accel_group_unlock (accel_group)
	GtkAccelGroup * accel_group

# TODO: GClosure * not in typemap
## void gtk_accel_group_connect (GtkAccelGroup *accel_group, guint accel_key, GdkModifierType accel_mods, GtkAccelFlags accel_flags, GClosure *closure)
#void
#gtk_accel_group_connect (accel_group, accel_key, accel_mods, accel_flags, closure)
#	GtkAccelGroup   * accel_group
#	guint             accel_key
#	GdkModifierType   accel_mods
#	GtkAccelFlags     accel_flags
#	GClosure        * closure

# TODO: GClosure * not in typemap
## void gtk_accel_group_connect_by_path (GtkAccelGroup *accel_group, const gchar *accel_path, GClosure *closure)
#void
#gtk_accel_group_connect_by_path (accel_group, accel_path, closure)
#	GtkAccelGroup * accel_group
#	const gchar   * accel_path
#	GClosure      * closure

# TODO: GClosure * not in typemap
## gboolean gtk_accel_group_disconnect (GtkAccelGroup *accel_group, GClosure *closure)
#gboolean
#gtk_accel_group_disconnect (accel_group, closure)
#	GtkAccelGroup * accel_group
#	GClosure      * closure

## gboolean gtk_accel_group_disconnect_key (GtkAccelGroup *accel_group, guint accel_key, GdkModifierType accel_mods)
gboolean
gtk_accel_group_disconnect_key (accel_group, accel_key, accel_mods)
	GtkAccelGroup   * accel_group
	guint             accel_key
	GdkModifierType   accel_mods

## gboolean gtk_accel_groups_activate (GObject *object, guint accel_key, GdkModifierType accel_mods)
gboolean
gtk_accel_groups_activate (object, accel_key, accel_mods)
	GObject         * object
	guint             accel_key
	GdkModifierType   accel_mods

# TODO: GSList* not in typemap
## GSList* gtk_accel_groups_from_object (GObject *object)
#GSList *
#gtk_accel_groups_from_object (object)
#	GObject * object

# TODO: this wants a function pointer as a parameter
## GtkAccelKey* gtk_accel_group_find (GtkAccelGroup *accel_group, gboolean (*find_func) (GtkAccelKey *key, GClosure *closure, gpointer data), gpointer data)
#GtkAccelKey *
#gtk_accel_group_find (accel_group, key, closure, *, data)
#	GtkAccelGroup * accel_group
#	gboolean        (*find_func) (GtkAccelKey *key, GClosure *closure, gpointer data)
#	gpointer        data

# TODO: GClosure * not in typemap
## GtkAccelGroup* gtk_accel_group_from_accel_closure (GClosure *closure)
#GtkAccelGroup *
#gtk_accel_group_from_accel_closure (closure)
#	GClosure * closure

MODULE = Gtk2::AccelGroup	PACKAGE = Gtk2::Accelerator	PREFIX = gtk_accelerator_

## void gtk_accelerator_parse (const gchar *accelerator, guint *accelerator_key, GdkModifierType *accelerator_mods)
void
gtk_accelerator_parse (class, accelerator)
	SV              * class
	const gchar     * accelerator
    PREINIT:
	guint           accelerator_key;
	GdkModifierType accelerator_mods;
    PPCODE:
	gtk_accelerator_parse (accelerator, &accelerator_key, 
	                       &accelerator_mods);
	XPUSHs (sv_2mortal (newSVuv (accelerator_key)));
	XPUSHs (sv_2mortal (newSVGdkModifierType (accelerator_mods)));

## gchar* gtk_accelerator_name (guint accelerator_key, GdkModifierType accelerator_mods)
gchar *
gtk_accelerator_name (class, accelerator_key, accelerator_mods)
	SV              * class
	guint             accelerator_key
	GdkModifierType   accelerator_mods
    C_ARGS:
	accelerator_key, accelerator_mods
    CLEANUP:
	g_free (RETVAL);

## void gtk_accelerator_set_default_mod_mask (GdkModifierType default_mod_mask)
void
gtk_accelerator_set_default_mod_mask (default_mod_mask)
	GdkModifierType default_mod_mask

## guint gtk_accelerator_get_default_mod_mask (void)
guint
gtk_accelerator_get_default_mod_mask ()

## void _gtk_accel_group_detach (GtkAccelGroup *accel_group, GObject *object)
#void
#_gtk_accel_group_detach (accel_group, object)
#	GtkAccelGroup * accel_group
#	GObject       * object

## void _gtk_accel_group_reconnect (GtkAccelGroup *accel_group, GQuark accel_path_quark)
#void
#_gtk_accel_group_reconnect (accel_group, accel_path_quark)
#	GtkAccelGroup *accel_group
#	GQuark accel_path_quark

##GType gtk_accel_group_get_type (void)

##void _gtk_accel_group_attach (GtkAccelGroup *accel_group, GObject *object)
#void
#_gtk_accel_group_attach (accel_group, object)
#	GtkWidget * accel_group
#	GObject   * object

##gboolean gtk_accelerator_valid (guint keyval, GdkModifierType modifiers) G_GNUC_CONST
gboolean
gtk_accelerator_valid (keyval, modifiers)
	guint           keyval
	GdkModifierType modifiers

# internal
##GtkAccelGroupEntry* gtk_accel_group_query (GtkAccelGroup *accel_group, guint accel_key, GdkModifierType accel_mods, guint *n_entries)
#void
#gtk_accel_group_query (accel_group, accel_key, accel_mods)
#	GtkAccelGroup   * accel_group
#	guint             accel_key
#	GdkModifierType   accel_mods
#    PREINIT:
#	gint                 i;
#	gint                 n_entries;
#	GtkAccelGroupEntry * entries;
#   PPCODE:
#	entries = gtk_accel_group_query(accel_group, accel_key,
#			accel_mods, &n_entries);
##	if( !entries )
#		XSRETURN_EMPTY;
#	EXTEND(SP,n_entries);
#	for( i = 0; i < n_entries; i++ )
#		PUSHs(sv_2mortal(newSVGtkAccelGroupEntry(entries[i])));

