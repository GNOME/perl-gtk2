#
# $Header$
#

#########################
# GtkNotbook Tests
# 	- rm
#########################

use Gtk2::TestHelper tests => 60;

my $win = Gtk2::Window->new;

ok( my $nb = Gtk2::Notebook->new );
$win->add($nb);
ok(1);


# just to make the lines shorter
sub label { Gtk2::Label->new (shift) }

is ($nb->prepend_page (label ('p1c'), label ('p1')), 0);

is ($nb->append_page (label ('p2c'), label ('p2')), 1);

my $child = label ('p1.5c');
is ($nb->insert_page ($child, label ('p1.5'), 1), 1);

is ($nb->prepend_page_menu (label ('Page 1c'), undef, label ('Page 1 pop')), 0);

is ($nb->append_page_menu (label ('Page 6c'), label ('Page 6l'),
			   label ('Page 6 pop')),
    4);;

my $child2 = label ('Page 2c');
is ($nb->insert_page_menu ($child2, label ('Page 2 pop'), undef, 1), 1);

is ($nb->insert_page (label ('remove'), label ('remove'), 7), 6);
is ($nb->insert_page (label ('remove'), label ('remove'), 7), 7);
is ($nb->insert_page (label ('remove'), label ('remove'), 0), 0);

$nb->remove_page(7);
ok(1);
$nb->remove_page(0);
ok(1);
$nb->remove_page(-1);
ok(1);

foreach (qw/left right bottom top/)
{
	$nb->set_tab_pos($_);
	ok(1);

	ok( $nb->get_tab_pos eq $_ );
}

$nb->set_show_tabs(0);
ok(1);
ok( ! $nb->get_show_tabs );

$nb->set_show_tabs(1);
ok(1);
ok( $nb->get_show_tabs );

$nb->set_show_border(0);
ok(1);
ok( ! $nb->get_show_border );

$nb->set_show_border(1);
ok(1);
ok( $nb->get_show_border );

$nb->set_scrollable(1);
ok(1);
ok( $nb->get_scrollable );

$nb->set_scrollable(0);
ok(1);

$nb->popup_disable;
ok(1);

$nb->popup_enable;
ok(1);
ok( ! $nb->get_scrollable );

# in reality this one is only in gtk2.2+, but it's been implemented in
# the xs wrapper since it's trivial anyway
ok( $nb->get_n_pages == 6 );

$nb->set_menu_label($child2, Gtk2::Label->new('re-set'));
ok(1);
ok( $nb->get_menu_label($child2)->get_text eq 're-set');

$nb->set_menu_label_text($child2, 're-set2');
ok(1);
ok( $nb->get_menu_label_text($child2) eq 're-set2');

$nb->set_tab_label($child, Gtk2::Label->new('re-set'));
ok(1);
ok( $nb->get_tab_label($child)->get_text eq 're-set' );

$nb->set_tab_label_text($child, 're-set2');
ok(1);
ok( $nb->get_tab_label_text($child) eq 're-set2' );

ok( $nb->get_nth_page(1)->get_text eq 'Page 2c' );

is_deeply( [ $nb->query_tab_label_packing($child) ],
	   [ FALSE, TRUE, 'start' ] );

$nb->set_tab_label_packing($child, 1, 0, 'end');
ok(1);
is_deeply( [ $nb->query_tab_label_packing($child) ],
	   [ TRUE, FALSE, 'end' ] );

$win->show_all;
ok(1);
run_main sub {
		$nb->next_page;
		ok(1);
		$nb->prev_page;
		ok(1);
		ok( (my $index = $nb->page_num($child)) == 3 );
		$nb->reorder_child($child, 0);
		ok(1);
		$nb->reorder_child($child, $index);

		ok( $nb->get_current_page == 0 );

		$nb->next_page;
		ok(1);
		ok( $nb->get_current_page == 1 );

		$nb->set_current_page(4);
       		ok(1);
		ok( $nb->get_current_page == 4 );
};

ok(1);

__END__

Copyright (C) 2003-2005 by the gtk2-perl team (see the file AUTHORS for the
full list).  See LICENSE for more information.
