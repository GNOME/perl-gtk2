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
GtkEditable's insert-text signal uses an integer pointer as a write-through
parameter; unlike GtkWidget's size-request signal, we can't just pass an
editable object, because an integer is an integral type.

   void user_function  (GtkEditable *editable,
                        gchar *new_text,
                        gint new_text_length,
                        gint *position,  <<=== that's the problem
                        gpointer user_data);

this custom marshaller re-defines the call signature for the signal handler.
this is evil, as the change won't be picked up by the auto-generated docs
and will not comply with the C api reference, but i really can't think of
another way to handle this situation.
*/
static void
gtk2perl_editable_insert_text_marshal (GClosure * closure,
                                       GValue * return_value,
                                       guint n_param_values,
                                       const GValue * param_values,
                                       gpointer invocation_hint,
                                       gpointer marshal_data)
{
	GPerlClosure *pc = (GPerlClosure *)closure;
	SV * data;
	SV * instance;
	int len, count;
	gint * position_p;
	SV * string, * position;
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

	EXTEND (SP, 4);
	/* the instance is always the first item in @_ */
	PUSHs (sv_2mortal (instance));

	/* new_text */
	//PUSHs (sv_2mortal (newSVpv (g_value_get_string (param_values+1), 0)));
	string = newSVpv (g_value_get_string (param_values+1), 0);
	PUSHs (string);

	/* text length is redundant, but documented.  it doesn't hurt
	 * anything to include it, but would be a doc hassle to omit it. */
	PUSHs (sv_2mortal (newSViv (g_value_get_int (param_values+2))));

	/* insert position */
	position_p = g_value_get_pointer (param_values+3);
	position = newSViv (*position_p);
	PUSHs (position);

	if (data)
		XPUSHs (sv_2mortal (data));
	PUTBACK;

	count = call_sv (pc->callback, G_ARRAY | G_EVAL);

	SPAGAIN;

	if (SvTRUE (ERRSV))
		gperl_run_exception_handlers ();

	/* refresh the param_values with whatever changes the callback may
	 * have made.  values returned on the stack take precedence over
	 * modifications to @_. */
	if (count == 2) {
		SV * sv;
		/* get the values off the end of the stack.  why do my
		 * attempts to use ST() result in segfaults? */
		*position_p = POPi;
		sv = POPs;
		sv_utf8_upgrade (sv);
		g_value_set_string (param_values+1, SvPV (sv, len));
		g_value_set_int (param_values+2, len);
		PUTBACK;
		
	} else if (count == 0) {
		/* returned no values, then refresh string and position
		 * params from the callback's args, which may have been
		 * modified. */
		sv_utf8_upgrade (string);
		g_value_set_string (param_values+1, SvPV (string, len));
		g_value_set_int (param_values+2, len);
		*position_p = SvIV (position);
		if (*position_p < 0)
			*position_p = 0;

	} else {
		/* NOTE: croaking here can cause bad things to happen to the
		 * app, because croaking in signal handlers is bad juju. */
		croak ("an insert-text signal handler must either return"
		       " two items (text and position)\nor return no items"
		       " and possibly modify its @_ parameters.\n"
		       "  callback returned %d items", count);
	}

	/*
	 * clean up 
	 */
	SvREFCNT_dec (string);
	SvREFCNT_dec (position);

	FREETMPS;
	LEAVE;
}


MODULE = Gtk2::Editable	PACKAGE = Gtk2::Editable	PREFIX = gtk_editable_

BOOT:
	gperl_signal_set_marshaller_for (GTK_TYPE_EDITABLE, "insert_text",
	                                 gtk2perl_editable_insert_text_marshal);

void
gtk_editable_select_region (editable, start, end)
	GtkEditable *editable
	gint start
	gint end


 ## returns an empty list if there is no selection

void
gtk_editable_get_selection_bounds (editable)
	GtkEditable *editable
    PREINIT:
	gint start;
	gint end;
    PPCODE:
	if (!gtk_editable_get_selection_bounds (editable, &start, &end))
		XSRETURN_EMPTY;
	EXTEND (SP, 2);
	PUSHs (sv_2mortal (newSViv (start)));
	PUSHs (sv_2mortal (newSViv (end)));

 ## returns position of next char after inserted text
gint
gtk_editable_insert_text (editable, new_text, new_text_length, position)
	GtkEditable *editable
	const gchar *new_text
	gint new_text_length
	gint position
    CODE:
	gtk_editable_insert_text (editable, new_text,
				  new_text_length, &position);
	RETVAL = position;
    OUTPUT:
	RETVAL

void
gtk_editable_delete_text (editable, start_pos, end_pos)
	GtkEditable *editable
	gint start_pos
	gint end_pos

gchar_own *
gtk_editable_get_chars (editable, start_pos, end_pos)
	GtkEditable *editable
	gint start_pos
	gint end_pos

void
gtk_editable_cut_clipboard (editable)
	GtkEditable *editable

void
gtk_editable_copy_clipboard (editable)
	GtkEditable *editable

void
gtk_editable_paste_clipboard (editable)
	GtkEditable *editable

void
gtk_editable_delete_selection (editable)
	GtkEditable *editable

void
gtk_editable_set_position (editable, position)
	GtkEditable *editable
	gint position

gint
gtk_editable_get_position (editable)
	GtkEditable *editable

void
gtk_editable_set_editable (editable, is_editable)
	GtkEditable *editable
	gboolean is_editable

gboolean
gtk_editable_get_editable (editable)
	GtkEditable *editable

