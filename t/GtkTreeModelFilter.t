#
# $Header$
#

use Gtk2::TestHelper
	# FIXME 2.4
	at_least_version => [2, 3, 0, "GtkTreeModelFilter is new in 2.4"],
	tests => 1, noinit => 1;

SKIP: { skip "NOT IMPLEMENTED", 1; }
__END__

sub visible_func {
	my ($model, $iter, $data) = @_;
	isa_ok ($model, 'Gtk2::TreeModel');
	isa_ok ($iter,  'Gtk2::TreeIter');
	return TRUE;
}

sub modify_func {
	my ($model, $iter, $value, $column, $data) = @_;
	isa_ok ($model, 'Gtk2::TreeModel');
	isa_ok ($iter,  'Gtk2::TreeIter');
	#isa_ok ($value, 'Glib::Scalar');
	#isa_ok ($column, 'Glib::Int');
}



my $root = $child_model->get_path ($child_model->get_iter_first);
my $filter = Gtk2::TreeModelFilter->new ($child_model, $root);
my $filter = Gtk2::TreeModelFilter->new ($child_model, undef);

$filter->set_visible_func (SV * func, SV * data=NULL)

$filter->set_modify_func (SV * types, SV * func, SV * data=NULL);


$filter->set_visible_column (GtkTreeModelFilter *filter, gint column);


is ($filter->get_model, $child_model);


##
## conversion
##

$filter->convert_child_iter_to_iter (GtkTreeIter *filter_iter, GtkTreeIter *child_iter);

$filter->convert_iter_to_child_iter (GtkTreeIter *child_iter, GtkTreeIter *filter_iter);

GtkTreePath *$filter->convert_child_path_to_path (GtkTreePath *child_path);

GtkTreePath *$filter->convert_path_to_child_path (GtkTreePath *filter_path);


##
## extras
##

$filter->refilter

$filter->clear_cache

