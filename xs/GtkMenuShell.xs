/*
 * $Header$
 */

#include "gtk2perl.h"

MODULE = Gtk2::MenuShell	PACKAGE = Gtk2::MenuShell	PREFIX = gtk_menu_shell_

## void gtk_menu_shell_append (GtkMenuShell *menu_shell, GtkWidget *child)
void
gtk_menu_shell_append (menu_shell, child)
	GtkMenuShell * menu_shell
	GtkWidget    * child

## void gtk_menu_shell_prepend (GtkMenuShell *menu_shell, GtkWidget *child)
void
gtk_menu_shell_prepend (menu_shell, child)
	GtkMenuShell * menu_shell
	GtkWidget    * child

## void gtk_menu_shell_insert (GtkMenuShell *menu_shell, GtkWidget *child, gint position)
void
gtk_menu_shell_insert (menu_shell, child, position)
	GtkMenuShell * menu_shell
	GtkWidget    * child
	gint           position

## void gtk_menu_shell_deactivate (GtkMenuShell *menu_shell)
void
gtk_menu_shell_deactivate (menu_shell)
	GtkMenuShell * menu_shell

## void gtk_menu_shell_select_item (GtkMenuShell *menu_shell, GtkWidget *menu_item)
void
gtk_menu_shell_select_item (menu_shell, menu_item)
	GtkMenuShell * menu_shell
	GtkWidget    * menu_item

## void gtk_menu_shell_deselect (GtkMenuShell *menu_shell)
void
gtk_menu_shell_deselect (menu_shell)
	GtkMenuShell * menu_shell

## void gtk_menu_shell_activate_item (GtkMenuShell *menu_shell, GtkWidget *menu_item, gboolean force_deactivate)
void
gtk_menu_shell_activate_item (menu_shell, menu_item, force_deactivate)
	GtkMenuShell * menu_shell
	GtkWidget    * menu_item
	gboolean       force_deactivate

## void _gtk_menu_shell_select_first (GtkMenuShell *menu_shell, gboolean search_sensitive)
#void
#_gtk_menu_shell_select_first (menu_shell, search_sensitive)
#	GtkMenuShell * menu_shell
#	gboolean       search_sensitive

## void _gtk_menu_shell_activate (GtkMenuShell *menu_shell)
#void
#_gtk_menu_shell_activate (menu_shell)
#	GtkMenuShell * menu_shell

