/*
 * Copyright (c) 2004-2005 by the gtk2-perl team (see the file AUTHORS)
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

MODULE = Gtk2::AboutDialog PACKAGE = Gtk2 PREFIX = gtk_

=for object Gtk2::AboutDialog
=cut

=for apidoc
=for arg first_property_name (string)
=for arg ... the rest of a list of name=>property value pairs.
This is a convenience function for showing an application's about box. The
constructed dialog is associated with the parent window and reused for
future invocations of this function.
=cut
void gtk_show_about_dialog (class, GtkWindow_ornull * parent, first_property_name, ...);
    PREINIT:
	static GtkWidget * global_about_dialog = NULL;
	GtkWidget * dialog = NULL;
    CODE:
	if (parent)
		dialog = g_object_get_data (G_OBJECT (parent), "gtk-about-dialog");
	else
		dialog = global_about_dialog;
	if (!dialog) {
		int i;

		dialog = gtk_about_dialog_new ();

		g_object_ref (dialog);
		gtk_object_sink (GTK_OBJECT (dialog));

		g_signal_connect (dialog, "delete_event",
				  G_CALLBACK (gtk_widget_hide_on_delete), NULL);

		for (i = 2; i < items ; i+=2) {
			GParamSpec * pspec;
			char * name = SvPV_nolen (ST (i));
			SV * sv = ST (i + 1);

			pspec = g_object_class_find_property
					(G_OBJECT_GET_CLASS (dialog), name);
			if (! pspec) {
				const char * classname =
					gperl_object_package_from_type
						(G_OBJECT_TYPE (dialog));
				croak ("type %s does not support property '%s'",
				       classname, name);
			} else {
				GValue value = {0, };
				g_value_init (&value,
					      G_PARAM_SPEC_VALUE_TYPE (pspec));
				gperl_value_from_sv (&value, sv);
				g_object_set_property (G_OBJECT (dialog),
						       name, &value);
				g_value_unset (&value);
			}
		}
		if (parent)
			g_object_set_data_full (G_OBJECT (parent),
					       	"gtk-about-dialog",
						dialog, g_object_unref);
		else
			global_about_dialog = dialog;
	}
	gtk_window_present (GTK_WINDOW (dialog));


MODULE = Gtk2::AboutDialog PACKAGE = Gtk2::AboutDialog PREFIX = gtk_about_dialog_

GtkWidget * gtk_about_dialog_new (class)
    C_ARGS:
	/* void */

const gchar_ornull * gtk_about_dialog_get_name (GtkAboutDialog * about);

void gtk_about_dialog_set_name (GtkAboutDialog * about, const gchar_ornull * name);

const gchar_ornull * gtk_about_dialog_get_version (GtkAboutDialog * about);

void gtk_about_dialog_set_version (GtkAboutDialog * about, const gchar_ornull * version);

const gchar_ornull * gtk_about_dialog_get_copyright (GtkAboutDialog * about);

void gtk_about_dialog_set_copyright (GtkAboutDialog * about, const gchar_ornull * copyright);

const gchar_ornull * gtk_about_dialog_get_comments (GtkAboutDialog * about);

void gtk_about_dialog_set_comments (GtkAboutDialog * about, const gchar_ornull * comments);

const gchar_ornull * gtk_about_dialog_get_license (GtkAboutDialog * about);

void gtk_about_dialog_set_license (GtkAboutDialog * about, const gchar_ornull * license);

const gchar_ornull * gtk_about_dialog_get_website (GtkAboutDialog * about);

void gtk_about_dialog_set_website (GtkAboutDialog * about, const gchar_ornull * website);

const gchar_ornull * gtk_about_dialog_get_website_label (GtkAboutDialog * about);

void gtk_about_dialog_set_website_label (GtkAboutDialog * about, const gchar_ornull * website_label);

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
			(outof)[i] = SvGChar (ST (1 + i));	\
	}

##const gchar * const * gtk_about_dialog_get_authors (GtkAboutDialog * about);
void
gtk_about_dialog_get_authors (GtkAboutDialog * about)
    PREINIT:
	gint     i;
	const gchar * const * authors = NULL;
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
	gchar ** authors;
    CODE:
	SETTER (authors);
	gtk_about_dialog_set_authors (about, (const gchar **) authors);
	g_free (authors);

##const gchar * const * gtk_about_dialog_get_documenters (GtkAboutDialog * about);
void
gtk_about_dialog_get_documenters (GtkAboutDialog * about)
    PREINIT:
	gint     i;
	const gchar * const * documenters = NULL;
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
	gchar ** documenters;
    CODE:
	SETTER (documenters);
	gtk_about_dialog_set_documenters (about, (const gchar **) documenters);
	g_free (documenters);

##const gchar * const * gtk_about_dialog_get_artists (GtkAboutDialog * about);
void
gtk_about_dialog_get_artists (GtkAboutDialog * about)
    PREINIT:
	gint     i;
	const gchar * const * artists = NULL;
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
	gchar ** artists;
    CODE:
	SETTER (artists);
	gtk_about_dialog_set_artists (about, (const gchar **) artists);
	g_free (artists);

const gchar_ornull * gtk_about_dialog_get_translator_credits (GtkAboutDialog * about);

void gtk_about_dialog_set_translator_credits (GtkAboutDialog * about, const gchar_ornull *translator_credits);

GdkPixbuf_ornull * gtk_about_dialog_get_logo (GtkAboutDialog * about);

void gtk_about_dialog_set_logo (GtkAboutDialog * about, GdkPixbuf_ornull * logo);

const gchar_ornull * gtk_about_dialog_get_logo_icon_name (GtkAboutDialog * about);

void gtk_about_dialog_set_logo_icon_name (GtkAboutDialog * about, const gchar_ornull * icon_name);

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
