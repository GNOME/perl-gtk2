#!/usr/bin/perl -w
#
# $Header$
#


package Foo;

use Data::Dumper;
use Gtk2;

warn Dumper(\@ARGV);
die "can't initialize Gtk; if this program was really cool, i'd open up
a text-mode UI for you... but this is a GUI test, so i won't.\n"
	unless Gtk2->init_check;

warn "Gtk2->init_check worked\n";
warn Dumper(\@ARGV);

# un comment this to see some weird focus stuff happening
#my $window = Gtk2::Window->new("toplevel");
#$window->show;

$dialog = Gtk2::MessageDialog->new (undef, [], 'info', 'ok', 'hello world');
$dialog->show;
# this should croak
eval {
	$dialog->set_data ('private', 'foo');
};
$dialog->set_data (private => 42);
print "data: ".$dialog->get_data ('private')."\n";
$foo = $dialog->get_data ('private');
print "$foo\n";
$foo = undef;
print "data: ".$dialog->get_data ('private')."\n";
$handler = $dialog->signal_connect (response => sub { Gtk2->main_quit; 1 }, undef);
print "handler $handler\n";

@properties = $dialog->list_properties;
print Dumper (\@properties);

print "  message-type: ".$dialog->get ('message-type')."\n";
print " has-separator: ".$dialog->get ('has-separator')."\n";
print "       buttons: ".$dialog->get ('buttons')."\n";
print "  border-width: ".$dialog->get ('border-width')."\n";

print "setting has-separator to 0...\n";
$dialog->set ('has-separator', 0);
print " has-separator: ".$dialog->get ('has-separator')."\n";

print "setting message-type to 'error'...\n";
$dialog->set ('message-type', 'error');
print "  message-type: ".$dialog->get ('message-type')."\n";

$child = $dialog->get ('child');
print "   child: $child\n";
$child = undef;

$style = $dialog->get ('style');
print "   style: $style\n";
$style = undef;
$style = $dialog->get ('style');
print "   style: $style\n";
$style = undef;

$icon = $dialog->get ('icon');
print "   icon: $icon\n";
$icon = undef;
$icon = $dialog->get ('icon');
print "   icon: $icon\n";
$icon = undef;

$window_position = $dialog->get ('window-position');
print "   window-position: $window_position\n";
$window_position = undef;
$window_position = $dialog->get ('window-position');
print "   window-position: $window_position\n";
$window_position = undef;


print "  message-type: ".$dialog->get ('message-type')."\n";
print " has-separator: ".$dialog->get ('has-separator')."\n";
print "       buttons: ".$dialog->get ('buttons')."\n";
print "  border-width: ".$dialog->get ('border-width')."\n";
$dialog->set (message_type => 'error',
              has_separator => 1,
	      buttons => 'ok-cancel',
	      border_width => 15,);
print join("\n+", $dialog->get (qw/ message-type has-separator buttons border-width/))."\n";

print Dumper($dialog->allocation);
#print Dumper($dialog->size_request);

Gtk2->main;

$dialog->destroy;
$dialog = undef;

__END__
$button->emit ('clicked');
