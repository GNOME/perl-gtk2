/*
 * Copyright (c) 2006 by the gtk2-perl team (see the file AUTHORS)
 *
 * Licensed under the LGPL, see LICENSE file for more information.
 *
 * $Header$
 */

#include "gtk2perl.h"

MODULE = Gtk2::PageSetup	PACKAGE = Gtk2::PageSetup	PREFIX = gtk_page_setup_

# GtkPageSetup * gtk_page_setup_new (void);
GtkPageSetup_noinc * gtk_page_setup_new (class)
    C_ARGS:
	/* void */

# FIXME: needed?
# GtkPageSetup * gtk_page_setup_copy (GtkPageSetup *other);

GtkPageOrientation gtk_page_setup_get_orientation (GtkPageSetup *setup);

void gtk_page_setup_set_orientation (GtkPageSetup *setup, GtkPageOrientation orientation);

# setup still owns the size object
GtkPaperSize * gtk_page_setup_get_paper_size (GtkPageSetup *setup);

# setup takes a copy of the size object
void gtk_page_setup_set_paper_size (GtkPageSetup *setup, GtkPaperSize *size);

gdouble gtk_page_setup_get_top_margin (GtkPageSetup *setup, GtkUnit unit);

void gtk_page_setup_set_top_margin (GtkPageSetup *setup, gdouble margin, GtkUnit unit);

gdouble gtk_page_setup_get_bottom_margin (GtkPageSetup *setup, GtkUnit unit);

void gtk_page_setup_set_bottom_margin (GtkPageSetup *setup, gdouble margin, GtkUnit unit);

gdouble gtk_page_setup_get_left_margin (GtkPageSetup *setup, GtkUnit unit);

void gtk_page_setup_set_left_margin (GtkPageSetup *setup, gdouble margin, GtkUnit unit);

gdouble gtk_page_setup_get_right_margin (GtkPageSetup *setup, GtkUnit unit);

void gtk_page_setup_set_right_margin (GtkPageSetup *setup, gdouble margin, GtkUnit unit);

# setup takes a copy of the size object
void gtk_page_setup_set_paper_size_and_default_margins (GtkPageSetup *setup, GtkPaperSize *size);

gdouble gtk_page_setup_get_paper_width (GtkPageSetup *setup, GtkUnit unit);

gdouble gtk_page_setup_get_paper_height (GtkPageSetup *setup, GtkUnit unit);

gdouble gtk_page_setup_get_page_width (GtkPageSetup *setup, GtkUnit unit);

gdouble gtk_page_setup_get_page_height (GtkPageSetup *setup, GtkUnit unit);
