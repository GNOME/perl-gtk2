/*
 * $Header$
 */

#include "gtk2perl.h"

/*
 * GtkDialog interprets the response id as completely user-defined for
 * positive values, and as special enums for negative values.  so, we
 * will handle the response_id as a plain SV so we can implement this
 * special behavior.
 */

static gint
sv_to_response_id (SV * sv)
{
	int n;
	if (looks_like_number (sv))
		return SvIV (sv);
	if (!gperl_try_convert_enum (GTK_TYPE_RESPONSE_TYPE, sv, &n))
		croak ("response_id should be either a GtkResponseType or an integer");
	return n;
}

MODULE = Gtk2::Dialog	PACKAGE = Gtk2::Dialog	PREFIX = gtk_dialog_


GtkWidget *
gtk_dialog_widgets (dialog)
	GtkDialog * dialog
    ALIAS:
	Gtk2::Dialog::vbox = 0
	Gtk2::Dialog::action_area = 1
    CODE:
	switch(ix)
	{
	case(0): RETVAL = dialog->vbox; 	break;
	case(1): RETVAL = dialog->action_area;	break;
	}
    OUTPUT:
	RETVAL

##GtkWidget *
##gtk_dialog_new (class)
##	SV * class
##
##GtkWidget* gtk_dialog_new_with_buttons (const gchar     *title,
##                                        GtkWindow       *parent,
##                                        GtkDialogFlags   flags,
##                                        const gchar     *first_button_text,
##                                        ...);
GtkWidget *
gtk_dialog_new (class, ...)
	SV * class
    PREINIT:
	int i;
	char * title;
	GtkWidget * dialog;
	GtkWindow * parent;
	int flags;
    CODE:
	if (items == 1) {
		/* the easy way out... */
		dialog = gtk_dialog_new ();

	} else if ((items < 4) || (items % 2)) {
		croak ("USAGE: Gtk2::Dialog->new ()\n"
		       "  or Gtk2::Dialog->new (TITLE, PARENT, FLAGS, ...)\n"
		       "  where ... is a series of button text and response id pairs");
	} else {
		title = SvPV_nolen (ST (1));
		parent = SvGtkWindow_ornull (ST (2));
		flags = SvGtkDialogFlags (ST (3));

		/* we can't really pass on a varargs call (at least, i don't
		 * know how to convert from perl stack to C va_list), so we
		 * have to duplicate a bit of the functionality of the C
		 * version.  luckily it's nothing too intense. */

		dialog = gtk_dialog_new ();
		if (title)
			gtk_window_set_title (GTK_WINDOW (dialog), title);
		if (parent)
			gtk_window_set_transient_for (GTK_WINDOW (dialog), parent);
		if (flags & GTK_DIALOG_MODAL)
			gtk_window_set_modal (GTK_WINDOW (dialog), TRUE);
		if (flags & GTK_DIALOG_DESTROY_WITH_PARENT)
			gtk_window_set_destroy_with_parent (GTK_WINDOW (dialog), TRUE);
		if (flags & GTK_DIALOG_NO_SEPARATOR)
			gtk_dialog_set_has_separator (GTK_DIALOG (dialog), FALSE);

		/* skip the first 4 stack items --- we've already seen them! */
		for (i = 4; i < items; i += 2) {
			gchar * text = SvPV_nolen (ST (i));
			int response_id = sv_to_response_id (ST (i+1));
			gtk_dialog_add_button (GTK_DIALOG (dialog), text,
			                       response_id);
		}
	}
	RETVAL = dialog;
    OUTPUT:
	RETVAL

void
gtk_dialog_add_action_widget (dialog, child, response_id)
	GtkDialog   * dialog
	GtkWidget   * child
	SV          * response_id
    PREINIT:
    CODE:
	gtk_dialog_add_action_widget (dialog, child,
	                              sv_to_response_id (response_id));

GtkWidget *
gtk_dialog_add_button (dialog, button_text, response_id)
	GtkDialog   * dialog
	const gchar * button_text
	SV          * response_id
    CODE:
	RETVAL = gtk_dialog_add_button (dialog, button_text,
	                                sv_to_response_id (response_id));
    OUTPUT:
	RETVAL

void 
gtk_dialog_add_buttons (dialog, ...)
	GtkDialog * dialog
    PREINIT:
	int i;
    CODE:
	if( !(items % 2) )
		croak("gtk_dialog_add_buttons: odd number of parameters");
	/* we can't make var args, so we'll call add_button for each */
	for( i = 1; i < items; i += 2 )
		gtk_dialog_add_button(dialog, SvPV_nolen(ST(i)), 
			sv_to_response_id(ST(i+1)));

void
gtk_dialog_set_response_sensitive (dialog, response_id, setting)
	GtkDialog * dialog
	SV        * response_id
	gboolean    setting
    CODE:
	gtk_dialog_set_response_sensitive (dialog,
	                                   sv_to_response_id (response_id),
	                                   setting);

void
gtk_dialog_set_default_response (dialog, response_id)
	GtkDialog * dialog
	SV        * response_id
    CODE:
	gtk_dialog_set_default_response (dialog,
	                                 sv_to_response_id (response_id));

void
gtk_dialog_set_has_separator (dialog, setting)
	GtkDialog * dialog
	gboolean   setting

gboolean
gtk_dialog_get_has_separator (dialog)
	GtkDialog * dialog

 ## /* Emit response signal */

void
gtk_dialog_response (dialog, response_id)
	GtkDialog * dialog
	gint        response_id


 ## Returns response_id

SV *
gtk_dialog_run (dialog)
	GtkDialog * dialog
    PREINIT:
	gint ret;
    CODE:
	ret = gtk_dialog_run (dialog);
	RETVAL = gperl_convert_back_enum_pass_unknown
					(GTK_TYPE_RESPONSE_TYPE, ret);
    OUTPUT:
	RETVAL
