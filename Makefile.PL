# Copyright (C) 2003 by the gtk2-perl team (see the file AUTHORS for the full
# list)
# 
# This library is free software; you can redistribute it and/or modify it under
# the terms of the GNU Library General Public License as published by the Free
# Software Foundation; either version 2.1 of the License, or (at your option)
# any later version.
# 
# This library is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
# FOR A PARTICULAR PURPOSE.  See the GNU Library General Public License for
# more details.
# 
# You should have received a copy of the GNU Library General Public License
# along with this library; if not, write to the Free Software Foundation, Inc.,
# 59 Temple Place - Suite 330, Boston, MA  02111-1307  USA.
#
# $Header$
#

use 5.008;
use strict;
use warnings;
# use only standard modules here!  any non-standard module, or anything which is
# a dependency which may not be installed, should be use'd from the dependency
# test eval, below.
use ExtUtils::MakeMaker;
use File::Spec;
use Cwd;

# minimum required version of dependancies we need to build
our %build_reqs = (
	'perl-ExtUtils-Depends'   => '0.1',
	'perl-ExtUtils-PkgConfig' => '1.00',
	'perl-Glib'               => '1.012',
	'Gtk+'                    => '2.0.0',
);

# minimum required version of dependancies we need to run
our %runtime_reqs = (
	'Gtk+'	=> undef,
);

# Writing a fake Makefile ensures that CPAN will pick up the correct
# dependencies and install them.
unless (eval "use ExtUtils::Depends;"
           . "use ExtUtils::PkgConfig;"
	   . "use Glib '$build_reqs{'perl-Glib'}';"
           . "use Glib::MakeHelper;" # for do_pod_files()
           . "1") {
   warn "$@\n";
   WriteMakefile(
         PREREQ_FATAL => 1,
         PREREQ_PM    => {
            'ExtUtils::Depends'   => $build_reqs{'perl-ExtUtils-Depends'},
            'ExtUtils::PkgConfig' => $build_reqs{'perl-ExtUtils-PkgConfig'},
            'Glib'                => $build_reqs{'perl-Glib'},
         },
   );
   exit 1; # not reached
}

require 'CodeGen.pm'; # other modules can should 'use Gtk2::CodeGen;' --
                      # we can't because it's not installed yet.

# all the generated stuff will go into this subdir...
mkdir 'build', 0777;

my %pkgcfg = ExtUtils::PkgConfig->find ('gtk+-2.0 >= '.$build_reqs{'Gtk+'});

# we know what version we're going to be built against now
$runtime_reqs{'Gtk+'} = $pkgcfg{modversion};

#
# decide what files to use in the build based on the version we found.
#
my @gtk_version = split /\./, $pkgcfg{modversion};
our @xs_files = ();
our @lists = ('xs_files-2.0');
push @lists, 'xs_files-2.2' if $gtk_version[1] >= 2;
foreach my $filename (@lists) {
	my @names = read_source_list_file ($filename);
	print "$filename lists ".scalar(@names)." xs files\n";
	push @xs_files, @names;
}

#
# since we've started down the dark path of breaking from standard 
# MakeMaker, forever will it dominate our destiny; we must specify
# install paths for the modules and man files by hand.
#
our %pm_files = (
	'Gtk2.pm'          => '$(INST_LIBDIR)/Gtk2.pm',
	'build/Keysyms.pm' => '$(INST_LIBDIR)/Gtk2/Gdk/Keysyms.pm',
	'CodeGen.pm'       => '$(INST_LIBDIR)/Gtk2/CodeGen.pm',
	'pm/Helper.pm'     => '$(INST_LIBDIR)/Gtk2/Helper.pm',
	'pm/Pango.pm'      => '$(INST_LIBDIR)/Gtk2/Pango.pm',
	'pm/SimpleList.pm' => '$(INST_LIBDIR)/Gtk2/SimpleList.pm',
	'pm/SimpleMenu.pm' => '$(INST_LIBDIR)/Gtk2/SimpleMenu.pm',
	'api.pod'          => '$(INST_LIBDIR)/Gtk2/api.pod',
	'devel.pod'        => '$(INST_LIBDIR)/Gtk2/devel.pod',
);
our %pod_files = (
	'Gtk2.pm'          => '$(INST_MAN3DIR)/Gtk2.$(MAN3EXT)',
	'build/Keysyms.pm' => '$(INST_MAN3DIR)/Gtk2::Gdk::Keysyms.$(MAN3EXT)',
	'CodeGen.pm'       => '$(INST_MAN3DIR)/Gtk2::CodeGen.$(MAN3EXT)',
	'pm/Helper.pm'     => '$(INST_MAN3DIR)/Gtk2::Helper.$(MAN3EXT)',
	'pm/Pango.pm'      => '$(INST_MAN3DIR)/Gtk2::Pango.$(MAN3EXT)',
	'pm/SimpleList.pm' => '$(INST_MAN3DIR)/Gtk2::SimpleList.$(MAN3EXT)',
	'pm/SimpleMenu.pm' => '$(INST_MAN3DIR)/Gtk2::SimpleMenu.$(MAN3EXT)',
	'api.pod'          => '$(INST_MAN3DIR)/Gtk2::api.$(MAN3EXT)',
	'devel.pod'        => '$(INST_MAN3DIR)/Gtk2::devel.$(MAN3EXT)',
	# we will be installing a whole slew of pod files, generated directly
	# from the xs source -- but to have them installed and manified
	# properly, we have to know their names at Makefile.PL time.
	#   This is a bit of a chicken and egg problem, and this solution
	# basically means that if you create a new package name in the xs
	# code, you'll need to re-run Makefile.PL.  you already need to
	# re-run to pick up new XS files, so that's not such a big deal. 
	Glib::MakeHelper->do_pod_files (@xs_files),
);

#
# autogeneration
#
# we have a whole lot of types which need cast macros, typemap entries,
# and package mapping registration; instead of writing this by hand, we
# use a map file which defines how things are laid out, and then use
# some boilerplate code to convert that map into a header, typemap, and
# xsh file.  see the docs for Gtk2::CodeGen for more info.
#
# we'll use all the default filenames.
#
Gtk2::CodeGen->parse_maps ('gtk2perl');

# one more command generates code to boot all the various extra XS modules.
# we need this because we have lots of XS files without corresponding PMs to
# bootstrap them.
Gtk2::CodeGen->write_boot (xs_files => \@xs_files);

# this one turns the long list of #defines in gdkkeysyms.h into a large
# hash of key names and values, %Gtk2::Gdk::Keysyms.
system "$^X genkeysyms.pl >\"build/Keysyms.pm\""; # the "" are essential for command.com

#
# now we're ready to start creating the makefile... finally.
# we need to use ExtUtils::Depends to get relevant information out of
# the Glib extension, and to save config information for other modules which
# will chain from this one.
#

my $gtk2 = ExtUtils::Depends->new ('Gtk2', 'Glib');
# Glib added -I. for us, but we'll need to add -I./build so we can get to
# the autogenerated files.  we do this kindof as a public service to client
# modules, as these will carry through via the depends mechanism.
$gtk2->set_inc ($pkgcfg{cflags} . ' -I./build ');
$gtk2->set_libs ($pkgcfg{libs} . find_extra_libs());
$gtk2->add_pm (%pm_files);
$gtk2->add_xs (@xs_files);
my $cwd = cwd();
$gtk2->add_typemaps (map {File::Spec->catfile($cwd,$_)}
		     'build/gtk2perl.typemap',
                     'gdk.typemap', 'gtk.typemap',
		     );
$gtk2->add_headers ('gtk2perl.h');

$gtk2->install (qw(gtk2perl.h build/gtk2perl-autogen.h));
$gtk2->save_config ('build/IFiles.pm');

# exports list needed for win32, unused on others
our @exports;
require 'Gtk2.exports';

WriteMakefile(
    NAME          => 'Gtk2',
    VERSION_FROM  => 'Gtk2.pm', # finds $VERSION
    ABSTRACT_FROM => 'Gtk2.pm', # retrieve abstract from module
    XSPROTOARG    => '-noprototypes',
    MAN3PODS      => \%pod_files,
    FUNCLIST      => \@exports,
    DL_FUNCS      => { Gtk2 => [] },
    $gtk2->get_makefile_vars,
);

#
# extra makefile override stuff... watch for falling wizardry.
#

sub MY::postamble
{
	my $text = "DOC_PL_DEPENDS=build/stock_items.podi\n\n"
		 . Glib::MakeHelper->postamble_clean ()
	         . Glib::MakeHelper->postamble_docs (@xs_files)
	         . Glib::MakeHelper->postamble_rpms (
			'GTK_RUN' => $runtime_reqs{'Gtk+'},
			'GTK' => $build_reqs{'Gtk+'},
			'PERL_EXTUTILS_DEPENDS' => 
				$build_reqs{'perl-ExtUtils-Depends'},
			'PERL_EXTUTILS_PKGCONFIG' => 
				$build_reqs{'perl-ExtUtils-PkgConfig'},
			'PERL_GLIB' => $build_reqs{'perl-Glib'},
	           );
	
	$text .= " 
# rebuild the makefile if the file lists change
Makefile : ".join(" ", @lists)."

build/stock_items.podi: podifystockitems.pl
	\$(PERL) -I \$(INST_LIB) -I \$(INST_ARCHLIB) \$< > \$@

";

	# this installation stuff doesn't make sense on windows, where
	# we don't really have a /usr.  also, nmake barfs on $+.
	unless ($^O eq 'MSWin32') {
		$text .= "
# the tmp-xxx stuff is just so that only the pl files get installed
install-\%: %
	\@\$(MKPATH) tmp-\$+/
	\@\$(CP) \$+/*.* tmp-\$+/
	\@\$(MOD_INSTALL) ./tmp-\$+/ \\
		\$(PREFIX)/share/doc/perl-\$(DISTNAME)/\$+
	\@\$(RM_RF) tmp-\$+/
";
	}

	return $text;
}

# this probably needs to go into ExtUtils::Depends.
sub find_extra_libs {
	# right now we need this terrible hack only for windows.
	return "" unless $^O eq "MSWin32";

	# win32 does not allow unresolved symbols in libraries, but
	# Gtk2 uses on symbols in the dll created for Glib.
	# so, we have to break all this nice abstraction and encapsulation
	# and find the actual Glib.dll and Glib.lib installed by perl when
	# the Glib module was built, and add it to the list of lib files.
	#
	# say it with me: "i hate win32."

	my $retstring = "";

	use File::Find;
	find (sub {
			$retstring .= " ".$File::Find::name
				if /Glib.lib/i;
		}, @INC);

	return $retstring;
}

sub read_source_list_file {
	my $filename = shift;
	my @list = ();
	open IN, $filename or die "can't read $filename: $!\n";
	while (<IN>) {
		s/#.*$//;		# eat comments
		s/^\s*//;		# trim leading space
		s/\s*$//;		# trim trailing space
		push @list, $_ if $_;	# keep non-blanks
	}
	close IN;
	return @list;
}
