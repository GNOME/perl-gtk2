#include "gtk2perl.h"

MODULE = Gtk2::FileChooserDialog PACKAGE = Gtk2::FileChooserDialog PREFIX = gtk_file_chooser_dialog_

BOOT:
	/* GtkFileChooserDialog implements the GtkFileChooserIface */
	gperl_prepend_isa ("Gtk2::FileChooserDialog", "Gtk2::FileChooser");

GtkWidget *
gtk_file_chooser_dialog_new (class, gchar *title, GtkWindow_ornull *parent, GtkFileChooserAction action, first_button_text, ...);
    PREINIT:
	gint i;
    CODE:
	if (0 != (items - 4) % 2)
		croak ("usage: Gtk2::FileChooserDialog->new (parent, action, button_text => response-id, ...)\n"
		       "   expecting list of button-text => response-id pairs");
	RETVAL = g_object_new (GTK_TYPE_FILE_CHOOSER_DIALOG,
	                       "title", title,
	                       "action", action,
	                       NULL);
	if (parent)
		gtk_window_set_transient_for (GTK_WINDOW (RETVAL), parent);
	for (i = 4 ; i < items ; i+=2) {
		gchar * button_text = SvGChar (ST (i));
		gint response_id = SvGtkResponseType (ST (i+1));
		gtk_dialog_add_button (GTK_DIALOG (RETVAL), button_text, response_id);
	}
    OUTPUT:
	RETVAL

