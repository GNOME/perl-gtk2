/*
 * $Header$
 */

#include "gtk2perl.h"

MODULE = Gtk2::Frame	PACKAGE = Gtk2::Frame	PREFIX = gtk_frame_

GtkWidget*
gtk_frame_new (class, label=NULL)
	SV * class
	const gchar *label
    C_ARGS:
	label

void
gtk_frame_set_label (frame, label)
	GtkFrame *frame
	SV * label
    CODE:
	/* label may be undef */
	gtk_frame_set_label (frame, ((!label || label == &PL_sv_undef)
	                             ? NULL : SvPV_nolen (label)));

void
gtk_frame_set_label_widget (frame, label_widget)
	GtkFrame *frame
	GtkWidget *label_widget

GtkWidget *
gtk_frame_get_label_widget (frame)
	GtkFrame * frame

void
gtk_frame_set_label_align (frame, xalign, yalign)
	GtkFrame *frame
	gfloat xalign
	gfloat yalign

# G_CONST_RETURN
const gchar *
gtk_frame_get_label (frame)
	GtkFrame * frame

void
gtk_frame_get_label_align (GtkFrame * frame, OUTLIST gfloat xalign, OUTLIST gfloat yalign)

void
gtk_frame_set_shadow_type (frame, type)
	GtkFrame *frame
	GtkShadowType type

GtkShadowType
gtk_frame_get_shadow_type (frame)
	GtkFrame *frame

