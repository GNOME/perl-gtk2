/*
 * $Header$
 */

#include "gtk2perl.h"

/* this is just an interface */


// typedef gboolean (* GtkTreeModelForeachFunc) (GtkTreeModel *model, GtkTreePath *path, GtkTreeIter *iter, gpointer data)

MODULE = Gtk2::TreeModel	PACKAGE = Gtk2::TreePath	PREFIX = gtk_tree_path_

GtkTreePath_own_ornull *
gtk_tree_path_new (class, path=NULL)
	SV * class
	const gchar * path
    CODE:
	if (path)
		RETVAL = gtk_tree_path_new_from_string (path);
	else
		RETVAL = gtk_tree_path_new ();
    OUTPUT:
	RETVAL


GtkTreePath_own_ornull *
gtk_tree_path_new_from_string (class, path)
	SV * class
	const gchar * path
    C_ARGS:
	path

#if GTK_CHECK_VERSION(2,2,0)

## GtkTreePath * gtk_tree_path_new_from_indices (gint first_index, ...)
## C version uses list terminated by -1; perl version should take
## everything on the stack and stop at any -1s encountered
## FIXME API reference doesn't mention whether returned value is an array
#GtkTreePath_own_ornull *
#gtk_tree_path_new_from_indices (class, first_index, ...)
#	SV * class
#	gint first_index

#endif /* 2.2.0 */


gchar*
gtk_tree_path_to_string (path)
	GtkTreePath * path

GtkTreePath *
gtk_tree_path_new_first (class)
	SV * class
    C_ARGS:


## gtk_tree_path_new_root is deprecated in 2.2.0

void
gtk_tree_path_append_index (path, index_)
	GtkTreePath *path
	gint index_

void
gtk_tree_path_prepend_index (path, index_)
	GtkTreePath *path
	gint index_

gint
gtk_tree_path_get_depth (path)
	GtkTreePath *path

## perl developer need never know this exists
## void gtk_tree_path_free (GtkTreePath *path)

## C function returns a new copy of arg, so perl wrapper owns the object
GtkTreePath_own *
gtk_tree_path_copy (path)
	GtkTreePath * path

gint
gtk_tree_path_compare (a, b)
	GtkTreePath *a
	GtkTreePath *b

void
gtk_tree_path_next (path)
	GtkTreePath *path

gboolean
gtk_tree_path_prev (path)
	GtkTreePath *path

gboolean
gtk_tree_path_up (path)
	GtkTreePath *path

void
gtk_tree_path_down (path)
	GtkTreePath *path

gboolean
gtk_tree_path_is_ancestor (path, descendant)
	GtkTreePath *path
	GtkTreePath *descendant

gboolean
gtk_tree_path_is_descendant (path, ancestor)
	GtkTreePath *path
	GtkTreePath *ancestor

##
##CRAP! GtkRowReference isn't in the maps file!
##
##MODULE = Gtk2::TreeModel	PACKAGE = Gtk2::TreeRowReference	PREFIX = gtk_tree_row_reference_
##
##
##GtkTreeRowReference* gtk_tree_row_reference_new (GtkTreeModel *model, GtkTreePath *path);
##GtkTreeRowReference* gtk_tree_row_reference_new_proxy (GObject *proxy, GtkTreeModel *model, GtkTreePath *path);
##GtkTreePath* gtk_tree_row_reference_get_path (GtkTreeRowReference *reference);
##
#### gboolean gtk_tree_row_reference_valid (GtkTreeRowReference *reference)
##gboolean
##gtk_tree_row_reference_valid (reference)
##	GtkTreeRowReference *reference
##
#### a perl developer need never know this exists
#### void gtk_tree_row_reference_free (GtkTreeRowReference *reference)
##
###if GTK_CHECK_VERSION(2,2,0)
##GtkTreeRowReference* gtk_tree_row_reference_copy (GtkTreeRowReference *reference);
###endif /* 2.2.0 */
##
##
#### void gtk_tree_row_reference_inserted (GObject *proxy, GtkTreePath *path)
##void
##gtk_tree_row_reference_inserted (proxy, path)
##	GObject *proxy
##	GtkTreePath *path
##
#### void gtk_tree_row_reference_deleted (GObject *proxy, GtkTreePath *path)
##void
##gtk_tree_row_reference_deleted (proxy, path)
##	GObject *proxy
##	GtkTreePath *path
##
#### void gtk_tree_row_reference_reordered (GObject *proxy, GtkTreePath *path, GtkTreeIter *iter, gint *new_order)
##void
##gtk_tree_row_reference_reordered (proxy, path, iter, new_order)
##	GObject *proxy
##	GtkTreePath *path
##	GtkTreeIter *iter
##	gint *new_order
##

####MODULE = Gtk2::TreeModel	PACKAGE = Gtk2::TreeIter	PREFIX = gtk_tree_iter_

## not intended for use in applications.  the bindings take care of
## this for us.
## GtkTreeIter * gtk_tree_iter_copy (GtkTreeIter *iter)

#### should be done by DESTROY, not needed
## void gtk_tree_iter_free (GtkTreeIter *iter)


MODULE = Gtk2::TreeModel	PACKAGE = Gtk2::TreeModel	PREFIX = gtk_tree_model_

## GtkTreeModelFlags gtk_tree_model_get_flags (GtkTreeModel *tree_model)
GtkTreeModelFlags
gtk_tree_model_get_flags (tree_model)
	GtkTreeModel *tree_model

## gint gtk_tree_model_get_n_columns (GtkTreeModel *tree_model)
gint
gtk_tree_model_get_n_columns (tree_model)
	GtkTreeModel *tree_model

## GType gtk_tree_model_get_column_type (GtkTreeModel *tree_model, gint index_)
### we hide GType from the perl level.  return the corresponding
### package instead.
const gchar *
gtk_tree_model_get_column_type (tree_model, index_)
	GtkTreeModel *tree_model
	gint index_
    PREINIT:
	GType t;
    CODE:
	t = gtk_tree_model_get_column_type (tree_model, index_);
	RETVAL = gperl_package_from_type (t);
	if (!RETVAL)
		croak ("internal -- type of column %d, %s (%d), is not registered with GPerl",
			index_, g_type_name (t), t);
    OUTPUT:
	RETVAL

## gboolean gtk_tree_model_get_iter (GtkTreeModel *tree_model, GtkTreeIter *iter, GtkTreePath *path)
GtkTreeIter_own_ornull *
gtk_tree_model_get_iter (tree_model, path)
	GtkTreeModel *tree_model
	GtkTreePath *path
    PREINIT:
	GtkTreeIter iter = {0, };
    CODE:
	if (!gtk_tree_model_get_iter (tree_model, &iter, path))
		RETVAL = NULL;
	else
		RETVAL = gtk_tree_iter_copy (&iter);
    OUTPUT:
	RETVAL

##### FIXME couldn't we combine get_iter and get_iter_from_string, since we'll
#####       be able to tell at runtime whether the arg is a GtkTreePath or a
#####       plain old string?

## gboolean gtk_tree_model_get_iter_from_string (GtkTreeModel *tree_model, GtkTreeIter *iter, const gchar *path_string)
GtkTreeIter_own_ornull *
gtk_tree_model_get_iter_from_string (tree_model, path_string)
	GtkTreeModel *tree_model
	const gchar *path_string
    PREINIT:
	GtkTreeIter iter = {0, };
    CODE:
	if (!gtk_tree_model_get_iter_from_string (tree_model, &iter, path_string))
		RETVAL = NULL;
	else
		RETVAL = gtk_tree_iter_copy (&iter);
    OUTPUT:
	RETVAL

#if GTK_CHECK_VERSION(2,2,0)

## gchar * gtk_tree_model_get_string_from_iter (GtkTreeModel *tree_model, GtkTreeIter *iter)
gchar *
gtk_tree_model_get_string_from_iter (tree_model, iter)
	GtkTreeModel *tree_model
	GtkTreeIter *iter

#endif /* 2.2.0 */

## gboolean gtk_tree_model_get_iter_first (GtkTreeModel *tree_model, GtkTreeIter *iter)
GtkTreeIter_own_ornull *
gtk_tree_model_get_iter_first (tree_model)
	GtkTreeModel *tree_model
    PREINIT:
	GtkTreeIter iter = {0, };
    CODE:
	if (!gtk_tree_model_get_iter_first (tree_model, &iter))
		RETVAL = NULL;
	else
		RETVAL = gtk_tree_iter_copy (&iter);
    OUTPUT:
	RETVAL

### gtk_tree_model_get_iter_root is deprecated

## GtkTreePath * gtk_tree_model_get_path (GtkTreeModel *tree_model, GtkTreeIter *iter)
GtkTreePath_own *
gtk_tree_model_get_path (tree_model, iter)
	GtkTreeModel *tree_model
	GtkTreeIter *iter

## return the proper thing from the GValue as an SV
##  remember that we hide GValue from perl
## void gtk_tree_model_get_value (GtkTreeModel *tree_model, GtkTreeIter *iter, gint column, GValue *value)
SV *
gtk_tree_model_get_value (tree_model, iter, column)
	GtkTreeModel *tree_model
	GtkTreeIter *iter
	gint column
    PREINIT:
	GValue value = {0, };
    CODE:
	gtk_tree_model_get_value (tree_model, iter, column, &value);
	RETVAL = gperl_sv_from_value (&value);
	g_value_unset (&value);
    OUTPUT:
	RETVAL

##### FIXME this is where i stopped and went home

##
## gboolean gtk_tree_model_iter_next (GtkTreeModel *tree_model, GtkTreeIter *iter)
gboolean
gtk_tree_model_iter_next (tree_model, iter)
	GtkTreeModel *tree_model
	GtkTreeIter *iter

#### gboolean gtk_tree_model_iter_children (GtkTreeModel *tree_model, GtkTreeIter *iter, GtkTreeIter *parent)
GtkTreeIter_own_ornull *
gtk_tree_model_iter_children (tree_model, parent)
	GtkTreeModel *tree_model
	GtkTreeIter *parent
    PREINIT:
	GtkTreeIter iter;
    CODE:
	if (!gtk_tree_model_iter_children (tree_model, &iter, parent))
		XSRETURN_UNDEF;
	RETVAL = &iter;
    OUTPUT:
	RETVAL

## gboolean gtk_tree_model_iter_has_child (GtkTreeModel *tree_model, GtkTreeIter *iter)
gboolean
gtk_tree_model_iter_has_child (tree_model, iter)
	GtkTreeModel *tree_model
	GtkTreeIter *iter

## gint gtk_tree_model_iter_n_children (GtkTreeModel *tree_model, GtkTreeIter *iter)
gint
gtk_tree_model_iter_n_children (tree_model, iter)
	GtkTreeModel *tree_model
	GtkTreeIter_ornull *iter

#### gboolean gtk_tree_model_iter_nth_child (GtkTreeModel *tree_model, GtkTreeIter *iter, GtkTreeIter *parent, gint n)
##gboolean
##gtk_tree_model_iter_nth_child (tree_model, iter, parent, n)
##	GtkTreeModel *tree_model
##	GtkTreeIter *iter
##	GtkTreeIter *parent
##	gint n
##
#### gboolean gtk_tree_model_iter_parent (GtkTreeModel *tree_model, GtkTreeIter *iter, GtkTreeIter *child)
##gboolean
##gtk_tree_model_iter_parent (tree_model, iter, child)
##	GtkTreeModel *tree_model
##	GtkTreeIter *iter
##	GtkTreeIter *child
##
#### void gtk_tree_model_ref_node (GtkTreeModel *tree_model, GtkTreeIter *iter)
##void
##gtk_tree_model_ref_node (tree_model, iter)
##	GtkTreeModel *tree_model
##	GtkTreeIter *iter
##
#### void gtk_tree_model_unref_node (GtkTreeModel *tree_model, GtkTreeIter *iter)
##void
##gtk_tree_model_unref_node (tree_model, iter)
##	GtkTreeModel *tree_model
##	GtkTreeIter *iter

# FIXME this one is probably important
## void gtk_tree_model_get (GtkTreeModel *tree_model, GtkTreeIter *iter, ...)
void
gtk_tree_model_get (tree_model, iter, ...)
	GtkTreeModel *tree_model
	GtkTreeIter *iter
	PREINIT:
	int i;
	PPCODE:
	for (i = 2 ; i < items ; i++) {
		SV * sv;
		GValue gvalue = {0, };
		gtk_tree_model_get_value (tree_model, iter, SvIV (ST (i)),
		                          &gvalue);
		XPUSHs (sv_2mortal (gperl_sv_from_value (&gvalue)));
		g_value_unset (&gvalue);
	}

#### void gtk_tree_model_get_valist (GtkTreeModel *tree_model, GtkTreeIter *iter, va_list var_args)
##void
##gtk_tree_model_get_valist (tree_model, iter, var_args)
##	GtkTreeModel *tree_model
##	GtkTreeIter *iter
##	va_list var_args
##
#### void gtk_tree_model_foreach (GtkTreeModel *model, GtkTreeModelForeachFunc func, gpointer user_data)
##void
##gtk_tree_model_foreach (model, func, user_data)
##	GtkTreeModel *model
##	GtkTreeModelForeachFunc func
##	gpointer user_data
##
#### void gtk_tree_model_row_changed (GtkTreeModel *tree_model, GtkTreePath *path, GtkTreeIter *iter)
##void
##gtk_tree_model_row_changed (tree_model, path, iter)
##	GtkTreeModel *tree_model
##	GtkTreePath *path
##	GtkTreeIter *iter
##
#### void gtk_tree_model_row_inserted (GtkTreeModel *tree_model, GtkTreePath *path, GtkTreeIter *iter)
##void
##gtk_tree_model_row_inserted (tree_model, path, iter)
##	GtkTreeModel *tree_model
##	GtkTreePath *path
##	GtkTreeIter *iter
##
#### void gtk_tree_model_row_has_child_toggled (GtkTreeModel *tree_model, GtkTreePath *path, GtkTreeIter *iter)
##void
##gtk_tree_model_row_has_child_toggled (tree_model, path, iter)
##	GtkTreeModel *tree_model
##	GtkTreePath *path
##	GtkTreeIter *iter
##
#### void gtk_tree_model_row_deleted (GtkTreeModel *tree_model, GtkTreePath *path)
##void
##gtk_tree_model_row_deleted (tree_model, path)
##	GtkTreeModel *tree_model
##	GtkTreePath *path
##
#### void gtk_tree_model_rows_reordered (GtkTreeModel *tree_model, GtkTreePath *path, GtkTreeIter *iter, gint *new_order)
##void
##gtk_tree_model_rows_reordered (tree_model, path, iter, new_order)
##	GtkTreeModel *tree_model
##	GtkTreePath *path
##	GtkTreeIter *iter
##	gint *new_order
##
