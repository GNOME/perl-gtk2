/*
 * Copyright (c) 2004 by the gtk2-perl team (see the file AUTHORS)
 *
 * Licensed under the LGPL, see LICENSE file for more information.
 *
 * $Header$
 */

#include "gtk2perl.h"

static GPerlCallback *
gtk2perl_about_dialog_activate_link_func_create (SV * func, SV * data)
{
	GType param_types [2];
	param_types[0] = GTK_TYPE_ABOUT_DIALOG;
	param_types[1] = G_TYPE_STRING;
	return gperl_callback_new (func, data, G_N_ELEMENTS (param_types),
				   param_types, 0);
}

static void
gtk2perl_about_dialog_activate_link_func (GtkAboutDialog *about,
                                          const gchar    *link,
                                          gpointer        data)
{
	gperl_callback_invoke ((GPerlCallback*)data, NULL, about, link);
}

MODULE = Gtk2::AboutDialog PACKAGE = Gtk2::AboutDialog PREFIX = gtk_about_dialog_

GtkWidget * gtk_about_dialog_new (class)
    C_ARGS:
	/* void */

## TODO/FIXME: 
##void gtk_show_about_dialog (GtkWindow * parent, const gchar * first_property_name, ...);

const gchar * gtk_about_dialog_get_name (GtkAboutDialog * about);

void gtk_about_dialog_set_name (GtkAboutDialog * about, const gchar * name);

const gchar * gtk_about_dialog_get_version (GtkAboutDialog * about);

void gtk_about_dialog_set_version (GtkAboutDialog * about, const gchar * version);

const gchar * gtk_about_dialog_get_copyright (GtkAboutDialog * about);

void gtk_about_dialog_set_copyright (GtkAboutDialog * about, const gchar * copyright);

const gchar * gtk_about_dialog_get_comments (GtkAboutDialog * about);

void gtk_about_dialog_set_comments (GtkAboutDialog * about, const gchar * comments);

const gchar * gtk_about_dialog_get_license (GtkAboutDialog * about);

void gtk_about_dialog_set_license (GtkAboutDialog * about, const gchar * license);

const gchar * gtk_about_dialog_get_website (GtkAboutDialog * about);

void gtk_about_dialog_set_website (GtkAboutDialog * about, const gchar * website);

const gchar * gtk_about_dialog_get_website_label (GtkAboutDialog * about);

void gtk_about_dialog_set_website_label (GtkAboutDialog * about, const gchar * website_label);

#define GETTER(into)							\
	{								\
		if (!(into))						\
			XSRETURN_EMPTY;					\
		for (i = 0; (into)[i] != NULL; i++)			\
			XPUSHs (sv_2mortal (newSVGChar ((into)[i])));	\
	}

#define SETTER(outof)						\
	{							\
		gint num = items - 1;				\
		(outof) = g_new0 (gchar *, num + 30);		\
		for (i = 0; i < num; i++)			\
			(outof)[i] = SvPV_nolen (ST (1 + i));	\
	}

##gchar ** gtk_about_dialog_get_authors (GtkAboutDialog * about);
void
gtk_about_dialog_get_authors (GtkAboutDialog * about)
    PREINIT:
	gint     i;
	gchar ** authors = NULL;
    PPCODE:
	authors = gtk_about_dialog_get_authors (about);
	GETTER (authors);

##void gtk_about_dialog_set_authors (GtkAboutDialog * about, gchar ** authors);
=for apidoc
=arg author1 (string)
=cut
void 
gtk_about_dialog_set_authors (about, author1, ...)
	GtkAboutDialog * about
    PREINIT:
	gint    i;
	char ** authors;
    CODE:
	SETTER (authors);
	gtk_about_dialog_set_authors (about, authors);
	g_free (authors);

##gchar ** gtk_about_dialog_get_documenters (GtkAboutDialog * about);
void
gtk_about_dialog_get_documenters (GtkAboutDialog * about)
    PREINIT:
	gint     i;
	gchar ** documenters = NULL;
    PPCODE:
	documenters = gtk_about_dialog_get_documenters (about);
	GETTER (documenters);

##void gtk_about_dialog_set_documenters (GtkAboutDialog * about, gchar ** documenters);
=for apidoc
=arg documenter1 (string)
=cut
void 
gtk_about_dialog_set_documenters (about, documenter1, ...)
	GtkAboutDialog * about
    PREINIT:
	gint    i;
	char ** documenters;
    CODE:
	SETTER (documenters);
	gtk_about_dialog_set_documenters (about, documenters);
	g_free (documenters);

##gchar ** gtk_about_dialog_get_artists (GtkAboutDialog * about);
void
gtk_about_dialog_get_artists (GtkAboutDialog * about)
    PREINIT:
	gint     i;
	gchar ** artists = NULL;
    PPCODE:
	artists = gtk_about_dialog_get_artists (about);
	GETTER (artists);

##void gtk_about_dialog_set_artists (GtkAboutDialog * about, gchar ** artists);
=for apidoc
=arg artist1 (string)
=cut
void 
gtk_about_dialog_set_artists (about, artist1, ...);
	GtkAboutDialog * about
    PREINIT:
	gint    i;
	char ** artists;
    CODE:
	SETTER (artists);
	gtk_about_dialog_set_artists (about, artists);
	g_free (artists);

const gchar * gtk_about_dialog_get_translator_credits (GtkAboutDialog * about);

void gtk_about_dialog_set_translator_credits (GtkAboutDialog * about, const gchar *translator_credits);

GdkPixbuf_ornull * gtk_about_dialog_get_logo (GtkAboutDialog * about);

void gtk_about_dialog_set_logo (GtkAboutDialog * about, GdkPixbuf * logo);

const gchar * gtk_about_dialog_get_logo_icon_name (GtkAboutDialog * about);

void gtk_about_dialog_set_logo_icon_name (GtkAboutDialog * about, const gchar * icon_name);

##GtkAboutDialogActivateLinkFunc gtk_about_dialog_set_email_hook (GtkAboutDialogActivateLinkFunc func, gpointer data, GDestroyNotify destroy);
void
gtk_about_dialog_set_email_hook (class, func, data = NULL)
	SV * func
	SV * data
    PREINIT:
	GPerlCallback *callback;
    CODE:
	callback = gtk2perl_about_dialog_activate_link_func_create (func, data);
	gtk_about_dialog_set_email_hook (
		(GtkAboutDialogActivateLinkFunc)
		  gtk2perl_about_dialog_activate_link_func,
		callback,
		(GDestroyNotify) gperl_callback_destroy);

##GtkAboutDialogActivateLinkFunc gtk_about_dialog_set_url_hook (GtkAboutDialogActivateLinkFunc func, gpointer data, GDestroyNotify destroy);
void
gtk_about_dialog_set_url_hook (class, func, data = NULL)
	SV * func
	SV * data
    PREINIT:
	GPerlCallback *callback;
    CODE:
	callback = gtk2perl_about_dialog_activate_link_func_create (func, data);
	gtk_about_dialog_set_url_hook (
		(GtkAboutDialogActivateLinkFunc)
		  gtk2perl_about_dialog_activate_link_func,
		callback,
		(GDestroyNotify) gperl_callback_destroy);
