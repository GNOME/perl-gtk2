#!/usr/bin/perl -w
# vim: set ft=perl :
use Gtk2::TestHelper tests => 95,
	at_least_version => [2, 2, 0, "GtkClipboard didn't exist in 2.0.x"];

# $Header$

my $clipboard;

SKIP: {
	skip "GdkDisplay is new in 2.2", 1
		unless Gtk2->CHECK_VERSION (2, 2, 0);

	my $display = Gtk2::Gdk::Display->get_default;

	$clipboard = Gtk2::Clipboard->get_for_display (
		$display,
		Gtk2::Gdk->SELECTION_CLIPBOARD);

	isa_ok ($clipboard, 'Gtk2::Clipboard');
	is ($clipboard->get_display, $display);
}

$clipboard = Gtk2::Clipboard->get (Gtk2::Gdk->SELECTION_PRIMARY);
isa_ok ($clipboard, 'Gtk2::Clipboard');

my $expect = '0123456789abcdef';

$clipboard->set_text ($expect);

my $text = $clipboard->wait_for_text;
is ($text, $expect);

is ($clipboard->wait_is_text_available, 1);

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


SKIP: {
	skip 'request_targets and wait_for_targets are new in 2.4', 4
		unless Gtk2->CHECK_VERSION (2, 4, 0);

	$clipboard->request_targets (sub {
		is ($_[0], $clipboard);
		isa_ok ($_[1], "ARRAY");
		isa_ok ($_[1][0], "Gtk2::Gdk::Atom");
		is ($_[2], "bla");
	}, "bla");
}

SKIP: {
	skip 'new/now-working targets stuff', 2
		unless Gtk2->CHECK_VERSION (2, 6, 0);

	is ($clipboard->wait_is_target_available (Gtk2::Gdk::Atom->intern ('TEXT')), TRUE);
	isa_ok (($clipboard->wait_for_targets)[0], 'Gtk2::Gdk::Atom');
}

SKIP: {
	skip "new image stuff", 5
		# Some of this was broken in 2.6.0
		unless Gtk2->CHECK_VERSION (2, 6, 1);

	my $pixbuf = Gtk2::Gdk::Pixbuf->new ("rgb", FALSE, 8, 23, 42);
	$clipboard->set_image ($pixbuf);

	is ($clipboard->wait_is_image_available, TRUE);

	isa_ok ($clipboard->wait_for_image, "Gtk2::Gdk::Pixbuf");
	$clipboard->request_image (sub {
		is ($_[0], $clipboard);
		isa_ok ($_[1], "Gtk2::Gdk::Pixbuf");
		is ($_[2], "bla");
	}, "bla");
}

SKIP: {
        skip "new stuff in 2.10", 6
                unless Gtk2->CHECK_VERSION (2, 10, 0);

	my $buffer = Gtk2::TextBuffer->new;
	$buffer->insert ($buffer->get_start_iter, 'bla!');
	$buffer->register_serialize_format (
		'text/rdf',
		sub { warn "here"; return 'bla!'; });
	$buffer->register_deserialize_format (
		'text/rdf',
		sub { warn "here"; $_[1]->insert ($_[2], 'bla!'); });

	$clipboard->request_rich_text ($buffer, sub {
		# print "hello from the callback\n" . Dumper(\@_);
		is ($_[0], $clipboard);
		is ($_[1]->name, 'text/rdf');
		is ($_[2], undef); # FIXME
		is ($_[3], 'user data!');
	}, 'user data!');

	# FIXME
	ok (!$clipboard->wait_is_rich_text_available ($buffer));
	is ($clipboard->wait_for_rich_text ($buffer), undef);
}

Glib::Timeout->add (200, sub {Gtk2->main_quit;1});
Gtk2->main;

#print "----------------------------------\n";

$expect = 'whee';

sub get_func {
	is ($_[0], $clipboard);
	isa_ok ($_[1], 'Gtk2::SelectionData');
	is ($_[2], 0);
	ok ($_[3]);

	# Tests for Gtk2::SelectionData:

	$_[1]->set (Gtk2::Gdk->TARGET_STRING, 8, 'bla blub');

	is ($_[1]->selection->name, 'PRIMARY');
	ok (defined $_[1]->target->name);
	is ($_[1]->type->name, 'STRING');
	is ($_[1]->format, 8);
	is ($_[1]->data, 'bla blub');
	is ($_[1]->length, 8);

	SKIP: {
		skip 'GdkDisplay is new in 2.2', 1
			unless Gtk2->CHECK_VERSION (2, 2, 0);

		isa_ok ($_[1]->display, 'Gtk2::Gdk::Display');
	}

	# FIXME: always empty and false?
	# warn $_[1]->get_targets;
	# warn $_[1]->targets_include_text;

	$_[1]->set_text ($expect);
	is ($_[1]->get_text, $expect);

	is ($_[1]->data, $expect);
	is ($_[1]->length, length ($expect));

	SKIP: {
		skip '2.6 stuff', 7
			unless Gtk2->CHECK_VERSION (2, 6, 0);

		# This won't work with a STRING selection, but I don't know
		# what else to use, so we just check that both operations fail.
		my $pixbuf = Gtk2::Gdk::Pixbuf->new ('rgb', FALSE, 8, 23, 42);
		is ($_[1]->set_pixbuf ($pixbuf), FALSE);
		is ($_[1]->get_pixbuf, undef);

		# Same here.
		is ($_[1]->set_uris, FALSE);
		is_deeply ([$_[1]->get_uris], []);
		is ($_[1]->set_uris (qw(a b c)), FALSE);
		is_deeply ([$_[1]->get_uris], []);

		is ($_[1]->targets_include_image (TRUE), FALSE);
	}

	SKIP: {
		skip '2.10 stuff', 2
			unless Gtk2->CHECK_VERSION (2, 10, 0);

		is ($_[1]->targets_include_uri, FALSE);

		my $buffer = Gtk2::TextBuffer->new;
		$buffer->register_deserialize_format (
			'text/rdf',
			sub { warn "here"; $_[1]->insert ($_[2], 'bla!'); });
		is ($_[1]->targets_include_rich_text ($buffer), FALSE);
	}
}

sub clear_func {
	is (shift, $clipboard);
	ok (shift);
}

sub received_func {
	is ($_[0], $clipboard);
	isa_ok ($_[1], 'Gtk2::SelectionData');
	is ($_[2], 'user data!');

	is ($_[1]->get_text, $expect);
}

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

SKIP: {
	skip "new 2.6 stuff", 0
		unless Gtk2->CHECK_VERSION (2, 6, 0);

	$clipboard->set_can_store ({target=>'STRING'}, {target=>'TEXT'});
        $clipboard->set_can_store;

        $clipboard->store;
}

$clipboard->clear;

__END__

Copyright (C) 2003-2006 by the gtk2-perl team (see the file AUTHORS for the
full list).  See LICENSE for more information.
