#!/usr/bin/perl -w

use Gtk2 -init;

die "This example requires gtk+ 2.4.0, but we're compiled for "
  . join (".", Gtk2->get_version_info)."\n"
	unless Gtk2->CHECK_VERSION (2,3,0); # FIXME 2.4

my $preview_widget = Gtk2::Label->new ('wheeeee');
$preview_widget->set_line_wrap (1);
$preview_widget->set_size_request (150, -1);

my $file_chooser =
	Gtk2::FileChooserDialog->new ('This is the spiffy new file chooser!',
	                              undef, 'open',
	                              'gtk-cancel' => 'cancel',
                                      'gtk-ok' => 'ok');
$file_chooser->set (preview_widget => $preview_widget,
                    preview_widget_active => 1);
$file_chooser->signal_connect (selection_changed => sub {
	use Data::Dumper;
	print Dumper(\@_);
	my $filename = $file_chooser->get_preview_filename;
	my $active = defined $filename && not -d $filename;
	if ($active) {
		my $size = sprintf '%.1fK', (-s $filename) / 1024;
		my $desc = `file '$filename'`;
		$desc =~ s/^$filename:\s*//;
		$preview_widget->set_text ("$size\n$desc");
	}
	$file_chooser->set (preview_widget_active => $active);
});

$file_chooser->add_shortcut_folder ('/home/scott/gtk2-perl-xs');
$file_chooser->add_shortcut_folder ('/var/www/html');
eval { $file_chooser->add_shortcut_folder_uri ('http://localhost/'); };

while ('ok' eq $file_chooser->run) {
	my $uri = $file_chooser->get_uri;
	print "uri $uri\n";
	my $filename = $file_chooser->get_filename;
	print "filename $filename\n";
	last;
}

$file_chooser->destroy;
