/*
 * Copyright (c) 2003-2005 by the gtk2-perl team (see the file AUTHORS)
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Library General Public
 * License as published by the Free Software Foundation; either
 * version 2.1 of the License, or (at your option) any later version.
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

MODULE = Gtk2::SizeGroup	PACKAGE = Gtk2::SizeGroup	PREFIX = gtk_size_group_

=for enum GtkSizeGroupMode
=cut

##  GtkSizeGroup * gtk_size_group_new (GtkSizeGroupMode mode) 
GtkSizeGroup_noinc *
gtk_size_group_new (class, mode)
	GtkSizeGroupMode mode
    C_ARGS:
	mode

##  void gtk_size_group_set_mode (GtkSizeGroup *size_group, GtkSizeGroupMode mode) 
void
gtk_size_group_set_mode (size_group, mode)
	GtkSizeGroup *size_group
	GtkSizeGroupMode mode

##  GtkSizeGroupMode gtk_size_group_get_mode (GtkSizeGroup *size_group) 
GtkSizeGroupMode
gtk_size_group_get_mode (size_group)
	GtkSizeGroup *size_group

##  void gtk_size_group_add_widget (GtkSizeGroup *size_group, GtkWidget *widget) 
void
gtk_size_group_add_widget (size_group, widget)
	GtkSizeGroup *size_group
	GtkWidget *widget

##  void gtk_size_group_remove_widget (GtkSizeGroup *size_group, GtkWidget *widget) 
void
gtk_size_group_remove_widget (size_group, widget)
	GtkSizeGroup *size_group
	GtkWidget *widget

#if GTK_CHECK_VERSION (2, 7, 0) /* FIXME: 2.8 */

void gtk_size_group_set_ignore_hidden (GtkSizeGroup *size_group, gboolean ignore_hidden);

gboolean gtk_size_group_get_ignore_hidden (GtkSizeGroup *size_group);

#endif

##  void _gtk_size_group_get_child_requisition (GtkWidget *widget, GtkRequisition *requisition) 
##  void _gtk_size_group_compute_requisition (GtkWidget *widget, GtkRequisition *requisition) 
##  void _gtk_size_group_queue_resize (GtkWidget *widget) 

