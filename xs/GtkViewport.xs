/*
 * $Header$
 */

#include "gtk2perl.h"

MODULE = Gtk2::Viewport	PACKAGE = Gtk2::Viewport	PREFIX = gtk_viewport_

## GtkWidget* gtk_viewport_new (GtkAdjustment *hadjustment, GtkAdjustment *vadjustment)
GtkWidget *
gtk_viewport_new (class, hadjustment=NULL, vadjustment=NULL)
	SV            * class
	GtkAdjustment_ornull * hadjustment
	GtkAdjustment_ornull * vadjustment
    C_ARGS:
	hadjustment, vadjustment

## GtkAdjustment* gtk_viewport_get_hadjustment (GtkViewport *viewport)
GtkAdjustment *
gtk_viewport_get_hadjustment (viewport)
	GtkViewport * viewport

## GtkAdjustment* gtk_viewport_get_vadjustment (GtkViewport *viewport)
GtkAdjustment *
gtk_viewport_get_vadjustment (viewport)
	GtkViewport * viewport

## void gtk_viewport_set_hadjustment (GtkViewport *viewport, GtkAdjustment *adjustment)
void
gtk_viewport_set_hadjustment (viewport, adjustment)
	GtkViewport   * viewport
	GtkAdjustment * adjustment

## void gtk_viewport_set_vadjustment (GtkViewport *viewport, GtkAdjustment *adjustment)
void
gtk_viewport_set_vadjustment (viewport, adjustment)
	GtkViewport   * viewport
	GtkAdjustment * adjustment

## void gtk_viewport_set_shadow_type (GtkViewport *viewport, GtkShadowType type)
void
gtk_viewport_set_shadow_type (viewport, type)
	GtkViewport   * viewport
	GtkShadowType   type

## GtkShadowType gtk_viewport_get_shadow_type (GtkViewport *viewport)
GtkShadowType
gtk_viewport_get_shadow_type (viewport)
	GtkViewport * viewport

