#include "gtk2perl.h"

MODULE = Gtk2::Gdk::PixbufLoader	PACKAGE = Gtk2::Gdk::PixbufLoader	PREFIX = gdk_pixbuf_loader_

##  GdkPixbufLoader * gdk_pixbuf_loader_new (void) 
GdkPixbufLoader_noinc *
gdk_pixbuf_loader_new (class)
	SV * class
    C_ARGS:
	

##  GdkPixbufLoader * gdk_pixbuf_loader_new_with_type (const char *image_type, GError **error) 
GdkPixbufLoader_noinc *
gdk_pixbuf_loader_new_with_type (image_type)
	const char *image_type
    PREINIT:
	GError * error = NULL;
    CODE:
	RETVAL = gdk_pixbuf_loader_new_with_type (image_type, &error);
	if (!RETVAL)
		gperl_croak_gerror (NULL, error);
    OUTPUT:
	RETVAL

#if GTK_CHECK_VERSION(2,2,0)

##  void gdk_pixbuf_loader_set_size (GdkPixbufLoader *loader, int width, int height) 
void
gdk_pixbuf_loader_set_size (loader, width, height)
	GdkPixbufLoader *loader
	int width
	int height

#endif /* >= 2.2.0 */

##  gboolean gdk_pixbuf_loader_write (GdkPixbufLoader *loader, const guchar *buf, gsize count, GError **error) 
gboolean
gdk_pixbuf_loader_write (loader, buf, count=0)
	GdkPixbufLoader *loader
	char * buf
	gint count
    PREINIT:
	//const guchar * realbuf;
	GError * error = NULL;
    CODE:
	if (count == 0)
		count = sv_len (ST (1));
warn ("writing %d bytes from %p", count, buf);
	RETVAL = gdk_pixbuf_loader_write (loader, buf, count, &error);
	if (!RETVAL)
		gperl_croak_gerror (NULL, error);
    OUTPUT:
	RETVAL

##  GdkPixbuf * gdk_pixbuf_loader_get_pixbuf (GdkPixbufLoader *loader) 
GdkPixbuf *
gdk_pixbuf_loader_get_pixbuf (loader)
	GdkPixbufLoader *loader

##  GdkPixbufAnimation * gdk_pixbuf_loader_get_animation (GdkPixbufLoader *loader) 
GdkPixbufAnimation_ornull *
gdk_pixbuf_loader_get_animation (loader)
	GdkPixbufLoader *loader

##  gboolean gdk_pixbuf_loader_close (GdkPixbufLoader *loader, GError **error) 
void
gdk_pixbuf_loader_close (loader)
	GdkPixbufLoader *loader
    PREINIT:
	GError * error = NULL;
    CODE:
	if (!gdk_pixbuf_loader_close (loader, &error))
		gperl_croak_gerror (NULL, error);

#if GTK_CHECK_VERSION(2,2,0)

###  GdkPixbufFormat *gdk_pixbuf_loader_get_format (GdkPixbufLoader *loader) 
#GdkPixbufFormat *
#gdk_pixbuf_loader_get_format (loader)
#	GdkPixbufLoader *loader

#endif /* >= 2.2.0 */
