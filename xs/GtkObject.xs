/*
 * Copyright (c) 2003 by the gtk2-perl team (see the file AUTHORS)
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Library General Public
 * License as published by the Free Software Foundation; either
 * version 2 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Library General Public License for more details.
 *
 * You should have received a copy of the GNU Library General Public
 * License along with this library; if not, write to the 
 * Free Software Foundation, Inc., 59 Temple Place - Suite 330, 
 * Boston, MA  02111-1307  USA.
 *
 * $Header$
 */

#include "../gtk2perl.h"
#include "../ppport.h"

/*
 * see commentary in gtk2perl.h
 */
SV *
gtk2perl_new_gtkobject (GtkObject * object)
{
	SV * sv;
	/* IMPORTANT: always ref the object! */
	sv = gperl_new_object ((GObject*)object, FALSE);
	if (object) {
		/* see discussion in comment in gtk2perl.h for why
		 * this is the right thing to do. */
		gtk_object_sink (object);
	}
	return sv;
}


MODULE = Gtk2::Object	PACKAGE = Gtk2::Object	PREFIX = gtk_object_

 ## void gtk_object_sink	  (GtkObject *object);
 ## we don't need this to be exported to perl; gtk2perl_new_object
 ## always sinks objects.


 # this is an explicit destroy --- NOT the auto destroy; Gtk2::Object
 # inherits that from Glib::Object!

void
gtk_object_destroy (object)
	GtkObject * object


 ## the rest of the stuff from gtkobject.h is either private, or
 ## deprecated in favor of corresponding GObject methods.

 ## however, we need one more for various purposes...

GtkObject *
new (class, object_class, ...)
	SV * class
	const char * object_class
    PREINIT:
	int n_params = 0;
	GParameter * params = NULL;
	GType object_type;
    CODE:
	object_type = gperl_object_type_from_package (object_class);
	if (!object_type)
		croak ("%s is not registered with gperl as an object type",
		       object_class);
	if (G_TYPE_IS_ABSTRACT (object_type))
		croak ("cannot create instance of abstract (non-instantiatable)"
		       " type `%s'", g_type_name (object_type));
	if (items > 2) {
		int i;
		GObjectClass * class;
		if (NULL == (class = g_type_class_ref (object_type)))
			croak ("could not get a reference to type class");
		n_params = (items - 2) / 2;
		params = g_new0 (GParameter, n_params);
		for (i = 0 ; i < n_params ; i++) {
			const char * key = SvPV_nolen (ST (2+i*2+0));
			GParamSpec * pspec;
			pspec = g_object_class_find_property (class, key);
			if (!pspec) 
				/* FIXME this bails out, but does not clean up 
				 * properly. */
				croak ("type %s does not support property %s, skipping",
				       object_class, key);
			g_value_init (&params[i].value,
			              G_PARAM_SPEC_VALUE_TYPE (pspec));
			if (!gperl_value_from_sv (&params[i].value, 
			                          ST (2+i*2+1)))
				/* FIXME and neither does this */
				croak ("could not convert value for property %s",
				       key);
			params[i].name = key; /* will be valid until this
			                       * xsub is finished */
		}
	}

	RETVAL = g_object_newv (object_type, n_params, params);	

    //cleanup: /* C label, not the XS keyword */
	if (n_params) {
		int i;
		for (i = 0 ; i < n_params ; i++)
			g_value_unset (&params[i].value);
		g_free (params);
	}
	g_type_class_unref (class);

    OUTPUT:
	RETVAL
