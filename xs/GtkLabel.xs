/*
 * $Header$
 */

#include "gtk2perl.h"


MODULE = Gtk2::Label	PACKAGE = Gtk2::Label	PREFIX = gtk_label_


GtkWidget *
gtk_label_new (class, str)
	SV * class
	const char * str
    C_ARGS:
	str


GtkWidget *
gtk_label_new_with_mnemonic (class, str)
	SV * class
	const char * str
    C_ARGS:
	str

### gtk_label_[gs]et_text ---- string does *not* include any embedded stuff
void
gtk_label_set_text (label, str)
	GtkLabel      * label
	const char    * str

const gchar *
gtk_label_get_text (label)
	GtkLabel      * label

 #void gtk_label_set_attributes    (GtkLabel      * label,
 #                                  PangoAttrList * attrs)
 #
 #PangoAttrList * gtk_label_get_attributes    (GtkLabel      * label);

### gtk_label_[gs]et_label ---- string includes any embedded stuff
void
gtk_label_set_label (label, str)
	GtkLabel * label
	const gchar * str

const gchar *
gtk_label_get_label (label)
	GtkLabel * label

void
gtk_label_set_markup (label, str)
	GtkLabel      * label
	const gchar   * str

void
gtk_label_set_use_markup (label, setting)
	GtkLabel      * label
	gboolean        setting

gboolean
gtk_label_get_use_markup (label)
	GtkLabel      * label

void
gtk_label_set_use_underline (label, setting)
	GtkLabel      * label
	gboolean        setting

gboolean
gtk_label_get_use_underline (label)
	GtkLabel      * label


void
gtk_label_set_markup_with_mnemonic (label, str)
	GtkLabel * label
	const gchar * str

guint
gtk_label_get_mnemonic_keyval (label)
	GtkLabel * label

void
gtk_label_set_mnemonic_widget (label, widget)
	GtkLabel * label
	GtkWidget * widget

GtkWidget *
gtk_label_get_mnemonic_widget (label)
	GtkLabel * label

void
gtk_label_set_text_with_mnemonic (label, str)
	GtkLabel * label
	const gchar * str

void
gtk_label_set_justify (label, jtype)
	GtkLabel         * label
	GtkJustification   jtype

GtkJustification
gtk_label_get_justify (label)
	GtkLabel         * label

void
gtk_label_set_pattern (label, pattern)
	GtkLabel         * label
	const gchar      * pattern

void
gtk_label_set_line_wrap (label, wrap)
	GtkLabel         * label
	gboolean           wrap

gboolean
gtk_label_get_line_wrap (label)
	GtkLabel         * label

void
gtk_label_set_selectable (label, setting)
	GtkLabel * label
	gboolean setting

gboolean
gtk_label_get_selectable (label)
	GtkLabel * label

void
gtk_label_select_region (label, start_offset=-1, end_offset=-1)
	GtkLabel         * label
	gint               start_offset
	gint               end_offset


 #gboolean gtk_label_get_selection_bounds           (GtkLabel         * label,
 #                                                   gint             * start,
 #                                                   gint             * end)
## done by hand because we don't want to return the boolean...  either there's
## a list or not.
void
gtk_label_get_selection_bounds (label)
	GtkLabel * label
	PREINIT:
	gint start, end;
	PPCODE:
	if (!gtk_label_get_selection_bounds (label, &start, &end))
		XSRETURN_UNDEF;
	EXTEND (SP, 2);
	PUSHs (sv_2mortal (newSViv (start)));
	PUSHs (sv_2mortal (newSViv (end)));


PangoLayout *
gtk_label_get_layout (label)
	GtkLabel * label


void gtk_label_get_layout_offsets (GtkLabel * label, OUTLIST gint x, OUTLIST gint y)
