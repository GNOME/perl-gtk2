#!/usr/bin/perl -w

@dirs = map {s/-I//; $_} grep /-I/, split /\s+/, `pkg-config gtk+-2.0 --cflags`;
#print join("\n", @dirs, "\n");
foreach (@dirs) {
	if (-f "$_/gdk/gdkkeysyms.h") {
		print "# generated "
		    . scalar(localtime)
		    . " from $_/gdk/gdkkeysyms.h\n";
		open IN, "$_/gdk/gdkkeysyms.h" 
			or die "can't read $_/gdk/gdkkeysyms.h: $!\n";
		print "package Gtk2::Gdk::Keysyms;\n";
		print "\%Gtk2::Gdk::Keysyms = (\n";
		while (<IN>) {
			/^#define\sGDK_([^ \t]*)\s+(0x[0-9A-Fa-f]+)/ and
				print "   '$1' => $2,\n";
		}
		print ");\n";
		print "1;\n";
		close IN;
		last;
	}
}
