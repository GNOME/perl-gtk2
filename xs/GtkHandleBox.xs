#include "gtk2perl.h"

MODULE = Gtk2::HandleBox	PACKAGE = Gtk2::HandleBox	PREFIX = gtk_handle_box_

## GtkWidget* gtk_handle_box_new (void)
GtkWidget *
gtk_handle_box_new (class)
	SV * class
    C_ARGS:

## void gtk_handle_box_set_shadow_type (GtkHandleBox *handle_box, GtkShadowType type)
void
gtk_handle_box_set_shadow_type (handle_box, type)
	GtkHandleBox * handle_box
	GtkShadowType  type

## GtkShadowType gtk_handle_box_get_shadow_type (GtkHandleBox *handle_box)
GtkShadowType
gtk_handle_box_get_shadow_type (handle_box)
	GtkHandleBox * handle_box

## void gtk_handle_box_set_handle_position (GtkHandleBox *handle_box, GtkPositionType position)
void
gtk_handle_box_set_handle_position (handle_box, position)
	GtkHandleBox    * handle_box
	GtkPositionType   position

## GtkPositionType gtk_handle_box_get_handle_position(GtkHandleBox *handle_box)
GtkPositionType
gtk_handle_box_get_handle_position (handle_box)
	GtkHandleBox * handle_box

## void gtk_handle_box_set_snap_edge (GtkHandleBox *handle_box, GtkPositionType edge)
void
gtk_handle_box_set_snap_edge (handle_box, edge)
	GtkHandleBox    * handle_box
	GtkPositionType   edge

## GtkPositionType gtk_handle_box_get_snap_edge (GtkHandleBox *handle_box)
GtkPositionType
gtk_handle_box_get_snap_edge (handle_box)
	GtkHandleBox * handle_box

