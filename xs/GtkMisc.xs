/*
 * $Header$
 */

#include "gtk2perl.h"

MODULE = Gtk2::Misc	PACKAGE = Gtk2::Misc	PREFIX = gtk_misc_

void
gtk_misc_set_alignment (misc, xalign, yalign)
	GtkMisc * misc
	gfloat	  xalign
	gfloat	  yalign

void
gtk_misc_get_alignment (GtkMisc * misc, OUTLIST gfloat xalign, OUTLIST gfloat yalign)

void
gtk_misc_set_padding (misc, xpad, ypad)
	GtkMisc * misc
	gint	  xpad
	gint	  ypad

void
gtk_misc_get_padding (GtkMisc * misc, OUTLIST gint xpad, OUTLIST gint ypad)

