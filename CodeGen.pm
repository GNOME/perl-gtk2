package Gtk2::CodeGen;

use strict;
use warnings;
use Carp;
use IO::File;

=head1 NAME

Gtk2::CodeGen - code generation utilities for Glib-based bindings.

=head1 SYNOPSIS

 # usually in Makefile.PL
 use Gtk2::CodeGen;

 # most common, use all defaults
 Gtk2::CodeGen->parse_maps ('myprefix');
 Gtk2::CodeGen->write_boot;

 # more exotic, change everything
 Gtk2::CodeGen->parse_maps ('foo',
                            input => 'foo.maps',
                            header => 'foo-autogen.h',
                            typemap => 'foo.typemap',
                            register => 'register-foo.xsh');
 Gtk2::CodeGen->write_boot (filename => 'bootfoo.xsh',
                            glob => 'Foo*.xs',
                            ignore => '^(Foo|Foo::Bar)$');
 
=head1 DESCRIPTION

This module packages some of the boilerplate code needed for performing code
generation typically used by perl bindings for gobject-based libraries, using
the Glib module as a base.

The default output filenames are in the subdirectory 'build', which usually
will be present if you are using ExtUtils::Depends (as most Glib-based
extensions probably should).

=head2 METHODS

=over

=item Gtk2::CodeGen->write_boot;

=item Gtk2::CodeGen->write_boot (KEY => VAL, ...)

Many GObject-based libraries to be bound to perl will be too large to put in
a single XS file; however, a single PM file typically only bootstraps one
XS file's code.  C<write_boot> generates an XSH file to be included from
the BOOT section of that one bootstrapped module, calling the boot code for
all the other XS files in the project.

Options are passed to the function in a set of key/val pairs, and all options
may default.

  filename     the name of the output file to be created.
               the default is 'build/boot.xsh'.

  glob         a glob pattern that specifies the names of
               the xs files to scan for MODULE lines.
               the default is 'xs/*.xs'.

  xs_files     use this to supply an explicit list of file
               names (as an array reference) to use instead
               of a glob pattern.  the default is to use
               the glob pattern.

  ignore       regular expression matching any and all 
               module names which should be ignored, i.e.
               NOT included in the list of symbols to boot.
               this parameter is extremely important for
               avoiding infinite loops at startup; see the
               discussion for an explanation and rationale.
               the default is '^[^:]+$', or, any name that
               contains no colons, i.e., any toplevel
               package name.


This function performs a glob (using perl's builtin glob operator) on the
pattern specified by the 'glob' option to retrieve a list of file names.
It then scans each file in that list for lines matching the pattern
"^MODULE" -- that is, the MODULE directive in an XS file.  The module
name is pulled out and matched against the regular expression specified
by the ignore parameter.  If this module is not to be ignored, we next
check to see if the name has been seen.  If not, the name will be converted
to a boot symbol (basically, s/:/_/ and prepend "boot_") and this symbol
will be added to a call to GPERL_CALL_BOOT in the generated file; it is then
marked as seen so we don't call it again.


What is this all about, you ask?  In order to bind an XSub to perl, the C
function must be registered with the interpreter.  This is the function of the
"boot" code, which is typically called in the bootstrapping process.  However,
when multiple XS files are used with only one PM file, some other mechanism
must call the boot code from each XS file before any of the function therein
will be available.

A typical setup for a multiple-XS, single-PM module will be to call the 
various bits of boot code from the BOOT: section of the toplevel module's
XS file.

To use Gtk2 as an example, when you do 'use Gtk2', Gtk2.pm calls bootstrap
on Gtk2, which calls the C function boot_Gtk2.  This function calls the
boot symbols for all the other xs files in the module.  The distinction
is that the toplevel module, Gtk2, has no colons in its name.


C<xsubpp> generates the boot function's name by replacing the 
colons in the MODULE name with underscores and prepending "boot_".
We need to be careful not to include the boot code for the bootstrapped module,
(say Toplevel, or Gtk2, or whatever) because the bootstrap code in 
Toplevel.pm will call boot_Toplevel when loaded, and boot_Toplevel
should actually includes the file we are creating here.

The default value for the ignore parameter ignores any name not containing
colons, because it is assumed that this will be a toplevel module, and any
other packages/modules it boots will be I<below> this namespace, i.e., they
will contain colons.  This assumption holds true for Gtk2 and Gnome2, but
obviously fails for something like Gnome2::Canvas.  To boot that module
properly, you must use a regular expression such as "^Gnome2::Canvas$".

Note that you can, of course, match more than just one name, e.g.
"^(Foo|Foo::Bar)$", if you wanted to have Foo::Bar be included in the same
dynamically loaded object but only be booted when absolutely necessary.
(If you get that to work, more power to you.)

Also, since this code scans for ^MODULE, you must comment the MODULE section
out with leading # marks if you want to hide it from C<write_boot>.

=cut
sub write_boot {
	my $class = shift;
	my %opts = (
		ignore => '^[^:]+$',	# ignore package with no colons in it
		filename => 'build/boot.xsh',
		'glob' => 'xs/*.xs',
		@_,
	);
	my $ignore = $opts{ignore};

	my $file = IO::File->new (">$opts{filename}")
		or carp "Cannot write $opts{filename}: $!"; 

	print $file "\n\n/* This file is automatically generated, any changes made here will be lost! */\n\n";

	my %boot=();

	my @xs_files = 'ARRAY' eq ref $opts{xs_files}
	             ? @{ $opts{xs_files} }
	             : glob $opts{'glob'};

	foreach my $xsfile (@xs_files) {
		my $in = IO::File->new ($xsfile)
				or die "can't open $xsfile: $!\n";

		while (<$in>) {
			next unless m/^MODULE\s*=\s*(\S+)/;
			#warn "found $1 in $&\n";

			my $package = $1;
			
			next if $package =~ m/$ignore/;

			$package =~ s/:/_/g;
			my $sym = "boot_$package";
			print $file "GPERL_CALL_BOOT ($sym);\n"
				unless $boot{$sym};
			$boot{$sym}++;
		}

		close $in;
	}

	close $file;
}


=item Gtk2::CodeGen->parse_maps (PREFIX, [KEY => VAL, ...])

Convention within Glib/Gtk2 and friends is to use preprocessor macros in the
style of SvMyType and newSVMyType to get values in and out of perl, and to
use those same macros from both hand-written code as well as the typemaps.
However, if you have a lot of types in your library (such as the nearly 200
types in Gtk+ 2.x), then writing those macros becomes incredibly tedious, 
especially so when you factor in all of the variants and such.

So, this function can turn a flat file containing terse descriptions of the
types into a header containing all the cast macros, a typemap file using them,
and an XSH file containing the proper code to register each of those types
(to be included by your module's BOOT code).

The I<PREFIX> is mandatory, and is used in some of the resulting filenames,
You can also override the defaults by providing key=>val pairs:

  input    input file name.  default is 'maps'.  if this
           key's value is an array reference, all the
           filenames in the array will be scanned.
  header   name of the header file to create, default is
           build/$prefix-autogen.h
  typemap  name of the typemap file to create, default is
           build/$prefix.typemap
  register name of the xsh file to contain all of the 
           type registrations, default is build/register.xsh

the maps file is a table of type descriptions, one per line, with fields
separated by whitespace.  the fields should be:

  TYPE macro    e.g., GTK_TYPE_WIDGET 
  class name    e.g. GtkWidget, name of the C type
  base type     one of GObject, GBoxed, GEnum, GFlags.
                GtkObject is also supported, but the
                distinction is no longer necessary as
                of Glib 0.26.
  package       name of the perl package to which this
                class name should be mapped, e.g.
                Gtk2::Widget

=cut


# guh... communication with the helper functions.
my (@header, @typemap, @input, @output, @boot);


sub parse_maps {
	my $class = shift;
	my $prefix = shift;
	my %props = (
		input => 'maps',
		header => "build/$prefix-autogen.h",
		typemap => "build/$prefix.typemap",
		register => 'build/register.xsh',
		@_,
	);

	local *IN;
	local *OUT;

	my %seen = ();

	@header = ();
	@typemap = ();
	@input = ();
	@output = ();
	@boot = ();

	my @files = 'ARRAY' eq ref $props{input}
	          ? @{ $props{input} }
	          : $props{input};

	foreach my $file (@files) {
	    open IN, "< $file"
		or die "can't open $file for reading: $!\n";

	    my $n = 0;

	    while (<IN>) {
		chomp;
		s/#.*//;
		my ($typemacro, $classname, $base, $package) = split;
		next unless defined $package;
		if ($base eq 'GEnum') {
			gen_enum_stuff ($typemacro, $classname, $package);
			$seen{$base}++;
		
		} elsif ($base eq 'GFlags') {
			gen_flags_stuff ($typemacro, $classname, $package);
			$seen{$base}++;
		
		} elsif ($base eq 'GBoxed') {
			gen_boxed_stuff ($typemacro, $classname, $package);
			$seen{$base}++;
		
#		} elsif ($base eq 'GObject' or $base eq 'GtkObject') {
		} elsif ($base eq 'GObject' or $base eq 'GtkObject'
		         or $base eq 'GInterface') {
			gen_object_stuff ($typemacro, $classname, $base, $package);
			$seen{$base}++;

#		} elsif ($base eq 'GInterface') {
#			# what do we do with interfaces?
#			#gen_interface_stuff ($typemacro, $classname, $base, $package);
#			warn "$classname is a $base -- what do we do with interfaces?\n";
#			$seen{$base}++;

		} else {
			warn "unhandled type $typemacro $classname $base $package\n";
			$seen{unhandled}++;
		}
		$n++;
	    }

	    close IN;

	    print "loaded $n type definitions from $file\n";
	}

	# create output

	open OUT, "> $props{header}"
		or die "can't open $props{header} for writing: $!\n";
	print OUT join("\n",
		"/* This file is automatically generated. Any changes made here will be lost. */\n",
		"/* This header defines simple perlapi-ish macros for creating SV wrappers",
		" * and extracting the GPerl value from SV wrappers.  These macros are used",
		" * by the autogenerated typemaps, and are defined here so that you can use",
		" * the same logic anywhere in your code (e.g., if you handle the argument",
		" * stack by hand instead of using the typemap). */\n",
		@header,
		);
	close OUT;
	open OUT, "> $props{typemap}"
		or die "can't open $props{typemap} for writing: $!\n";
	print OUT join("\n",
			"# This file is automatically generated.  Any changes made here will be lost.",
			"# This typemap is a trivial one-to-one mapping of each type, to avoid the",
			"# need for bizarre typedefs and other tricks often used with XS.",
			"TYPEMAP\n", @typemap,
			"\nINPUT\n", @input,
			"\nOUTPUT\n", @output);
	close OUT;
	open OUT, "> $props{register}"
		or die "can't open $props{register} for writing: $!\n";
	print OUT join("\n",
			"/* This file is automatically generated.  Any changes made here will be lost. */",
			@boot,
			);
	print OUT "\n";
	close OUT;

	# mini report to stdout
	foreach (sort keys %seen) {
		printf "  %3d %s\n", $seen{$_}, $_;
	}

	# fin.
}

#
# generator subs
#

sub gen_enum_stuff {
	my ($typemacro, $classname, $package) = @_;
	push @header, "#ifdef $typemacro
  /* GEnum $classname */
# define Sv$classname(sv)	(gperl_convert_enum ($typemacro, sv))
# define newSV$classname(val)	(gperl_convert_back_enum ($typemacro, val))
#endif /* $typemacro */
";
	push @typemap, "$classname	T_GPERL_GENERIC_WRAPPER";
	push @boot, "#ifdef $typemacro
gperl_register_fundamental ($typemacro, \"$package\");
#endif /* $typemacro */"
		unless $package eq '-';
}

sub gen_flags_stuff {
	my ($typemacro, $classname, $package) = @_;
	push @header, "#ifdef $typemacro
  /* GFlags $classname */
# define Sv$classname(sv)	(gperl_convert_flags ($typemacro, sv))
# define newSV$classname(val)	(gperl_convert_back_flags ($typemacro, val))
#endif /* $typemacro */
";
	push @typemap, "$classname	T_GPERL_GENERIC_WRAPPER";
	push @boot, "#ifdef $typemacro
gperl_register_fundamental ($typemacro, \"$package\");
#endif /* $typemacro */"
		unless $package eq '-';
}



sub gen_boxed_stuff {
	my ($typemacro, $classname, $package) = @_;
	push @header, "#ifdef $typemacro
  /* GBoxed $classname */
  typedef $classname $classname\_ornull;
# define Sv$classname(sv)	(gperl_get_boxed_check ((sv), $typemacro))
# define Sv$classname\_ornull(sv)	(((sv) && SvOK (sv)) ? Sv$classname (sv) : NULL)
  typedef $classname $classname\_own;
  typedef $classname $classname\_copy;
  typedef $classname $classname\_own_ornull;
# define newSV$classname(val)	(gperl_new_boxed ((val), $typemacro, FALSE))
# define newSV$classname\_own(val)	(gperl_new_boxed ((val), $typemacro, TRUE))
# define newSV$classname\_copy(val)	(gperl_new_boxed_copy ((val), $typemacro))
# define newSV$classname\_own_ornull(val)	((val) ? newSV$classname\_own(val) : &PL_sv_undef)
#endif /* $typemacro */
";
	push @typemap, "$classname *	T_GPERL_GENERIC_WRAPPER";
	push @typemap, "const $classname *	T_GPERL_GENERIC_WRAPPER";
	push @typemap, "$classname\_ornull *	T_GPERL_GENERIC_WRAPPER";
	push @typemap, "$classname\_own *	T_GPERL_GENERIC_WRAPPER";
	push @typemap, "$classname\_copy *	T_GPERL_GENERIC_WRAPPER";
	push @typemap, "$classname\_own_ornull *	T_GPERL_GENERIC_WRAPPER";
	push @boot, "#ifdef $typemacro
gperl_register_boxed ($typemacro, \"$package\", NULL);
#endif /* $typemacro */"
		unless $package eq '-';
}



sub gen_object_stuff {
	my ($typemacro, $classname, $root, $package) = @_;
	my $get_wrapper = $root eq 'GtkObject' 
		? 'gtk2perl_new_gtkobject (GTK_OBJECT (val))' 
		: 'gperl_new_object (G_OBJECT (val), FALSE)';
	push @header, "#ifdef $typemacro
  /* $root derivative $classname */
# define Sv$classname(sv)	(($classname*)gperl_get_object_check (sv, $typemacro))
# define newSV$classname(val)	($get_wrapper)
  typedef $classname $classname\_ornull;
# define Sv$classname\_ornull(sv)	(((sv) && SvOK (sv)) ? Sv$classname(sv) : NULL)
# define newSV$classname\_ornull(val)	(((val) == NULL) ? &PL_sv_undef : $get_wrapper)
";

	push @typemap, "$classname *	T_GPERL_GENERIC_WRAPPER";
	push @typemap, "$classname\_ornull *	T_GPERL_GENERIC_WRAPPER";
	push @boot, "#ifdef $typemacro
gperl_register_object ($typemacro, \"$package\");
#endif /* $typemacro */";

	if ($root eq 'GObject') {
		# for GObjects, add a _noinc variant for returning GObjects
		# from constructors.
		$header[$#header] .= "typedef $classname $classname\_noinc;
#define newSV$classname\_noinc(val)	(gperl_new_object (G_OBJECT (val), TRUE))
";
		push @typemap, "$classname\_noinc *	T_GPERL_GENERIC_WRAPPER";
	}

	# close the header ifdef
	$header[$#header] .= "#endif /* $typemacro */\n";
}

1;
__END__

=back

=head1 BUGS

The distinction between GObject and GtkObject is no longer necessary, but
this code hasn't changed because it isn't broken.

GInterfaces are mostly just ignored.

The code is ugly.

=head1 AUTHOR

muppet <scott at asofyet dot org>

=head1 COPYRIGHT

Copyright (C) 2003 by the gtk2-perl team (see the file AUTHORS for the full
list)

This library is free software; you can redistribute it and/or modify it under
the terms of the GNU Library General Public License as published by the Free
Software Foundation; either version 2.1 of the License, or (at your option)
any later version.

This library is distributed in the hope that it will be useful, but WITHOUT
ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
FOR A PARTICULAR PURPOSE.  See the GNU Library General Public License for
more details.

You should have received a copy of the GNU Library General Public License
along with this library; if not, write to the Free Software Foundation, Inc.,
59 Temple Place - Suite 330, Boston, MA  02111-1307  USA.

=cut
