#include "gtk2perl.h"

MODULE = Gtk2::Alignment	PACKAGE = Gtk2::Alignment	PREFIX = gtk_alignment_

## GtkWidget* gtk_alignment_new (gfloat xalign, gfloat yalign, gfloat xscale, gfloat yscale)
GtkWidget *
gtk_alignment_new (class, xalign, yalign, xscale, yscale)
	SV * class
	gfloat xalign
	gfloat yalign
	gfloat xscale
	gfloat yscale
    C_ARGS:
	xalign, yalign, xscale, yscale

## void gtk_alignment_set (GtkAlignment *alignment, gfloat xalign, gfloat yalign, gfloat xscale, gfloat yscale)
void
gtk_alignment_set (alignment, xalign, yalign, xscale, yscale)
	GtkAlignment * alignment
	gfloat         xalign
	gfloat         yalign
	gfloat         xscale
	gfloat         yscale

