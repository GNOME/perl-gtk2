#
# $Header$
#

#########################
# GtkCalendar Tests
# 	- rm
#########################

use Gtk2::TestHelper tests => 11;

ok( my $win = Gtk2::Window->new() );
$win->set_border_width(10);

ok( my $cal = Gtk2::Calendar->new );
$win->add($cal);

$cal->freeze;

$cal->select_month (11, 2003);
$cal->select_day (4);
foreach (qw/6 13 20 27 7 14 21 28 25/)
{
	$cal->mark_day ($_);
}

$cal->thaw;

is ($cal->num_marked_dates, 9);
$cal->mark_day (24);
is ($cal->num_marked_dates, 10);
$cal->unmark_day (24);
is ($cal->num_marked_dates, 9);

ok (eq_array ([ $cal->marked_date ], 
		[ 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 
		1, 1, 0, 0, 0, 1, 0, 1, 1, 0, 0, 0]));

$cal->clear_marks;
is ($cal->num_marked_dates, 0);

is ($cal->year, 2003);
is ($cal->month, 11);
is ($cal->selected_day, 4);
ok (eq_array ([ $cal->get_date ], [ 2003, 11, 4 ]));

$cal->display_options (qw/show-day-names/);

$win->show_all;

Glib::Idle->add( sub {
		Gtk2->main_quit;
		0;
	} );

Gtk2->main;

1;

__END__

Copyright (C) 2003 by the gtk2-perl team (see the file AUTHORS for the
full list) See LICENSE for more information.
