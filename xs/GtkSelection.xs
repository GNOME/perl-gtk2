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

SV *
newSVGtkTargetEntry (GtkTargetEntry * e)
{
	HV * h;
	SV * r;

	if (!e)
		return &PL_sv_undef;

	h = newHV ();
	r = newRV_noinc ((SV*)h);

	hv_store (h, "target", 6, e->target ? newSVpv (e->target, 0) : newSVsv (&PL_sv_undef), 0);
	hv_store (h, "flags", 5, newSVGtkTargetFlags (e->flags), 0);
	hv_store (h, "info", 4, newSViv (e->info), 0);

	return r;
}

GtkTargetEntry *
SvGtkTargetEntry (SV * sv)
{
	GtkTargetEntry * entry = gperl_alloc_temp (sizeof (GtkTargetEntry));
	gtk2perl_read_gtk_target_entry (sv, entry);
	return entry;
}

void
gtk2perl_read_gtk_target_entry (SV * sv,
                                GtkTargetEntry * e)
{
	HV * h;
	AV * a;
	SV ** s;
	STRLEN len;

	if ((!sv) || (!SvOK (sv)) || (!SvRV (sv)) || 
	    (SvTYPE (SvRV (sv)) != SVt_PVHV && SvTYPE (SvRV(sv)) != SVt_PVAV))
		croak ("a target entry must be a reference to a hash "
		       "containing the keys 'target', 'flags', and 'info', "
		       "or a reference to a three-element list containing "
		       "the information in the order target, flags, info");

	if (SvTYPE (SvRV (sv)) == SVt_PVHV) {
		h = (HV*) SvRV (sv);
		if ((s=hv_fetch (h, "target", 6, 0)) && SvOK (*s))
			e->target = SvPV (*s, len);
		if ((s=hv_fetch (h, "flags", 5, 0)) && SvOK (*s))
			e->flags = SvGtkTargetFlags (*s);
		if ((s=hv_fetch (h, "info", 4, 0)) && SvOK (*s))
			e->info = SvUV (*s);
	} else {
		a = (AV*)SvRV (sv);
		if ((s=av_fetch (a, 0, 0)) && SvOK (*s))
			e->target = SvPV (*s, len);
		if ((s=av_fetch (a, 1, 0)) && SvOK (*s))
			e->flags = SvUV (*s);
		if ((s=av_fetch (a, 2, 0)) && SvOK (*s))
			e->info = SvUV (*s);
	}
}

SV *
newSVGtkTargetList (GtkTargetList * list)
{
	gtk_target_list_ref (list);
	return sv_setref_pv (newSV (0), "Gtk2::TargetList", list);
	
}

GtkTargetList *
SvGtkTargetList (SV * sv)
{
	if (!sv || !SvROK (sv) ||
	    !sv_derived_from (sv, "Gtk2::TargetList"))
		croak ("variable is not of type Gtk2::TargetList");
	return (GtkTargetList*) SvUV (SvRV (sv));
}


MODULE = Gtk2::Selection	PACKAGE = Gtk2::TargetList	PREFIX = gtk_target_list_

void
DESTROY (SV * list)
    CODE:
	gtk_target_list_unref (SvGtkTargetList (list));

##  GtkTargetList *gtk_target_list_new (const GtkTargetEntry *targets, guint ntargets) 
=for apidoc
=for arg ... of Gtk2::TargetEntry's
=cut
GtkTargetList *
gtk_target_list_new (class, ...)
    PREINIT:
	GtkTargetEntry *targets;
	guint ntargets;
    CODE:
	GTK2PERL_STACK_ITEMS_TO_TARGET_ENTRY_ARRAY (1, targets, ntargets);
	RETVAL = gtk_target_list_new (targets, ntargets);
    OUTPUT:
	RETVAL
    CLEANUP:
	gtk_target_list_unref (RETVAL);

 ## unmapped, automagical
##  void gtk_target_list_ref (GtkTargetList *list) 
##  void gtk_target_list_unref (GtkTargetList *list) 

##  void gtk_target_list_add (GtkTargetList *list, GdkAtom target, guint flags, guint info) 
void
gtk_target_list_add (list, target, flags, info)
	GtkTargetList *list
	GdkAtom target
	guint flags
	guint info

##  void gtk_target_list_add_table (GtkTargetList *list, const GtkTargetEntry *targets, guint ntargets) 
=for apidoc
=for arg ... of Gtk2::TargetEntry's
=cut
void
gtk_target_list_add_table (GtkTargetList * list, ...)
    PREINIT:
	GtkTargetEntry *targets;
	guint ntargets;
    CODE:
	GTK2PERL_STACK_ITEMS_TO_TARGET_ENTRY_ARRAY (1, targets, ntargets);
	gtk_target_list_add_table (list, targets, ntargets);

##  void gtk_target_list_remove (GtkTargetList *list, GdkAtom target) 
void
gtk_target_list_remove (list, target)
	GtkTargetList *list
	GdkAtom target

##  gboolean gtk_target_list_find (GtkTargetList *list, GdkAtom target, guint *info) 
gint
gtk_target_list_find (list, target)
	GtkTargetList *list
	GdkAtom target
    CODE:
	if (!gtk_target_list_find (list, target, &RETVAL))
		XSRETURN_UNDEF;
    OUTPUT:
	RETVAL


MODULE = Gtk2::Selection	PACKAGE = Gtk2::Selection	PREFIX = gtk_selection_

##  gboolean gtk_selection_owner_set (GtkWidget *widget, GdkAtom selection, guint32 time_) 
gboolean
gtk_selection_owner_set (class, widget, selection, time_)
	GtkWidget_ornull *widget
	GdkAtom selection
	guint32 time_
    C_ARGS:
	widget, selection, time_

#if GTK_CHECK_VERSION(2,2,0)

##  gboolean gtk_selection_owner_set_for_display (GdkDisplay *display, GtkWidget *widget, GdkAtom selection, guint32 time_) 
gboolean
gtk_selection_owner_set_for_display (class, display, widget, selection, time_)
	GdkDisplay *display
	GtkWidget_ornull *widget
	GdkAtom selection
	guint32 time_
    C_ARGS:
    	display, widget, selection, time_

#endif /* >= 2.2.0 */

MODULE = Gtk2::Selection	PACKAGE = Gtk2::Widget	PREFIX = gtk_

##  void gtk_selection_add_target (GtkWidget *widget, GdkAtom selection, GdkAtom target, guint info) 
void
gtk_selection_add_target (widget, selection, target, info)
	GtkWidget *widget
	GdkAtom selection
	GdkAtom target
	guint info

##  void gtk_selection_add_targets (GtkWidget *widget, GdkAtom selection, const GtkTargetEntry *targets, guint ntargets) 
=for apidoc
=for arg ... of Gtk2::TargetEntry's
=cut
void
gtk_selection_add_targets (widget, selection, ...)
	GtkWidget *widget
	GdkAtom selection
    PREINIT:
	GtkTargetEntry *targets;
	guint ntargets;
    CODE:
	GTK2PERL_STACK_ITEMS_TO_TARGET_ENTRY_ARRAY (2, targets, ntargets);
	gtk_selection_add_targets (widget, selection, targets, ntargets);

##  void gtk_selection_clear_targets (GtkWidget *widget, GdkAtom selection) 
void
gtk_selection_clear_targets (widget, selection)
	GtkWidget *widget
	GdkAtom selection

##  gboolean gtk_selection_convert (GtkWidget *widget, GdkAtom selection, GdkAtom target, guint32 time_) 
gboolean
gtk_selection_convert (widget, selection, target, time_)
	GtkWidget *widget
	GdkAtom selection
	GdkAtom target
	guint32 time_

##  void gtk_selection_remove_all (GtkWidget *widget) 
void
gtk_selection_remove_all (widget)
	GtkWidget *widget

MODULE = Gtk2::Selection	PACKAGE = Gtk2::SelectionData	PREFIX = gtk_selection_data_

SV *
selection (d)
	GtkSelectionData * d
    ALIAS:
	Gtk2::SelectionData::target    = 1
	Gtk2::SelectionData::type      = 2
	Gtk2::SelectionData::format    = 3
	Gtk2::SelectionData::data      = 4
	Gtk2::SelectionData::length    = 5
	Gtk2::SelectionData::display   = 6
    CODE:
	RETVAL = NULL;
	switch (ix) {
	    case 0: RETVAL = newSVGdkAtom (d->selection); break;
	    case 1: RETVAL = newSVGdkAtom (d->target); break;
	    case 2: RETVAL = newSVGdkAtom (d->type); break;
	    case 3: RETVAL = newSViv (d->format); break;
	    case 4: RETVAL = newSVpv (d->data, d->length); break;
	    case 5: RETVAL = newSViv (d->length); break;
#if GTK_CHECK_VERSION(2,2,0)
	    case 6: RETVAL = newSVGdkDisplay (d->display); break;
#endif
	}
    OUTPUT:
	RETVAL

##  void gtk_selection_data_set (GtkSelectionData *selection_data, GdkAtom type, gint format, const guchar *data, gint length) 
void
gtk_selection_data_set (selection_data, type, format, data)
	GtkSelectionData *selection_data
	GdkAtom type
	gint format
	const guchar *data
    C_ARGS:
	selection_data, type, format, data, sv_len (ST (3))

##  gboolean gtk_selection_data_set_text (GtkSelectionData *selection_data, const gchar *str, gint len) 
gboolean
gtk_selection_data_set_text (selection_data, str, len=-1)
	GtkSelectionData *selection_data
	const gchar *str
	gint len

##  guchar * gtk_selection_data_get_text (GtkSelectionData *selection_data) 
#guchar *
gchar_own *
gtk_selection_data_get_text (selection_data)
	GtkSelectionData *selection_data

##  gboolean gtk_selection_data_get_targets (GtkSelectionData *selection_data, GdkAtom **targets, gint *n_atoms) 
=for apidoc
Gets the contents of selection_data as an array of targets. This can be used to
interpret the results of getting the standard TARGETS target that is always
supplied for any selection.

Returns a list of GdkAtoms, the targets.
=cut
void
gtk_selection_data_get_targets (selection_data)
	GtkSelectionData *selection_data
    PREINIT:
	GdkAtom *targets;
	gint n_atoms, i;
    PPCODE:
	if (!gtk_selection_data_get_targets (selection_data,
	                                     &targets, &n_atoms))
		XSRETURN_EMPTY;
	EXTEND (SP, n_atoms);
	for (i = 0 ; i < n_atoms ; i++)
		PUSHs (sv_2mortal (newSVGdkAtom (targets[i])));
	g_free (targets);

##  gboolean gtk_selection_data_targets_include_text (GtkSelectionData *selection_data) 
gboolean
gtk_selection_data_targets_include_text (selection_data)
	GtkSelectionData *selection_data

##  gboolean gtk_selection_clear (GtkWidget *widget, GdkEventSelection *event) 
gboolean
gtk_selection_clear (widget, event)
	GtkWidget *widget
	GdkEvent *event
    C_ARGS:
	widget, (GdkEventSelection*)event

 ## PRIVATE
##  gboolean _gtk_selection_request (GtkWidget *widget, GdkEventSelection *event) 
##  gboolean _gtk_selection_incr_event (GdkWindow *window, GdkEventProperty *event) 
##  gboolean _gtk_selection_notify (GtkWidget *widget, GdkEventSelection *event) 
##  gboolean _gtk_selection_property_notify (GtkWidget *widget, GdkEventProperty *event) 

 ## boxed wrapper support, taken care of by Glib::Boxed
##  GtkSelectionData *gtk_selection_data_copy (GtkSelectionData *data) 
##  void gtk_selection_data_free (GtkSelectionData *data) 

