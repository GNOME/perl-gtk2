/*
 * $Header$
 */

#include "gtk2perl.h"

MODULE = Gtk2::Entry	PACKAGE = Gtk2::Entry	PREFIX = gtk_entry_

BOOT:
	{
	AV * isa = get_av ("Gtk2::Entry::ISA", TRUE);
	av_push (isa, newSVpv ("Gtk2::Editable", 0));
	}

GtkWidget*
gtk_entry_new (class)
	SV * class
    C_ARGS:

##GtkWidget* gtk_entry_new_with_max_length (gint max)
GtkWidget *
gtk_entry_new_with_max_length (class, max)
	SV   * class
	gint   max
    C_ARGS:
	max

void
gtk_entry_set_visibility (entry, visible)
	GtkEntry *entry
	gboolean visible

gboolean
gtk_entry_get_visibility (entry)
	GtkEntry *entry

 ## void gtk_entry_set_invisible_char (GtkEntry *entry, gunichar ch)
 ##void
 ##gtk_entry_set_invisible_char (entry, ch)
 ##	GtkEntry *entry
 ##	gunichar ch
 ##
 ## gunichar gtk_entry_get_invisible_char (GtkEntry *entry)
 ##gunichar
 ##gtk_entry_get_invisible_char (entry)
 ##	GtkEntry *entry

void
gtk_entry_set_has_frame (entry, setting)
	GtkEntry *entry
	gboolean setting

gboolean
gtk_entry_get_has_frame (entry)
	GtkEntry *entry

void
gtk_entry_set_max_length (entry, max)
	GtkEntry      *entry
	gint           max

gint
gtk_entry_get_max_length (entry)
	GtkEntry *entry

void
gtk_entry_set_activates_default (entry, setting)
	GtkEntry *entry
	gboolean setting

gboolean
gtk_entry_get_activates_default (entry)
	GtkEntry *entry

void
gtk_entry_set_width_chars (entry, n_chars)
	GtkEntry *entry
	gint n_chars

gint
gtk_entry_get_width_chars (entry)
	GtkEntry *entry

void
gtk_entry_set_text (entry, text)
	GtkEntry      *entry
	const gchar   *text

# had G_CONST_RETURN
const gchar*
gtk_entry_get_text (entry)
	GtkEntry      *entry

 ## PangoLayout* gtk_entry_get_layout (GtkEntry *entry)
 ##PangoLayout*
 ##gtk_entry_get_layout (entry)
 ##	GtkEntry *entry
 ##
 ## void gtk_entry_get_layout_offsets (GtkEntry *entry, gint *x, gint *y)
 ##void
 ##gtk_entry_get_layout_offsets (entry, x, y)
 ##	GtkEntry *entry
 ##	gint *x
 ##	gint *y
 ##

void
gtk_entry_append_text (entry, text)
	GtkEntry    * entry
	const gchar * text

void
gtk_entry_prepend_text (entry, text)
	GtkEntry    * entry
	const gchar * text

void
gtk_entry_set_position (entry, position)
	GtkEntry * entry
	gint       position

void
gtk_entry_select_region (entry, start, end)
	GtkEntry * entry
	gint       start
	gint       end

void
gtk_entry_set_editable (entry, editable)
	GtkEntry * entry
	gboolean   editable

