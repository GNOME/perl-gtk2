/*
 * $Header$
 */

#include "gtk2perl.h"

/*
 * this name is ridiculously long to as to be descriptive and avoid
 * namespace pollution --- the symbol must be exported from this
 * module so that Gtk2::ListStore can get to it.
 *
 * converts ST(first) through ST(items) on the perl stack into an array of
 * GTypes.  for use with gtk_(list|tree)_store_new and _set.  this helper
 * fiddles with the stack but does not alter it.
 *
 * assumes the items between first and items on the stack are package names,
 * and croaks if any of them have not been registered with gperl (that is,
 * if they can't be turned into GTypes).
 *
 * caller must free the return GArray.
 */
GArray *
gtk2perl_tree_store_stack_items_to_gtype_array_or_croak (int first)
{
	GArray * typearray;
	int i;

	dXSARGS;

	typearray = g_array_new (FALSE, FALSE, sizeof (GType));
	g_array_set_size (typearray, items - first);

	for (i = first ; i < items ; i++) {
		char * package = SvPV_nolen (ST (i));
		/* look up GType by package name. */
		GType t = gperl_type_from_package (package);
		if (t == 0) {
			g_array_free (typearray, TRUE);
			croak ("package %s is not registered with GPerl",
			       package);
			g_assert ("not reached");
			return NULL; /* not reached */
		}
		g_array_index (typearray, GType, i-first) = t;
	}

	return typearray;
}


MODULE = Gtk2::TreeStore	PACKAGE = Gtk2::TreeStore	PREFIX = gtk_tree_store_

BOOT:
	/* must prepend TreeModel in the hierarchy so that
	 * Gtk2::TreeModel::get isn't masked by G::Object::get.
	 * should we change the api to something unique, instead? */
	gperl_prepend_isa ("Gtk2::TreeStore", "Gtk2::TreeModel");
	gperl_set_isa ("Gtk2::TreeStore", "Gtk2::TreeDragSource");
	gperl_set_isa ("Gtk2::TreeStore", "Gtk2::TreeDragDest");
	gperl_set_isa ("Gtk2::TreeStore", "Gtk2::TreeSortable");

## GtkTreeStore* gtk_tree_store_new (gint n_columns, ...);
GtkTreeStore_noinc*
gtk_tree_store_new (class, ...)
	SV * class
    PREINIT:
	GArray * types;
    CODE:
	types = gtk2perl_tree_store_stack_items_to_gtype_array_or_croak (1);
	RETVAL = gtk_tree_store_newv (types->len, (GType*)(types->data));
	g_array_free (types, TRUE);
    OUTPUT:
	RETVAL


# for derived GObjects.  there's currently no way to derive an object
# from perl, so this isn't needed yet.
## void gtk_tree_store_set_column_types (GtkTreeStore *tree_store, gint n_columns, GType *types)
#void
#gtk_tree_store_set_column_types (tree_store, ...)
#	GtkTreeStore *tree_store
##    PREINIT:
##	GArray * types;
##    CODE:
##	types = gtk2perl_tree_store_stack_items_to_gtype_array_or_croak (1);
##	gtk_tree_store_set_column_types (list_store, types->len,
##	                                 (GType*)(types->data));

## void gtk_tree_store_set (GtkTreeStore *tree_store, GtkTreeIter *iter, ...)
void
gtk_tree_store_set (tree_store, iter, ...)
	GtkTreeStore *tree_store
	GtkTreeIter *iter
    PREINIT:
	int i;
    CODE:
	/* require at least one pair --- that means there needs to be
	 * four items on the stack.  also require that the stack has an
	 * even number of items on it. */
	if (items < 4 || 0 != (items % 2)) {
		/* caller didn't specify an even number of parameters... */
		croak ("Usage: $treestore->set ($iter, column1, value1, column2, value2, ...)\n"
		       "   there must be a value for every column number");
	}
	for (i = 2 ; i < items ; i+= 2) {
		gint column;
		SV * sv;
		GValue gvalue = {0, };
		if (!looks_like_number (ST (i)))
			croak ("Usage: $treestore->set ($iter, column1, value1, column2, value2, ...)\n"
			       "   the first value in each pair must be a column number");
		column = SvIV (ST (i));

		g_value_init (&gvalue,
		              gtk_tree_model_get_column_type (GTK_TREE_MODEL (tree_store),
							      column));
		if (!gperl_value_from_sv (&gvalue, ST (i+1))) {
			/* FIXME need a more useful error message here,
			 *   as this could be triggered by somebody who
			 *   doesn't know how the function works, and i
			 *   doubt this message would clue him in */
			croak ("failed to convert parameter %d from SV to GValue",
			       i);
		}
		gtk_tree_store_set_value (GTK_TREE_STORE (tree_store),
		                          iter, column, &gvalue);
		g_value_unset (&gvalue);
	}

### we're trying to hide things like GValue from the perl level!
## void gtk_tree_store_set_value (GtkTreeStore *tree_store, GtkTreeIter *iter, gint column, GValue *value)
## see Gtk2::TreeStore::set instead
## void gtk_tree_store_set_valist (GtkTreeStore *tree_store, GtkTreeIter *iter, va_list var_args)

## gboolean gtk_tree_store_remove (GtkTreeStore *tree_store, GtkTreeIter *iter)
gboolean
gtk_tree_store_remove (tree_store, iter)
	GtkTreeStore *tree_store
	GtkTreeIter *iter
    CODE:
#if GTK_CHECK_VERSION(2,2,0)
	RETVAL = gtk_tree_store_remove (tree_store, iter);
#else
	/* void return in 2.0.x; always return FALSE from this function
	 * in that case; FIXME the alternative is to implement the missing
	 * functionality right here. */
	gtk_tree_store_remove (tree_store, iter);
	RETVAL = FALSE;
#endif
    OUTPUT:
	RETVAL

## void gtk_tree_store_insert (GtkTreeStore *tree_store, GtkTreeIter *iter, GtkTreeIter *parent, gint position)
GtkTreeIter_copy *
gtk_tree_store_insert (tree_store, parent, position)
	GtkTreeStore       * tree_store
	GtkTreeIter_ornull * parent
	gint                 position
    PREINIT:
	GtkTreeIter iter = {0, };
    CODE:
	gtk_tree_store_insert (tree_store, &iter, parent, position);
	RETVAL = &iter;
    OUTPUT:
	RETVAL

## void gtk_tree_store_insert_before (GtkTreeStore *tree_store, GtkTreeIter *iter, GtkTreeIter *parent, GtkTreeIter *sibling)
## void gtk_tree_store_insert_after (GtkTreeStore *tree_store, GtkTreeIter *iter, GtkTreeIter *parent, GtkTreeIter *sibling)
GtkTreeIter_copy *
gtk_tree_store_insert_before (tree_store, parent, sibling)
	GtkTreeStore       * tree_store
	GtkTreeIter_ornull * parent
	GtkTreeIter_ornull * sibling
    ALIAS:
	Gtk2::TreeStore::insert_before = 1
	Gtk2::TreeStore::insert_after  = 2
    PREINIT:
	GtkTreeIter iter;
    CODE:
	if (ix == 1)
		gtk_tree_store_insert_before (tree_store, &iter,
		                              parent, sibling);
	else
		gtk_tree_store_insert_after (tree_store, &iter,
		                             parent, sibling);
	RETVAL = &iter;
    OUTPUT:
	RETVAL

## void gtk_tree_store_prepend (GtkTreeStore *tree_store, GtkTreeIter *iter, GtkTreeIter *parent)
## void gtk_tree_store_append (GtkTreeStore *tree_store, GtkTreeIter *iter, GtkTreeIter *parent)
GtkTreeIter_copy *
gtk_tree_store_prepend (tree_store, parent)
	GtkTreeStore *tree_store
	GtkTreeIter_ornull *parent
    ALIAS:
	Gtk2::TreeStore::prepend = 1
	Gtk2::TreeStore::append  = 2
    PREINIT:
	GtkTreeIter iter;
    CODE:
	if (ix == 1)
		gtk_tree_store_prepend (tree_store, &iter, parent);
	else
		gtk_tree_store_append (tree_store, &iter, parent);
	RETVAL = &iter;
    OUTPUT:
	RETVAL

## gboolean gtk_tree_store_is_ancestor (GtkTreeStore *tree_store, GtkTreeIter *iter, GtkTreeIter *descendant)
gboolean
gtk_tree_store_is_ancestor (tree_store, iter, descendant)
	GtkTreeStore *tree_store
	GtkTreeIter *iter
	GtkTreeIter *descendant

## gint gtk_tree_store_iter_depth (GtkTreeStore *tree_store, GtkTreeIter *iter)
gint
gtk_tree_store_iter_depth (tree_store, iter)
	GtkTreeStore *tree_store
	GtkTreeIter *iter

## void gtk_tree_store_clear (GtkTreeStore *tree_store)
void
gtk_tree_store_clear (tree_store)
	GtkTreeStore *tree_store

#if GTK_CHECK_VERSION(2,2,0)

## warning, slow, use only for debugging
## gboolean gtk_tree_store_iter_is_valid (GtkTreeStore *tree_store, GtkTreeIter *iter)
gboolean
gtk_tree_store_iter_is_valid (tree_store, iter)
	GtkTreeStore *tree_store
	GtkTreeIter *iter

### TODO: new_order is an array of integers.  what are the contraints on
###       the length and how do you find them?
#### void gtk_tree_store_reorder (GtkTreeStore *tree_store, GtkTreeIter *parent, gint *new_order)
##void
##gtk_tree_store_reorder (tree_store, parent, new_order)
##	GtkTreeStore *tree_store
##	GtkTreeIter *parent
##	gint *new_order

## void gtk_tree_store_swap (GtkTreeStore *tree_store, GtkTreeIter *a, GtkTreeIter *b)
void
gtk_tree_store_swap (tree_store, a, b)
	GtkTreeStore *tree_store
	GtkTreeIter *a
	GtkTreeIter *b

## void gtk_tree_store_move_before (GtkTreeStore *tree_store, GtkTreeIter *iter, GtkTreeIter *position)
void
gtk_tree_store_move_before (tree_store, iter, position)
	GtkTreeStore *tree_store
	GtkTreeIter *iter
	GtkTreeIter *position

## void gtk_tree_store_move_after (GtkTreeStore *tree_store, GtkTreeIter *iter, GtkTreeIter *position)
void
gtk_tree_store_move_after (tree_store, iter, position)
	GtkTreeStore *tree_store
	GtkTreeIter *iter
	GtkTreeIter *position

#endif /* >= 2.2.0 */
