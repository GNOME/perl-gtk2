#!/usr/bin/perl -w

use strict;
use Test::More;
use Data::Dumper;
use Gtk2 -init;

if (2 > (Gtk2->get_version_info)[1]) {
	plan (skip_all => "GtkClipboard didn't exist in 2.0.x");
} else {
	plan (tests => 22);
}

require './t/ignore_keyboard.pl';

my $clipboard = Gtk2::Clipboard->get (Gtk2::Gdk->SELECTION_PRIMARY);

print Dumper( $clipboard );
isa_ok ($clipboard, 'Gtk2::Clipboard');

my $text;
#$text = $clipboard->wait_for_text;
#if (defined $text) {
#	$text =~ s/\r/\\r/gm;
#	$text =~ s/\n/\\n/gm;
#}
#print Dumper( $clipboard->wait_for_text );

my $expect = '0123456789abcdef';

$clipboard->set_text ($expect);

$text = $clipboard->wait_for_text;
is ($text, $expect);

$clipboard->request_text (sub {
	# print "hello from the callback\n" . Dumper(\@_);
	is ($_[0], $clipboard);
	is ($_[1], $expect);
	is ($_[2], 'user data!');
}, 'user data!');

$clipboard->request_contents (Gtk2::Gdk->SELECTION_TYPE_STRING, sub {
	#print "hello from the callback\n" . Dumper(\@_);
	is ($_[0], $clipboard);
	isa_ok ($_[1], 'Gtk2::SelectionData');
	is ($_[2], 'user data!');
	is ($_[1]->get_text, $expect);
}, 'user data!');


Glib::Timeout->add (200, sub {Gtk2->main_quit;1});
Gtk2->main;

print "----------------------------------\n";

$expect = 'whee';

sub get_func { ok (1, "get_func"); $_[1]->set_text ($expect); }
sub clear_func {
	ok (1, "clear_func");
	$_[1]->set_text ('') if UNIVERSAL::isa ($_[1], 'Gtk2::SelectionData');
}
sub received_func {
	ok (1, "received_func");
	is ($_[1]->get_text, $expect); }

# set the selection multiple times to make sure we don't crash on 
# replacing all the GPerlCallbacks.

$clipboard->set_with_data (\&get_func, \&clear_func, 'user data, yo',
	{target=>'TEXT'}, {target=>'STRING'}, {target=>'COMPOUND_TEXT'},
);

ok(1);

$clipboard->set_with_data (\&get_func, \&clear_func, 'user data, yo',
	{target=>'TEXT'}, {target=>'STRING'}, {target=>'COMPOUND_TEXT'},
);

ok(1);

$clipboard->set_with_data (\&get_func, \&clear_func, 'user data, yo',
	{target=>'TEXT'}, {target=>'STRING'}, {target=>'COMPOUND_TEXT'},
);

ok(1);

$clipboard->request_contents (Gtk2::Gdk->SELECTION_TYPE_STRING,
			      \&received_func, 'user data!');

Glib::Timeout->add (200, sub {Gtk2->main_quit;1});
Gtk2->main;

my $widget = Gtk2::Window->new;
$clipboard->set_with_owner (\&get_func, \&clear_func, $widget,
	{target=>'TEXT'}, {target=>'STRING'}, {target=>'COMPOUND_TEXT'},
);

is ($clipboard->get_owner, $widget);

$clipboard->request_contents (Gtk2::Gdk->SELECTION_TYPE_STRING,
                              \&received_func, 'user data!');

Glib::Timeout->add (200, sub {Gtk2->main_quit;1});
Gtk2->main;
