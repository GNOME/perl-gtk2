#include "gtk2perl.h"

MODULE = Gtk2::AccelLabel	PACKAGE = Gtk2::AccelLabel	PREFIX = gtk_accel_label_

## GtkWidget* gtk_accel_label_new (const gchar *string)
GtkWidget *
gtk_accel_label_new (class, string)
	SV          * class
	const gchar * string
    C_ARGS:
	string

## GtkWidget* gtk_accel_label_get_accel_widget (GtkAccelLabel *accel_label)
GtkWidget *
gtk_accel_label_get_accel_widget (accel_label)
	GtkAccelLabel * accel_label

## guint gtk_accel_label_get_accel_width (GtkAccelLabel *accel_label)
guint
gtk_accel_label_get_accel_width (accel_label)
	GtkAccelLabel * accel_label

## void gtk_accel_label_set_accel_widget (GtkAccelLabel *accel_label, GtkWidget *accel_widget)
void
gtk_accel_label_set_accel_widget (accel_label, accel_widget)
	GtkAccelLabel * accel_label
	GtkWidget     * accel_widget

# TODO: GClosure * not in typmap
## void gtk_accel_label_set_accel_closure (GtkAccelLabel *accel_label, GClosure *accel_closure)
#void
#gtk_accel_label_set_accel_closure (accel_label, accel_closure)
#	GtkAccelLabel * accel_label
#	GClosure      * accel_closure

## gboolean gtk_accel_label_refetch (GtkAccelLabel *accel_label)
gboolean
gtk_accel_label_refetch (accel_label)
	GtkAccelLabel * accel_label

