/*
 * Copyright (c) 2003 by the gtk2-perl team (see the file AUTHORS)
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

static SV *
response_id_to_sv (gint response)
{
	return gperl_convert_back_enum_pass_unknown (GTK_TYPE_RESPONSE_TYPE,
	                                             response);
}

/*
GtkDialog's response event is defined in Gtk as having a signal parameter
of type G_TYPE_INT, but GtkResponseType values are passed through it.

this custom marshaller allows us to catch and convert enum codes like those
returned by $dialog->run , instead of requiring the callback to deal with
the raw negative numeric values for the predefined constants.
*/
static void
gtk2perl_dialog_response_marshal (GClosure * closure,
                                  GValue * return_value,
                                  guint n_param_values,
                                  const GValue * param_values,
                                  gpointer invocation_hint,
                                  gpointer marshal_data)
{
	GPerlClosure *pc = (GPerlClosure *)closure;
	SV * data;
	SV * instance;
	dSP;
#ifdef PERL_IMPLICIT_CONTEXT
	/* make sure we're executed by the same interpreter that created
	 * the closure object. */
	PERL_SET_CONTEXT (marshal_data);
	SPAGAIN;
#endif

	PERL_UNUSED_VAR (return_value);
	PERL_UNUSED_VAR (n_param_values);
	PERL_UNUSED_VAR (invocation_hint);

	ENTER;
	SAVETMPS;

	PUSHMARK (SP);

	if (GPERL_CLOSURE_SWAP_DATA (pc)) {
		/* swap instance and data */
		data     = gperl_sv_from_value (param_values);
		instance = SvREFCNT_inc (pc->data);
	} else {
		/* normal */
		instance = gperl_sv_from_value (param_values);
		data     = SvREFCNT_inc (pc->data);
	}

	EXTEND (SP, 2);
	/* the instance is always the first item in @_ */
	PUSHs (sv_2mortal (instance));

	/* the second parameter for this signal is defined as an int
	 * but is actually a response code, and can have GtkResponseType
	 * values. */
	PUSHs (sv_2mortal (response_id_to_sv
				(g_value_get_int (param_values + 1))));

	if (data)
		XPUSHs (sv_2mortal (data));
	PUTBACK;

	call_sv (pc->callback, G_DISCARD | G_EVAL);

	if (SvTRUE (ERRSV))
		gperl_run_exception_handlers ();

	/*
	 * clean up 
	 */

	FREETMPS;
	LEAVE;
}

MODULE = Gtk2::Dialog	PACKAGE = Gtk2::Dialog	PREFIX = gtk_dialog_

BOOT:
	gperl_signal_set_marshaller_for (GTK_TYPE_DIALOG, "response",
	                                 gtk2perl_dialog_response_marshal);

GtkWidget *
gtk_dialog_widgets (dialog)
	GtkDialog * dialog
    ALIAS:
	Gtk2::Dialog::vbox = 0
	Gtk2::Dialog::action_area = 1
    CODE:
	RETVAL = NULL;
	switch(ix)
	{
	case(0): RETVAL = dialog->vbox; 	break;
	case(1): RETVAL = dialog->action_area;	break;
	}
    OUTPUT:
	RETVAL

##GtkWidget *
##gtk_dialog_new (class)
##
##GtkWidget* gtk_dialog_new_with_buttons (const gchar     *title,
##                                        GtkWindow       *parent,
##                                        GtkDialogFlags   flags,
##                                        const gchar     *first_button_text,
##                                        ...);
GtkWidget *
gtk_dialog_new (class, ...)
    ALIAS:
	Gtk2::Dialog::new = 0
	Gtk2::Dialog::new_with_buttons = 1
    PREINIT:
	int i;
	gchar * title;
	GtkWidget * dialog;
	GtkWindow * parent;
	int flags;
    CODE:
	PERL_UNUSED_VAR (ix);
	if (items == 1) {
		/* the easy way out... */
		dialog = gtk_dialog_new ();

	} else if ((items < 4) || (items % 2)) {
		croak ("USAGE: Gtk2::Dialog->new ()\n"
		       "  or Gtk2::Dialog->new (TITLE, PARENT, FLAGS, ...)\n"
		       "  where ... is a series of button text and response id pairs");
	} else {
		title = SvGChar (ST (1));
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
			gchar * text = SvGChar (ST (i));
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
		gtk_dialog_add_button(dialog, SvGChar(ST(i)), 
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
	SV        * response_id
    C_ARGS:
	dialog, sv_to_response_id (response_id)


 ## Returns response_id

SV *
gtk_dialog_run (dialog)
	GtkDialog * dialog
    CODE:
	RETVAL = response_id_to_sv (gtk_dialog_run (dialog));
    OUTPUT:
	RETVAL
