#include "gtk2perl.h"

MODULE = Gtk2::SizeGroup	PACKAGE = Gtk2::SizeGroup	PREFIX = gtk_size_group_

##  GtkSizeGroup * gtk_size_group_new (GtkSizeGroupMode mode) 
GtkSizeGroup_noinc *
gtk_size_group_new (class, mode)
	SV * class
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

##  void _gtk_size_group_get_child_requisition (GtkWidget *widget, GtkRequisition *requisition) 
##  void _gtk_size_group_compute_requisition (GtkWidget *widget, GtkRequisition *requisition) 
##  void _gtk_size_group_queue_resize (GtkWidget *widget) 

