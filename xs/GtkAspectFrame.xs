/*
 * $Header$
 */

#include "gtk2perl.h"

MODULE = Gtk2::AspectFrame	PACKAGE = Gtk2::AspectFrame	PREFIX = gtk_aspectframe_

## GtkWidget* gtk_aspect_frame_new (const gchar *label, gfloat xalign, gfloat yalign, gfloat ratio, gboolean obey_child)
GtkWidget *
gtk_aspect_frame_new (class, label, xalign, yalign, ratio, obey_child)
	SV          * class
	const gchar * label
	gfloat        xalign
	gfloat        yalign
	gfloat        ratio
	gboolean      obey_child
    C_ARGS:
	label, xalign, yalign, ratio, obey_child

## void gtk_aspect_frame_set (GtkAspectFrame *aspect_frame, gfloat xalign, gfloat yalign, gfloat ratio, gboolean obey_child)
void
gtk_aspect_frame_set (aspect_frame, xalign, yalign, ratio, obey_child)
	GtkAspectFrame * aspect_frame
	gfloat           xalign
	gfloat           yalign
	gfloat           ratio
	gboolean         obey_child

