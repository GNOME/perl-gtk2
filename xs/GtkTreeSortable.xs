#include "gtk2perl.h"

// typedef gint (* GtkTreeIterCompareFunc) (GtkTreeModel *model, GtkTreeIter *a, GtkTreeIter *b, gpointer user_data)

MODULE = Gtk2::TreeSortable	PACKAGE = Gtk2::TreeSortable	PREFIX = gtk_tre_sortable_

## void gtk_tree_sortable_sort_column_changed (GtkTreeSortable *sortable)
void
gtk_tree_sortable_sort_column_changed (sortable)
	GtkTreeSortable *sortable

#### gboolean gtk_tree_sortable_get_sort_column_id (GtkTreeSortable *sortable, gint *sort_column_id, GtkSortType *order)
void
gtk_tree_sortable_get_sort_column_id (sortable)
	GtkTreeSortable *sortable
    PREINIT:
	gint sort_column_id;
	GtkSortType order;
    PPCODE:
	if (!gtk_tree_sortable_get_sort_column_id (sortable, &sort_column_id,
	                                           &order))
		XSRETURN_EMPTY;
	EXTEND (SP, 2);
	PUSHs (sv_2mortal (newSViv (sort_column_id)));
	PUSHs (sv_2mortal (newSVGtkSortType (order)));

## void gtk_tree_sortable_set_sort_column_id (GtkTreeSortable *sortable, gint sort_column_id, GtkSortType order)
void
gtk_tree_sortable_set_sort_column_id (sortable, sort_column_id, order)
	GtkTreeSortable *sortable
	gint sort_column_id
	GtkSortType order

#### void gtk_tree_sortable_set_sort_func (GtkTreeSortable *sortable, gint sort_column_id, GtkTreeIterCompareFunc sort_func, gpointer user_data, GtkDestroyNotify destroy)
##void
##gtk_tree_sortable_set_sort_func (sortable, sort_column_id, sort_func, user_data, destroy)
##	GtkTreeSortable *sortable
##	gint sort_column_id
##	GtkTreeIterCompareFunc sort_func
##	gpointer user_data
##	GtkDestroyNotify destroy
##
#### void gtk_tree_sortable_set_default_sort_func (GtkTreeSortable *sortable, GtkTreeIterCompareFunc sort_func, gpointer user_data, GtkDestroyNotify destroy)
##void
##gtk_tree_sortable_set_default_sort_func (sortable, sort_func, user_data, destroy)
##	GtkTreeSortable *sortable
##	GtkTreeIterCompareFunc sort_func
##	gpointer user_data
##	GtkDestroyNotify destroy

## gboolean gtk_tree_sortable_has_default_sort_func (GtkTreeSortable *sortable)
gboolean
gtk_tree_sortable_has_default_sort_func (sortable)
	GtkTreeSortable *sortable

