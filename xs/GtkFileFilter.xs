#include "gtk2perl.h"

#ifdef GTK_TYPE_FILE_FILTER

static gboolean
gtk2perl_file_filter_func (const GtkFileFilterInfo *filter_info,
                           gpointer                 data)
{
	GPerlCallback * callback = (GPerlCallback*) data;
	GValue value = {0,};
	gboolean retval;
	g_value_init (&value, G_TYPE_BOOLEAN);
	gperl_callback_invoke (callback, &value, filter_info);
	retval = g_value_get_boolean (&value);
	g_value_unset (&value);
	return retval;
}

/*
struct _GtkFileFilterInfo
{
  GtkFileFilterFlags contains;
  
  const gchar *filename;
  const gchar *uri;
  const gchar *display_name;
  const gchar *mime_type;
};
*/

#endif /* GTK_TYPE_FILE_FILTER */

MODULE = Gtk2::FileFilter	PACKAGE = Gtk2::FileFilter	PREFIX = gtk_file_filter_

#ifdef GTK_TYPE_FILE_FILTER

GtkFileFilter * gtk_file_filter_new (class);
    C_ARGS:
	/*void*/

void gtk_file_filter_set_name (GtkFileFilter *filter, const gchar *name);

const gchar *gtk_file_filter_get_name (GtkFileFilter *filter);

void gtk_file_filter_add_mime_type (GtkFileFilter *filter, const gchar *mime_type);

void gtk_file_filter_add_pattern (GtkFileFilter *filter, const gchar *pattern);

 ### /* there appears to be no boxed type support for GtkFileFilterInfo */

#ifdef GTK_TYPE_FILE_FILTER_INFO

void gtk_file_filter_add_custom (GtkFileFilter *filter, GtkFileFilterFlags needed, SV * func, SV * data);
    PREINIT:
	GType param_types[] = {
		GTK_TYPE_FILE_FILTER_INFO
	};
	GPerlCallback * callback;
    CODE:
	callback = gperl_callback_new (func, data, 1, param_types, G_TYPE_BOOLEAN);
	gtk_file_filter_add_custom (filter, needed,
	                            gtk2perl_file_filter_func, callback,
	                            (GDestroyNotify)gperl_callback_destroy);

#endif

GtkFileFilterFlags gtk_file_filter_get_needed (GtkFileFilter *filter);

#ifdef GTK_TYPE_FILE_FILTER_INFO

###gboolean gtk_file_filter_filter (GtkFileFilter *filter, const GtkFileFilterInfo *filter_info);
gboolean gtk_file_filter_filter (GtkFileFilter *filter, GtkFileFilterInfo *filter_info);

#endif

#endif
