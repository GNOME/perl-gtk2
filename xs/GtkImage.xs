#include "gtk2perl.h"

MODULE = Gtk2::Image	PACKAGE = Gtk2::Image	PREFIX = gtk_image_

GtkWidget*
gtk_image_new (class)
	SV * class
    C_ARGS:


 ## GtkWidget* gtk_image_new_from_pixmap (GdkPixmap *pixmap, GdkBitmap *mask)
 ##GtkWidget*
 ##gtk_image_new_from_pixmap (pixmap, mask)
 ##	GdkPixmap *pixmap
 ##	GdkBitmap *mask
 ##
 ## GtkWidget* gtk_image_new_from_image (GdkImage *image, GdkBitmap *mask)
 ##GtkWidget*
 ##gtk_image_new_from_image (image, mask)
 ##	GdkImage *image
 ##	GdkBitmap *mask

GtkWidget*
gtk_image_new_from_file (class, filename)
	SV * class
	const gchar *filename
    C_ARGS:
	filename

 ## GtkWidget* gtk_image_new_from_pixbuf (GdkPixbuf *pixbuf)
GtkWidget*
gtk_image_new_from_pixbuf (class, pixbuf)
	SV * class
	GdkPixbuf_ornull * pixbuf
    C_ARGS:
	pixbuf

GtkWidget*
gtk_image_new_from_stock (class, stock_id, size)
	SV * class
	const gchar *stock_id
	GtkIconSize size
    C_ARGS:
	stock_id, size

 ## GtkWidget* gtk_image_new_from_icon_set (GtkIconSet *icon_set, GtkIconSize size)
 ##GtkWidget*
 ##gtk_image_new_from_icon_set (icon_set, size)
 ##	GtkIconSet *icon_set
 ##	GtkIconSize size

 ## GtkWidget* gtk_image_new_from_animation (GdkPixbufAnimation *animation)
 ##GtkWidget*
 ##gtk_image_new_from_animation (animation)
 ##	GdkPixbufAnimation *animation

 ## void gtk_image_set_from_pixmap (GtkImage *image, GdkPixmap *pixmap, GdkBitmap *mask)
 ##void
 ##gtk_image_set_from_pixmap (image, pixmap, mask)
 ##	GtkImage *image
 ##	GdkPixmap *pixmap
 ##	GdkBitmap *mask

 ## void gtk_image_set_from_image (GtkImage *image, GdkImage *gdk_image, GdkBitmap *mask)
 ##void
 ##gtk_image_set_from_image (image, gdk_image, mask)
 ##	GtkImage *image
 ##	GdkImage *gdk_image
 ##	GdkBitmap *mask

void
gtk_image_set_from_file (image, filename)
	GtkImage *image
	const gchar *filename

 ## void gtk_image_set_from_pixbuf (GtkImage *image, GdkPixbuf *pixbuf)
void
gtk_image_set_from_pixbuf (image, pixbuf)
	GtkImage *image
	GdkPixbuf_ornull *pixbuf

void
gtk_image_set_from_stock (image, stock_id, size)
	GtkImage *image
	const gchar *stock_id
	GtkIconSize size

 ## void gtk_image_set_from_icon_set (GtkImage *image, GtkIconSet *icon_set, GtkIconSize size)
 ##void
 ##gtk_image_set_from_icon_set (image, icon_set, size)
 ##	GtkImage *image
 ##	GtkIconSet *icon_set
 ##	GtkIconSize size

 ## void gtk_image_set_from_animation (GtkImage *image, GdkPixbufAnimation *animation)
 ##void
 ##gtk_image_set_from_animation (image, animation)
 ##	GtkImage *image
 ##	GdkPixbufAnimation *animation

 ## GtkImageType gtk_image_get_storage_type (GtkImage *image)
GtkImageType
gtk_image_get_storage_type (image)
	GtkImage *image

 ## void gtk_image_get_pixmap (GtkImage *image, GdkPixmap **pixmap, GdkBitmap **mask)
 ##void
 ##gtk_image_get_pixmap (image, pixmap, mask)
 ##	GtkImage *image
 ##	GdkPixmap **pixmap
 ##	GdkBitmap **mask

 ## void gtk_image_get_image (GtkImage *image, GdkImage **gdk_image, GdkBitmap **mask)
 ##void
 ##gtk_image_get_image (image, gdk_image, mask)
 ##	GtkImage *image
 ##	GdkImage **gdk_image
 ##	GdkBitmap **mask

 ## GdkPixbuf* gtk_image_get_pixbuf (GtkImage *image)
 ##GdkPixbuf*
 ##gtk_image_get_pixbuf (image)
 ##	GtkImage *image

void
gtk_image_get_stock (image)
	GtkImage *image
    PREINIT:
	gchar *stock_id;
	GtkIconSize size;
    PPCODE:
	gtk_image_get_stock (image, &stock_id, &size);
	EXTEND (SP, 2);
	PUSHs (sv_2mortal (newSVpv (stock_id, 0)));
	PUSHs (sv_2mortal (newSVGtkIconSize (size)));

 ## void gtk_image_get_icon_set (GtkImage *image, GtkIconSet **icon_set, GtkIconSize *size)
 ##void
 ##gtk_image_get_icon_set (image, icon_set, size)
 ##	GtkImage *image
 ##	GtkIconSet **icon_set
 ##	GtkIconSize *size

 ## GdkPixbufAnimation* gtk_image_get_animation (GtkImage *image)
 ##GdkPixbufAnimation*
 ##gtk_image_get_animation (image)
 ##	GtkImage *image

 ## void gtk_image_get (GtkImage *image, GdkImage **val, GdkBitmap **mask)
 ##void
 ##gtk_image_get (image, val, mask)
 ##	GtkImage *image
 ##	GdkImage **val
 ##	GdkBitmap **mask

# TODO: GdkBitmap not in typemap
##void gtk_image_set (GtkImage *image, GdkImage *val, GdkBitmap *mask)
#void
#gtk_image_set (image, val, mask)
#	GtkImage  * image
#	GtkImage  * val
#	GdkBitmap * mask

