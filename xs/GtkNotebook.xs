/*
 * $Header$
 */

#include "gtk2perl.h"

MODULE = Gtk2::Notebook	PACKAGE = Gtk2::Notebook	PREFIX = gtk_notebook_

## GtkWidget * gtk_notebook_new (void)
GtkWidget *
gtk_notebook_new (class)
	SV * class
    C_ARGS:

## void gtk_notebook_append_page (GtkNotebook *notebook, GtkWidget *child, GtkWidget *tab_label)
void
gtk_notebook_append_page (notebook, child, tab_label)
	GtkNotebook * notebook
	GtkWidget   * child
	GtkWidget   * tab_label

## void gtk_notebook_append_page_menu (GtkNotebook *notebook, GtkWidget *child, GtkWidget *tab_label, GtkWidget *menu_label)
void
gtk_notebook_append_page_menu (notebook, child, tab_label, menu_label)
	GtkNotebook * notebook
	GtkWidget   * child
	GtkWidget   * tab_label
	GtkWidget   * menu_label

## void gtk_notebook_prepend_page (GtkNotebook *notebook, GtkWidget *child, GtkWidget *tab_label)
void
gtk_notebook_prepend_page (notebook, child, tab_label)
	GtkNotebook * notebook
	GtkWidget   * child
	GtkWidget   * tab_label

## void gtk_notebook_prepend_page_menu (GtkNotebook *notebook, GtkWidget *child, GtkWidget *tab_label, GtkWidget *menu_label)
void
gtk_notebook_prepend_page_menu (notebook, child, tab_label, menu_label)
	GtkNotebook * notebook
	GtkWidget   * child
	GtkWidget   * tab_label
	GtkWidget   * menu_label

## void gtk_notebook_insert_page (GtkNotebook *notebook, GtkWidget *child, GtkWidget *tab_label, gint position)
void
gtk_notebook_insert_page (notebook, child, tab_label, position)
	GtkNotebook * notebook
	GtkWidget   * child
	GtkWidget   * tab_label
	gint          position

## void gtk_notebook_insert_page_menu (GtkNotebook *notebook, GtkWidget *child, GtkWidget *tab_label, GtkWidget *menu_label, gint position)
void
gtk_notebook_insert_page_menu (notebook, child, tab_label, menu_label, position)
	GtkNotebook * notebook
	GtkWidget   * child
	GtkWidget   * tab_label
	GtkWidget   * menu_label
	gint          position

## void gtk_notebook_remove_page (GtkNotebook *notebook, gint page_num)
void
gtk_notebook_remove_page (notebook, page_num)
	GtkNotebook * notebook
	gint          page_num

## GtkWidget* gtk_notebook_get_nth_page (GtkNotebook *notebook, gint page_num)
GtkWidget *
gtk_notebook_get_nth_page (notebook, page_num)
	GtkNotebook * notebook
	gint          page_num

## gint gtk_notebook_page_num (GtkNotebook *notebook, GtkWidget *child)
gint
gtk_notebook_page_num (notebook, child)
	GtkNotebook * notebook
	GtkWidget   * child

## void gtk_notebook_set_current_page (GtkNotebook *notebook, gint page_num)
void
gtk_notebook_set_current_page (notebook, page_num)
	GtkNotebook * notebook
	gint          page_num

## void gtk_notebook_next_page (GtkNotebook *notebook)
void
gtk_notebook_next_page (notebook)
	GtkNotebook * notebook

## void gtk_notebook_prev_page (GtkNotebook *notebook)
void
gtk_notebook_prev_page (notebook)
	GtkNotebook * notebook

## gboolean gtk_notebook_get_show_border (GtkNotebook *notebook)
gboolean
gtk_notebook_get_show_border (notebook)
	GtkNotebook * notebook

## void gtk_notebook_set_show_tabs (GtkNotebook *notebook, gboolean show_tabs)
void
gtk_notebook_set_show_tabs (notebook, show_tabs)
	GtkNotebook * notebook
	gboolean      show_tabs

## gboolean gtk_notebook_get_show_tabs (GtkNotebook *notebook)
gboolean
gtk_notebook_get_show_tabs (notebook)
	GtkNotebook * notebook

## void gtk_notebook_set_tab_pos (GtkNotebook *notebook, GtkPositionType pos)
void
gtk_notebook_set_tab_pos (notebook, pos)
	GtkNotebook     * notebook
	GtkPositionType   pos

## GtkPositionType gtk_notebook_get_tab_pos (GtkNotebook *notebook)
GtkPositionType
gtk_notebook_get_tab_pos (notebook)
	GtkNotebook * notebook

## void gtk_notebook_set_homogeneous_tabs (GtkNotebook *notebook, gboolean homogeneous)
void
gtk_notebook_set_homogeneous_tabs (notebook, homogeneous)
	GtkNotebook * notebook
	gboolean      homogeneous

## void gtk_notebook_set_tab_border (GtkNotebook *notebook, guint border_width)
void
gtk_notebook_set_tab_border (notebook, border_width)
	GtkNotebook * notebook
	guint         border_width

## void gtk_notebook_set_tab_hborder (GtkNotebook *notebook, guint tab_hborder)
void
gtk_notebook_set_tab_hborder (notebook, tab_hborder)
	GtkNotebook * notebook
	guint         tab_hborder

## void gtk_notebook_set_tab_vborder (GtkNotebook *notebook, guint tab_vborder)
void
gtk_notebook_set_tab_vborder (notebook, tab_vborder)
	GtkNotebook * notebook
	guint         tab_vborder

## void gtk_notebook_set_scrollable (GtkNotebook *notebook, gboolean scrollable)
void
gtk_notebook_set_scrollable (notebook, scrollable)
	GtkNotebook * notebook
	gboolean      scrollable

## gboolean gtk_notebook_get_scrollable (GtkNotebook *notebook)
gboolean
gtk_notebook_get_scrollable (notebook)
	GtkNotebook * notebook

## void gtk_notebook_popup_disable (GtkNotebook *notebook)
void
gtk_notebook_popup_disable (notebook)
	GtkNotebook * notebook

## void gtk_notebook_set_tab_label (GtkNotebook *notebook, GtkWidget *child, GtkWidget *tab_label)
void
gtk_notebook_set_tab_label (notebook, child, tab_label)
	GtkNotebook * notebook
	GtkWidget   * child
	GtkWidget   * tab_label

## void gtk_notebook_set_tab_label_text (GtkNotebook *notebook, GtkWidget *child, const gchar *tab_text)
void
gtk_notebook_set_tab_label_text (notebook, child, tab_text)
	GtkNotebook * notebook
	GtkWidget   * child
	const gchar * tab_text

## GtkWidget * gtk_notebook_get_menu_label (GtkNotebook *notebook, GtkWidget *child)
GtkWidget *
gtk_notebook_get_menu_label (notebook, child)
	GtkNotebook * notebook
	GtkWidget   * child

## void gtk_notebook_set_menu_label (GtkNotebook *notebook, GtkWidget *child, GtkWidget *menu_label)
void
gtk_notebook_set_menu_label (notebook, child, menu_label)
	GtkNotebook * notebook
	GtkWidget   * child
	GtkWidget   * menu_label

## void gtk_notebook_set_menu_label_text (GtkNotebook *notebook, GtkWidget *child, const gchar *menu_text)
void
gtk_notebook_set_menu_label_text (notebook, child, menu_text)
	GtkNotebook * notebook
	GtkWidget   * child
	const gchar * menu_text

## void gtk_notebook_query_tab_label_packing (GtkNotebook *notebook, GtkWidget *child, gboolean *expand, gboolean *fill, GtkPackType *pack_type)
void
gtk_notebook_query_tab_label_packing (GtkNotebook * notebook, GtkWidget * child, OUTLIST gboolean expand, OUTLIST gboolean fill, OUTLIST GtkPackType pack_type)

## void gtk_notebook_set_tab_label_packing (GtkNotebook *notebook, GtkWidget *child, gboolean expand, gboolean fill, GtkPackType pack_type)
void
gtk_notebook_set_tab_label_packing (notebook, child, expand, fill, pack_type)
	GtkNotebook * notebook
	GtkWidget   * child
	gboolean      expand
	gboolean      fill
	GtkPackType   pack_type

## void gtk_notebook_reorder_child (GtkNotebook *notebook, GtkWidget *child, gint position)
void
gtk_notebook_reorder_child (notebook, child, position)
	GtkNotebook * notebook
	GtkWidget   * child
	gint          position

##GtkType gtk_notebook_get_type (void) G_GNUC_CONST

##gint gtk_notebook_get_current_page (GtkNotebook *notebook)
gint
gtk_notebook_get_current_page (notebook)
	GtkNotebook * notebook

##void gtk_notebook_set_show_border (GtkNotebook *notebook, gboolean show_border)
void
gtk_notebook_set_show_border (notebook, show_border)
	GtkNotebook * notebook
	gboolean      show_border

##void gtk_notebook_popup_enable (GtkNotebook *notebook)
void
gtk_notebook_popup_enable (notebook)
	GtkNotebook * notebook

##GtkWidget * gtk_notebook_get_tab_label (GtkNotebook *notebook, GtkWidget *child)
GtkWidget *
gtk_notebook_get_tab_label (notebook, child)
	GtkNotebook * notebook
	GtkWidget   * child

##gint gtk_notebook_get_n_pages (GtkNotebook *notebook)
gint
gtk_notebook_get_n_pages (notebook)
	GtkNotebook * notebook
    CODE:
#if GTK_CHECK_VERSION(2,2,0)
	RETVAL = gtk_notebook_get_n_pages (notebook);
#else
	/* this wasn't defined before 2.2.0...  but it's really handy and
	 * easy to implement, like so: */
	RETVAL = g_list_length (notebook->children);
#endif
    OUTPUT:
	RETVAL

## const gchar * gtk_notebook_get_menu_label_text (GtkNotebook *notebook, GtkWidget *child)
const gchar *
gtk_notebook_get_menu_label_text (notebook, child)
	GtkNotebook * notebook
	GtkWidget   * child

## const gchar * gtk_notebook_get_tab_label_text (GtkNotebook *notebook, GtkWidget *child)
const gchar *
gtk_notebook_get_tab_label_text (notebook, child)
	GtkNotebook * notebook
	GtkWidget   * child

