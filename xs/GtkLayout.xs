/*
 * $Header$
 */

#include "gtk2perl.h"

MODULE = Gtk2::Layout	PACKAGE = Gtk2::Layout	PREFIX = gtk_layout_

## GtkWidget* gtk_layout_new (GtkAdjustment *hadjustment, GtkAdjustment *vadjustment)
GtkWidget *
gtk_layout_new (class, hadjustment, vadjustment)
	SV                   * class
	GtkAdjustment_ornull * hadjustment
	GtkAdjustment_ornull * vadjustment
    C_ARGS:
	hadjustment, vadjustment

## void gtk_layout_put (GtkLayout *layout, GtkWidget *child_widget, gint x, gint y)
void
gtk_layout_put (layout, child_widget, x, y)
	GtkLayout * layout
	GtkWidget * child_widget
	gint        x
	gint        y

## void gtk_layout_move (GtkLayout *layout, GtkWidget *child_widget, gint x, gint y)
void
gtk_layout_move (layout, child_widget, x, y)
	GtkLayout * layout
	GtkWidget * child_widget
	gint        x
	gint        y


## void gtk_layout_set_size (GtkLayout *layout, guint width, guint height)
void
gtk_layout_set_size (layout, width, height)
	GtkLayout * layout
	guint       width
	guint       height

## void gtk_layout_get_size (GtkLayout *layout, guint *width, guint *height)
void
gtk_layout_get_size (GtkLayout * layout, OUTLIST guint width, OUTLIST guint height)

## GtkAdjustment* gtk_layout_get_hadjustment (GtkLayout *layout)
GtkAdjustment *
gtk_layout_get_hadjustment (layout)
	GtkLayout * layout

## GtkAdjustment* gtk_layout_get_vadjustment (GtkLayout *layout)
GtkAdjustment *
gtk_layout_get_vadjustment (layout)
	GtkLayout * layout

## void gtk_layout_set_hadjustment (GtkLayout *layout, GtkAdjustment *adjustment)
void
gtk_layout_set_hadjustment (layout, adjustment)
	GtkLayout     * layout
	GtkAdjustment * adjustment

## void gtk_layout_set_vadjustment (GtkLayout *layout, GtkAdjustment *adjustment)
void
gtk_layout_set_vadjustment (layout, adjustment)
	GtkLayout     * layout
	GtkAdjustment * adjustment

## void gtk_layout_thaw (GtkLayout *layout)
void
gtk_layout_thaw (layout)
	GtkLayout * layout

##void gtk_layout_freeze (GtkLayout *layout)
void
gtk_layout_freeze (layout)
	GtkLayout * layout

