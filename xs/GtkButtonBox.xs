#include "gtk2perl.h"

MODULE = Gtk2::ButtonBox	PACKAGE = Gtk2::ButtonBox	PREFIX = gtk_button_box_

## GtkButtonBoxStyle gtk_button_box_get_layout (GtkButtonBox *widget)
GtkButtonBoxStyle
gtk_button_box_get_layout (widget)
	GtkButtonBox * widget

## void gtk_button_box_set_layout (GtkButtonBox *widget, GtkButtonBoxStyle layout_style)
void
gtk_button_box_set_layout (widget, layout_style)
	GtkButtonBox      * widget
	GtkButtonBoxStyle   layout_style

## void gtk_button_box_set_child_secondary (GtkButtonBox *widget, GtkWidget *child, gboolean is_secondary)
void
gtk_button_box_set_child_secondary (widget, child, is_secondary)
	GtkButtonBox * widget
	GtkWidget    * child
	gboolean       is_secondary

##void _gtk_button_box_child_requisition (GtkWidget *widget, int *nvis_children, int *nvis_secondaries, int *width, int *height)
#void
#_gtk_button_box_child_requisition (widget, nvis_childer, nvis_secondaries, width, height)
#	GtkWidget * widget
#	int         nvis_childer
#	int         nvis_secondaries
#	int         width
#	int         height
