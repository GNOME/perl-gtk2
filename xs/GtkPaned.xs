/*
 * $Header$
 */

#include "gtk2perl.h"

MODULE = Gtk2::Paned	PACKAGE = Gtk2::Paned	PREFIX = gtk_paned_

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

