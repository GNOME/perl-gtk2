#include "gtk2perl.h"

MODULE = Gtk2::Box	PACKAGE = Gtk2::Box	PREFIX = gtk_box_

void
gtk_box_pack_start (box, child, expand, fill, padding)
	GtkBox *box
	GtkWidget *child
	gboolean expand
	gboolean fill
	guint padding

void
gtk_box_pack_end (box, child, expand, fill, padding)
	GtkBox *box
	GtkWidget *child
	gboolean expand
	gboolean fill
	guint padding

void
gtk_box_pack_start_defaults (box, widget)
	GtkBox *box
	GtkWidget *widget

void
gtk_box_pack_end_defaults (box, widget)
	GtkBox *box
	GtkWidget *widget

void
gtk_box_set_homogeneous (box, homogeneous)
	GtkBox *box
	gboolean homogeneous

gboolean
gtk_box_get_homogeneous (box)
	GtkBox *box

void
gtk_box_set_spacing (box, spacing)
	GtkBox *box
	gint spacing

gint
gtk_box_get_spacing (box)
	GtkBox *box

void
gtk_box_reorder_child (box, child, position)
	GtkBox *box
	GtkWidget *child
	gint position

void
gtk_box_query_child_packing (GtkBox * box, GtkWidget * child, OUTLIST gboolean expand, OUTLIST gboolean fill, OUTLIST guint padding, OUTLIST GtkPackType pack_type)

void
gtk_box_set_child_packing (box, child, expand, fill, padding, pack_type)
	GtkBox *box
	GtkWidget *child
	gboolean expand
	gboolean fill
	guint padding
	GtkPackType pack_type

