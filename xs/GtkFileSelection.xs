/*
 * $Header$
 */

#include "gtk2perl.h"

MODULE = Gtk2::FileSelection	PACKAGE = Gtk2::FileSelection	PREFIX = gtk_file_selection_


GtkWidget *
member_widget (fs)
	GtkFileSelection* fs
    ALIAS:
	Gtk2::FileSelection::ok_button       = 0
	Gtk2::FileSelection::cancel_button   = 1
	Gtk2::FileSelection::dir_list        = 2
	Gtk2::FileSelection::file_list       = 3
	Gtk2::FileSelection::selection_entry = 4
	Gtk2::FileSelection::selection_text  = 5
	Gtk2::FileSelection::main_vbox       = 6
	Gtk2::FileSelection::help_button     = 7
    CODE:
	switch (ix) {
		case 0: RETVAL = fs->ok_button;       break;
		case 1: RETVAL = fs->cancel_button;   break;
		case 2: RETVAL = fs->dir_list;        break;
		case 3: RETVAL = fs->file_list;       break;
		case 4: RETVAL = fs->selection_entry; break;
		case 5: RETVAL = fs->selection_text;  break;
		case 6: RETVAL = fs->main_vbox;       break;
		case 7: RETVAL = fs->help_button;     break;
	}
    OUTPUT:
	RETVAL

## GtkWidget* gtk_file_selection_new (const gchar *title)
GtkWidget *
gtk_file_selection_new (class, title)
	SV          * class
	const gchar * title
    C_ARGS:
	title

## void gtk_file_selection_set_filename (GtkFileSelection *filesel, const gchar *filename)
void
gtk_file_selection_set_filename (filesel, filename)
	GtkFileSelection * filesel
	const gchar      * filename

## void gtk_file_selection_complete (GtkFileSelection *filesel, const gchar *pattern)
void
gtk_file_selection_complete (filesel, pattern)
	GtkFileSelection * filesel
	const gchar      * pattern

## void gtk_file_selection_show_fileop_buttons (GtkFileSelection *filesel)
void
gtk_file_selection_show_fileop_buttons (filesel)
	GtkFileSelection * filesel

## void gtk_file_selection_hide_fileop_buttons (GtkFileSelection *filesel)
void
gtk_file_selection_hide_fileop_buttons (filesel)
	GtkFileSelection * filesel

## void gtk_file_selection_set_select_multiple (GtkFileSelection *filesel, gboolean select_multiple)
void
gtk_file_selection_set_select_multiple (filesel, select_multiple)
	GtkFileSelection * filesel
	gboolean           select_multiple

## gboolean gtk_file_selection_get_select_multiple (GtkFileSelection *filesel)
gboolean
gtk_file_selection_get_select_multiple (filesel)
	GtkFileSelection * filesel

# G_CONST_RETURN
const gchar *
gtk_file_selection_get_filename (filesel)
	GtkFileSelection * filesel

# TODO: needs custom xs
#gchar **
#gtk_file_selection_get_selections
#	GtkFileSelction * filesel

