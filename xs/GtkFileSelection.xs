#include "gtk2perl.h"

MODULE = Gtk2::FileSelection	PACKAGE = Gtk2::FileSelection	PREFIX = gtk_file_selection_

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

