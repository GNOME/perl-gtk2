#
# $Header$
#

use Gtk2::TestHelper
	# FIXME 2.4
	at_least_version => [2, 3, 0, "GtkCellLayout is new in 2.4"],
	tests => 1, noinit => 1;

SKIP: { skip "NOT IMPLEMENTED", 1; }
__END__

/*
typedef void (* GtkCellLayoutDataFunc) (GtkCellLayout   *cell_layout,
                                        GtkCellRenderer *cell,
                                        GtkTreeModel    *tree_model,
                                        GtkTreeIter     *iter,
                                        gpointer         data);
*/

static void
gtk2perl_cell_layout_data_func (GtkCellLayout   *cell_layout,
                                GtkCellRenderer *cell,
                                GtkTreeModel    *tree_model,
                                GtkTreeIter     *iter,
                                gpointer         data)
{
	GPerlCallback * callback = (GPerlCallback *) data;

	gperl_callback_invoke (callback, NULL, cell_layout, cell,
	                       tree_model, iter);
}

## MODULE = Gtk2::CellLayout

$cell_layout->pack_start (GtkCellRenderer *cell, gboolean expand);

$cell_layout->pack_end (GtkCellRenderer *cell, gboolean expand);

$cell_layout->clear

$cell_layout->set_attributes (GtkCellRenderer *cell, ...);
    PREINIT:
	gint i;
    CODE:
	if (items < 4 || 0 != (items - 2) % 2)
		croak ("usage: $cell_layout->set_attributes (name => column, ...)\n"
		       "   expecting a list of name => column pairs"); 
	for (i = 2 ; i < items ; i+=2) {
		$cell_layout->add_attribute (cell_layout, cell,
		                               SvPV_nolen (ST (i)),
		                               SvIV (ST (i+1)));
	}

$cell_layout->add_attribute (GtkCellRenderer *cell, const gchar *attribute, gint column);

$cell_layout->set_cell_data_func (GtkCellRenderer *cell, SV * func, SV * func_data=NULL);
    PREINIT:
	GType param_types[] = {
		GTK_TYPE_CELL_LAYOUT,
		GTK_TYPE_CELL_RENDERER,
		GTK_TYPE_TREE_MODEL,
		GTK_TYPE_TREE_ITER
	};
	GPerlCallback * callback;
    CODE:
	callback = gperl_callback_new (func, func_data, 4, param_types,
	                               G_TYPE_NONE);
	$cell_layout->set_cell_data_func
	                    (cell_layout, cell,
	                     gtk2perl_cell_layout_data_func, callback,
		             (GDestroyNotify) gperl_callback_destroy);

$cell_layout->clear_attributes (GtkCellRenderer *cell);

$cell_layout->reorder (GtkCellRenderer *cell, gint position)

