/*
 * Copyright (c) 2003 by the gtk2-perl team (see the file AUTHORS)
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Library General Public
 * License as published by the Free Software Foundation; either
 * version 2 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Library General Public License for more details.
 *
 * You should have received a copy of the GNU Library General Public
 * License along with this library; if not, write to the 
 * Free Software Foundation, Inc., 59 Temple Place - Suite 330, 
 * Boston, MA  02111-1307  USA.
 *
 * $Header$
 */

#include "gtk2perl.h"

MODULE = Gtk2::Paned	PACKAGE = Gtk2::Paned	PREFIX = gtk_paned_

SV *
member (GtkPaned * paned)
    ALIAS:
	Gtk2::Paned::child1 = 1
	Gtk2::Paned::child1_resize = 2
	Gtk2::Paned::child1_shrink = 3
	Gtk2::Paned::child2 = 4
	Gtk2::Paned::child2_resize = 5
	Gtk2::Paned::child2_shrink = 6
    CODE:
	RETVAL = NULL;
	switch (ix) {
		case 1: RETVAL = newSVGtkWidget (paned->child1); break;
		case 2: RETVAL = newSViv (paned->child1_resize); break;
		case 3: RETVAL = newSViv (paned->child1_shrink); break;
		case 4: RETVAL = newSVGtkWidget (paned->child2); break;
		case 5: RETVAL = newSViv (paned->child2_resize); break;
		case 6: RETVAL = newSViv (paned->child2_shrink); break;
	}
    OUTPUT:
	RETVAL

## void gtk_paned_add1 (GtkPaned *paned, GtkWidget *child)
void
gtk_paned_add1 (paned, child)
	GtkPaned  * paned
	GtkWidget * child

## void gtk_paned_add2 (GtkPaned *paned, GtkWidget *child)
void
gtk_paned_add2 (paned, child)
	GtkPaned  * paned
	GtkWidget * child

## void gtk_paned_pack1 (GtkPaned *paned, GtkWidget *child, gboolean resize, gboolean shrink)
void
gtk_paned_pack1 (paned, child, resize, shrink)
	GtkPaned  * paned
	GtkWidget * child
	gboolean    resize
	gboolean    shrink

## void gtk_paned_pack2 (GtkPaned *paned, GtkWidget *child, gboolean resize, gboolean shrink)
void
gtk_paned_pack2 (paned, child, resize, shrink)
	GtkPaned  * paned
	GtkWidget * child
	gboolean    resize
	gboolean    shrink

## gint gtk_paned_get_position (GtkPaned *paned)
gint
gtk_paned_get_position (paned)
	GtkPaned * paned

## void gtk_paned_set_position (GtkPaned *paned, gint position)
void
gtk_paned_set_position (paned, position)
	GtkPaned * paned
	gint       position

##void gtk_paned_compute_position (GtkPaned *paned, gint allocation, gint child1_req, gint child2_req)
void
gtk_paned_compute_position (paned, allocation, child1_req, child2_req)
	GtkPaned * paned
	gint       allocation
	gint       child1_req
	gint       child2_req

