/*
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

