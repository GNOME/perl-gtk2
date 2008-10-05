/*
 * Copyright (c) 2003 by the gtk2-perl team (see the file AUTHORS)
 *
 * Licensed under the LGPL, see LICENSE file for more information.
 *
 * $Id$
 */

#include "gtk2perl.h"

MODULE = Gtk2::Gdk::Device	PACKAGE = Gtk2::Gdk	PREFIX = gdk_

#ifndef GDK_MULTIHEAD_SAFE
 
=for apidoc

Returns a list of I<GdkDevice>s.

=cut
## GList * gdk_devices_list (void)
void
gdk_devices_list (class)
    PREINIT:
	GList *i, *list = NULL;
    PPCODE:
	PERL_UNUSED_VAR (ax);
	list = gdk_devices_list ();
	for (i = list; i != NULL; i = i->next)
		XPUSHs (sv_2mortal (newSVGdkDevice (i->data)));

#endif /* ! GDK_MULTIHEAD_SAFE */

MODULE = Gtk2::Gdk::Device	PACKAGE = Gtk2::Gdk::Device	PREFIX = gdk_device_

gchar *
name (device)
	GdkDevice *device
    CODE:
	RETVAL = device->name;
    OUTPUT:
	RETVAL

GdkInputSource
source (device)
	GdkDevice *device
    CODE:
	RETVAL = device->source;
    OUTPUT:
	RETVAL

GdkInputMode
mode (device)
	GdkDevice *device
    CODE:
	RETVAL = device->mode;
    OUTPUT:
	RETVAL

gboolean
has_cursor (device)
	GdkDevice *device
    CODE:
	RETVAL = device->has_cursor;
    OUTPUT:
	RETVAL

=for apidoc

Returns a list of hash references that resemble the I<GdkDeviceAxis> structure,
i.e. that have three keys: "use", "min", and "max".

=cut
void
axes (device)
	GdkDevice *device
    PREINIT:
	int i;
    PPCODE:
	EXTEND (sp, device->num_axes);

	for (i = 0; i < device->num_axes; i++) {
		HV *axis = newHV ();

		hv_store (axis, "use", 3, newSVGdkAxisUse (device->axes[i].use), 0);
		hv_store (axis, "min", 3, newSVnv (device->axes[i].min), 0);
		hv_store (axis, "max", 3, newSVnv (device->axes[i].max), 0);

		PUSHs (sv_2mortal (newRV_noinc ((SV *) axis)));
	}

=for apidoc

Returns a list of hash references that resemble the I<GdkDeviceKey> structure,
i.e. that have two keys: "keyval" and "modifiers".

=cut
void
keys (device)
	GdkDevice *device
    PREINIT:
	int i;
    PPCODE:
	EXTEND (sp, device->num_keys);

	for (i = 0; i < device->num_keys; i++) {
		HV *key = newHV ();

		hv_store (key, "keyval", 6, newSVuv (device->keys[i].keyval), 0);
		hv_store (key, "modifiers", 9, newSVGdkModifierType (device->keys[i].modifiers), 0);

		PUSHs (sv_2mortal (newRV_noinc ((SV *) key)));
	}

## void gdk_device_set_source (GdkDevice *device, GdkInputSource source)
void
gdk_device_set_source (device, source)
	GdkDevice *device
	GdkInputSource source

## gboolean gdk_device_set_mode (GdkDevice *device, GdkInputMode mode)
gboolean
gdk_device_set_mode (device, mode)
	GdkDevice *device
	GdkInputMode mode

## void gdk_device_set_key (GdkDevice *device, guint index_, guint keyval, GdkModifierType modifiers)
void
gdk_device_set_key (device, index_, keyval, modifiers)
	GdkDevice *device
	guint index_
	guint keyval
	GdkModifierType modifiers

## void gdk_device_set_axis_use (GdkDevice *device, guint index_, GdkAxisUse use)
void
gdk_device_set_axis_use (device, index_, use)
	GdkDevice *device
	guint index_
	GdkAxisUse use

=for apidoc

Returns the modifier mask and a list of values of the axes.

=cut
## void gdk_device_get_state (GdkDevice *device, GdkWindow *window, gdouble *axes, GdkModifierType *mask)
void
gdk_device_get_state (device, window)
	GdkDevice *device
	GdkWindow *window
    PREINIT:
	gdouble *axes = NULL;
	GdkModifierType mask;
	int i;
    PPCODE:
	axes = g_new0 (gdouble, device->num_axes);

	gdk_device_get_state (device, window, axes, &mask);

	EXTEND (sp, device->num_axes + 1);

	PUSHs (sv_2mortal (newSVGdkModifierType (mask)));
	for (i = 0; i < device->num_axes; i++)
		PUSHs (sv_2mortal (newSVnv (axes[i])));

	g_free (axes);

=for apidoc

Returns a list of hash references that resemble the I<GdkTimeCoord> structure,
i.e. that have two keys: "time" and "axes".

=cut
## gboolean gdk_device_get_history (GdkDevice *device, GdkWindow *window, guint32 start, guint32 stop, GdkTimeCoord ***events, gint *n_events)
void
gdk_device_get_history (device, window, start, stop)
	GdkDevice *device
	GdkWindow *window
	guint32 start
	guint32 stop
    PREINIT:
	GdkTimeCoord **events = NULL;
	gint i, j, n_events = 0;
    PPCODE:
	if (! gdk_device_get_history (device, window, start, stop, &events, &n_events))
		XSRETURN_EMPTY;

	EXTEND (sp, n_events);

	for (i = 0; i < n_events; i++) {
		HV *event;
		AV *axes;

		axes = newAV ();

		for (j = 0; j < device->num_axes; j++)
			av_store (axes, j, newSVnv (events[i]->axes[j]));

		event = newHV ();

		hv_store (event, "axes", 4, newRV_noinc ((SV *) axes), 0);
		hv_store (event, "time", 4, newSVuv (events[i]->time), 0);

		PUSHs (sv_2mortal (newRV_noinc ((SV *) event)));
	}

	gdk_device_free_history (events, n_events);

=for apidoc

=for arg ... of axis values such as the one returned by L<get_state>

=cut
## gboolean gdk_device_get_axis (GdkDevice *device, gdouble *axes, GdkAxisUse use, gdouble *value)
gdouble
gdk_device_get_axis (device, use, ...)
	GdkDevice *device
	GdkAxisUse use
    PREINIT:
	gdouble *real_axes = NULL;
	gdouble value = 0;
	int i;
    CODE:
#define FIRST 2
	real_axes = g_new0 (double, items - FIRST);

	for (i = FIRST; i < items; i++)
		real_axes[i - FIRST] = SvNV (ST (i));

	if (! gdk_device_get_axis (device, real_axes, use, &value))
		XSRETURN_UNDEF;

	RETVAL = value;

	g_free (real_axes);
#undef FIRST
    OUTPUT:
	RETVAL

#ifndef GDK_MULTIHEAD_SAFE

## GdkDevice *gdk_device_get_core_pointer (void)
GdkDevice *
gdk_device_get_core_pointer (class)
    C_ARGS:
	/* void */

#endif /* ! GDK_MULTIHEAD_SAFE */

MODULE = Gtk2::Gdk::Device	PACKAGE = Gtk2::Gdk::Input	PREFIX = gdk_input_

## void gdk_input_set_extension_events (GdkWindow *window, gint mask, GdkExtensionMode mode)
void
gdk_input_set_extension_events (class, window, mask, mode)
	GdkWindow *window
	GdkEventMask mask
	GdkExtensionMode mode
    C_ARGS:
	window, mask, mode
