/*
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
 # inherits that from G::Object!

void
gtk_object_destroy (object)
	GtkObject * object


 ## the rest of the stuff from gtkobject.h is either private, or
 ## deprecated in favor of corresponding GObject methods.
