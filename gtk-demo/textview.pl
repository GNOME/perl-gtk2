#!/usr/bin/perl -w 
#
# $Header$
#

#
# Text Widget
#
# The GtkTextView widget displays a GtkTextBuffer. One GtkTextBuffer
# can be displayed by multiple GtkTextViews. This demo has two views
# displaying a single buffer, and shows off the widget's text
# formatting features.
#

use blib '../../G';
use blib '..';
use lib '..';

use Gtk2;
use Carp;

use constant FALSE => 0;
use constant TRUE => 1;

use constant  PANGO_WEIGHT_ULTRALIGHT => 200;
use constant  PANGO_WEIGHT_LIGHT      => 300;
use constant  PANGO_WEIGHT_NORMAL     => 400;
use constant  PANGO_WEIGHT_BOLD       => 700;
use constant  PANGO_WEIGHT_ULTRABOLD  => 800;
use constant  PANGO_WEIGHT_HEAVY      => 900;

#include "demo-common.h"

##static void easter_egg_callback (GtkWidget *button, gpointer data);

use constant gray50_width => 2;
use constant gray50_height => 2;
my $gray50_bits = pack 'CC', 0x02, 0x01;

#static void
#create_tags (GtkTextBuffer *buffer)
sub create_tags {
  my $buffer = shift;
  #GdkBitmap *stipple;

  # Create a bunch of tags. Note that it's also possible to
  # create tags with gtk_text_tag_new() then add them to the
  # tag table for the buffer, gtk_text_buffer_create_tag() is
  # just a convenience function. Also note that you don't have
  # to give tags a name; pass NULL for the name to create an
  # anonymous tag.
  #
  # In any real app, another useful optimization would be to create
  # a GtkTextTagTable in advance, and reuse the same tag table for
  # all the buffers with the same tag set, instead of creating
  # new copies of the same tags for every buffer.
  #
  # Tags are assigned default priorities in order of addition to the
  # tag table.	 That is, tags created later that affect the same text
  # property affected by an earlier tag will override the earlier
  # tag.  You can modify tag priorities with
  # gtk_text_tag_set_priority().

  $buffer->create_tag ("heading",
			weight => PANGO_WEIGHT_BOLD,
			size => 15 * Gtk2::Pango->scale, #PANGO_SCALE,
			);
  
  $buffer->create_tag ("italic", style => 'italic'); #PANGO_STYLE_ITALIC); 
  $buffer->create_tag ("bold", weight => PANGO_WEIGHT_BOLD); 
  $buffer->create_tag ("big", size => 20 * Gtk2::Pango->scale); #PANGO_SCALE);
			      # points times the PANGO_SCALE factor

  $buffer->create_tag ("xx-small", scale => Gtk2::Pango->scale_xx_small); #PANGO_SCALE_XX_SMALL); 
  $buffer->create_tag ("x-large", scale => Gtk2::Pango->scale_x_large); #PANGO_SCALE_X_LARGE); 
  $buffer->create_tag ("monospace", family => "monospace"); 
  $buffer->create_tag ("blue_foreground", foreground => "blue");  
  $buffer->create_tag ("red_background", background => "red");

  my $stipple = Gtk2::Gdk::Bitmap->create_from_data (undef,
					 $gray50_bits, gray50_width,
					 gray50_height);
### FIXME evil!!!
  $stipple = bless $stipple, 'Gtk2::Gdk::Pixmap';
  
  $buffer->create_tag ("background_stipple", background_stipple => $stipple); 
  $buffer->create_tag ("foreground_stipple", foreground_stipple => $stipple); 
##  g_object_unref (stipple);

  $buffer->create_tag ("big_gap_before_line", pixels_above_lines => 30); 
  $buffer->create_tag ("big_gap_after_line", pixels_below_lines => 30); 
  $buffer->create_tag ("double_spaced_line", pixels_inside_wrap => 10); 
  $buffer->create_tag ("not_editable", editable => FALSE); 
  $buffer->create_tag ("word_wrap", wrap_mode => 'word'); # GTK_WRAP_WORD); 
  $buffer->create_tag ("char_wrap", wrap_mode => 'char'); # GTK_WRAP_CHAR); 
  $buffer->create_tag ("no_wrap", wrap_mode => 'none'); #GTK_WRAP_NONE); 
  $buffer->create_tag ("center", justification => 'center'); #GTK_JUSTIFY_CENTER); 
  $buffer->create_tag ("right_justify", justification => 'right'); #GTK_JUSTIFY_RIGHT); 
  $buffer->create_tag ("wide_margins", left_margin => 50, right_margin => 50); 
  $buffer->create_tag ("strikethrough", strikethrough => TRUE); 
  $buffer->create_tag ("underline", underline => 'single'); #PANGO_UNDERLINE_SINGLE); 
  $buffer->create_tag ("double_underline", underline => 'double'); #PANGO_UNDERLINE_DOUBLE);

  $buffer->create_tag ("superscript",
			rise => 10 * Gtk2::Pango->scale, #PANGO_SCALE,	  # 10 pixels
			size => 8 * Gtk2::Pango->scale, #PANGO_SCALE,	  # 8 points
			);
  
  $buffer->create_tag ("subscript",
			rise => -10 * Gtk2::Pango->scale, #PANGO_SCALE,   # 10 pixels
			size => 8 * Gtk2::Pango->scale, #PANGO_SCALE,	   # 8 points
			);

  $buffer->create_tag ("rtl_quote",
			wrap_mode => 'word', #GTK_WRAP_WORD,
			direction => 'rtl', #GTK_TEXT_DIR_RTL,
			indent => 30,
			left_margin => 20,
			right_margin => 20,
			);
}

#static void
#insert_text (GtkTextBuffer *buffer)
sub insert_text {
  my $buffer = shift;

  # demo_find_file() looks in the the current directory first,
  # so you can run gtk-demo without installing GTK, then looks
  # in the location where the file is installed.
  
  # croaks if it can't find the file
###  my $filename = demo_find_file ("gtk-logo-rgb.gif", undef);
  my $filename = "gtk-logo-rgb.gif";
  my $pixbuf;
  eval {
     $pixbuf = Gtk2::Gdk::Pixbuf->new_from_file ($filename);
  };
  if ($@) {
      die "caught exception from Gtk2::Gdk::Pixbuf->new_from_file --- $@";
  }

  my $scaled = $pixbuf->scale_simple (32, 32, 'bilinear');
  #g_object_unref (pixbuf);
  $pixbuf = $scaled;
  
  # get start of buffer; each insertion will revalidate the
  # iterator to point to just after the inserted text.
  
  my $iter = $buffer->get_iter_at_offset (0);

  $buffer->insert ($iter, "The text widget can display text with all kinds of nifty attributes. It also supports multiple views of the same buffer; this demo is showing the same buffer in two places.\n\n");

  $buffer->insert_with_tags_by_name ($iter, "Font styles. ", "heading");
  
  $buffer->insert ($iter, "For example, you can have ");
  $buffer->insert_with_tags_by_name ($iter, "italic", "italic");
  $buffer->insert ($iter, ", ");  
  $buffer->insert_with_tags_by_name ($iter, "bold", "bold");
  $buffer->insert ($iter, ", or ");
  $buffer->insert_with_tags_by_name ($iter, "monospace (typewriter)", "monospace");
  $buffer->insert ($iter, ", or ");
  $buffer->insert_with_tags_by_name ($iter, "big", "big");
  $buffer->insert ($iter, " text. ");
  $buffer->insert ($iter, "It's best not to hardcode specific text sizes; you can use relative sizes as with CSS, such as ");
  $buffer->insert_with_tags_by_name ($iter, "xx-small", "xx-small");
  $buffer->insert ($iter, " or ");
  $buffer->insert_with_tags_by_name ($iter, "x-large", "x-large");
  $buffer->insert ($iter, " to ensure that your program properly adapts if the user changes the default font size.\n\n");
  
  $buffer->insert_with_tags_by_name ($iter, "Colors. ", "heading");
  
  $buffer->insert ($iter, "Colors such as ");  
  $buffer->insert_with_tags_by_name ($iter, "a blue foreground", "blue_foreground");
  $buffer->insert ($iter, " or ");  
  $buffer->insert_with_tags_by_name ($iter, "a red background", "red_background");
  $buffer->insert ($iter, " or even ");  
  $buffer->insert_with_tags_by_name ($iter, "a stippled red background",
					    "red_background",
					    "background_stipple");

  $buffer->insert ($iter, " or ");  
  $buffer->insert_with_tags_by_name ($iter, "a stippled blue foreground on solid red background",
					    "blue_foreground",
					    "red_background",
					    "foreground_stipple");
  $buffer->insert ($iter, " (select that to read it) can be used.\n\n");  

  $buffer->insert_with_tags_by_name ($iter, "Underline, strikethrough, and rise. ",
					    "heading");
  
  $buffer->insert_with_tags_by_name ($iter, "Strikethrough", "strikethrough");
  $buffer->insert ($iter, ", ");
  $buffer->insert_with_tags_by_name ($iter, "underline", "underline");
  $buffer->insert ($iter, ", ");
  $buffer->insert_with_tags_by_name ($iter, "double underline", "double_underline");
  $buffer->insert ($iter, ", ");
  $buffer->insert_with_tags_by_name ($iter, "superscript", "superscript");
  $buffer->insert ($iter, ", and ");
  $buffer->insert_with_tags_by_name ($iter, "subscript", "subscript");
  $buffer->insert ($iter, " are all supported.\n\n");

  $buffer->insert_with_tags_by_name ($iter, "Images. ", "heading");
  
  $buffer->insert ($iter, "The buffer can have images in it: ");
  $buffer->insert_pixbuf ($iter, $pixbuf);
  $buffer->insert_pixbuf ($iter, $pixbuf);
  $buffer->insert_pixbuf ($iter, $pixbuf);
  $buffer->insert ($iter, " for example.\n\n");

  $buffer->insert_with_tags_by_name ($iter, "Spacing. ", "heading");

  $buffer->insert ($iter, "You can adjust the amount of space before each line.\n");
  
  $buffer->insert_with_tags_by_name ($iter, "This line has a whole lot of space before it.\n", 
					    "big_gap_before_line", "wide_margins");
  $buffer->insert_with_tags_by_name ($iter, "You can also adjust the amount of space after each line; this line has a whole lot of space after it.\n",
					    "big_gap_after_line", "wide_margins");
  
  $buffer->insert_with_tags_by_name ($iter,
					    "You can also adjust the amount of space between wrapped lines; this line has extra space between each wrapped line in the same paragraph. To show off wrapping, some filler text: the quick brown fox jumped over the lazy dog. Blah blah blah blah blah blah blah blah blah.\n",
					    "double_spaced_line", "wide_margins");

  $buffer->insert ($iter, "Also note that those lines have extra-wide margins.\n\n");

  $buffer->insert_with_tags_by_name ($iter, "Editability. ", "heading");
  
  $buffer->insert_with_tags_by_name ($iter, "This line is 'locked down' and can't be edited by the user - just try it! You can't delete this line.\n\n",
					    "not_editable");

  $buffer->insert_with_tags_by_name ($iter, "Wrapping. ", "heading");

  $buffer->insert ($iter, "This line (and most of the others in this buffer) is word-wrapped, using the proper Unicode algorithm. Word wrap should work in all scripts and languages that GTK+ supports. Let's make this a long paragraph to demonstrate: blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah\n\n");  
  
  $buffer->insert_with_tags_by_name ($iter, "This line has character-based wrapping, and can wrap between any two character glyphs. Let's make this a long paragraph to demonstrate: blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah\n\n",
					    "char_wrap");
  
  $buffer->insert_with_tags_by_name ($iter, "This line has all wrapping turned off, so it makes the horizontal scrollbar appear.\n\n\n",
					    "no_wrap");

  $buffer->insert_with_tags_by_name ($iter, "Justification. ", "heading");  
  
  $buffer->insert_with_tags_by_name ($iter, "\nThis line has center justification.\n", "center");

  $buffer->insert_with_tags_by_name ($iter, "This line has right justification.\n", 
					    "right_justify");

  $buffer->insert_with_tags_by_name ($iter,
					    "\nThis line has big wide margins. Text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text.\n", 
					    "wide_margins");  

  $buffer->insert_with_tags_by_name ($iter, "Internationalization. ", 
					    "heading");
	  
  $buffer->insert ($iter, "You can put all sorts of Unicode text in the buffer.\n\nGerman (Deutsch S\303\274d) Gr\303\274\303\237 Gott\nGreek (\316\225\316\273\316\273\316\267\316\275\316\271\316\272\316\254) \316\223\316\265\316\271\316\254 \317\203\316\261\317\202\nHebrew	\327\251\327\234\327\225\327\235\nJapanese (\346\227\245\346\234\254\350\252\236)\n\nThe widget properly handles bidirectional text, word wrapping, DOS/UNIX/Unicode paragraph separators, grapheme boundaries, and so on using the Pango internationalization framework.\n");  

  $buffer->insert ($iter, "Here's a word-wrapped quote in a right-to-left language:\n");
  $buffer->insert_with_tags_by_name ($iter, "\331\210\331\202\330\257 \330\250\330\257\330\243 \330\253\331\204\330\247\330\253 \331\205\331\206 \330\243\331\203\330\253\330\261 \330\247\331\204\331\205\330\244\330\263\330\263\330\247\330\252 \330\252\331\202\330\257\331\205\330\247 \331\201\331\212 \330\264\330\250\331\203\330\251 \330\247\331\203\330\263\331\212\331\210\331\206 \330\250\330\261\330\247\331\205\330\254\331\207\330\247 \331\203\331\205\331\206\330\270\331\205\330\247\330\252 \331\204\330\247 \330\252\330\263\330\271\331\211 \331\204\331\204\330\261\330\250\330\255\330\214 \330\253\331\205 \330\252\330\255\331\210\331\204\330\252 \331\201\331\212 \330\247\331\204\330\263\331\206\331\210\330\247\330\252 \330\247\331\204\330\256\331\205\330\263 \330\247\331\204\331\205\330\247\330\266\331\212\330\251 \330\245\331\204\331\211 \331\205\330\244\330\263\330\263\330\247\330\252 \331\205\330\247\331\204\331\212\330\251 \331\205\331\206\330\270\331\205\330\251\330\214 \331\210\330\250\330\247\330\252\330\252 \330\254\330\262\330\241\330\247 \331\205\331\206 \330\247\331\204\331\206\330\270\330\247\331\205 \330\247\331\204\331\205\330\247\331\204\331\212 \331\201\331\212 \330\250\331\204\330\257\330\247\331\206\331\207\330\247\330\214 \331\210\331\204\331\203\331\206\331\207\330\247 \330\252\330\252\330\256\330\265\330\265 \331\201\331\212 \330\256\330\257\331\205\330\251 \331\202\330\267\330\247\330\271 \330\247\331\204\331\205\330\264\330\261\331\210\330\271\330\247\330\252 \330\247\331\204\330\265\330\272\331\212\330\261\330\251. \331\210\330\243\330\255\330\257 \330\243\331\203\330\253\330\261 \331\207\330\260\331\207 \330\247\331\204\331\205\330\244\330\263\330\263\330\247\330\252 \331\206\330\254\330\247\330\255\330\247 \331\207\331\210 \302\273\330\250\330\247\331\206\331\203\331\210\330\263\331\210\331\204\302\253 \331\201\331\212 \330\250\331\210\331\204\331\212\331\201\331\212\330\247.\n\n",
						"rtl_quote");
      
  $buffer->insert ($iter, "You can put widgets in the buffer: Here's a button: ");
  $anchor = $buffer->create_child_anchor ($iter);
  $buffer->insert ($iter, " and a menu: ");
  $anchor = $buffer->create_child_anchor ($iter);
  $buffer->insert ($iter, " and a scale: ");
  $anchor = $buffer->create_child_anchor ($iter);
  $buffer->insert ($iter, " and an animation: ");
  $anchor = $buffer->create_child_anchor ($iter);
  $buffer->insert ($iter, " finally a text entry: ");
  $anchor = $buffer->create_child_anchor ($iter);
  $buffer->insert ($iter, ".\n");
  
  $buffer->insert ($iter, "\n\nThis demo doesn't demonstrate all the GtkTextBuffer features; it leaves out, for example: invisible/hidden text (doesn't work in GTK 2, but planned), tab stops, application-drawn areas on the sides of the widget for displaying breakpoints and such...");

  # Apply word_wrap tag to whole buffer
  $buffer->apply_tag_by_name ("word_wrap", $buffer->get_bounds);

#  g_object_unref (pixbuf);
}

#static gboolean
#find_anchor (GtkTextIter *iter)
sub find_anchor {
  my $iter = shift;
  while ($iter->forward_char) {
    return TRUE if $iter->get_child_anchor;
  }
  return FALSE;
}

#static void
#attach_widgets (GtkTextView *text_view)
sub attach_widgets {
  my $text_view = shift;
  
  my $buffer = $text_view->get_buffer;

  my $iter = $buffer->get_start_iter;

  my $i = 0;
  while (find_anchor ($iter)) {
      my $widget;
      
      my $anchor = $iter->get_child_anchor;

      if ($i == 0) {
          $widget = Gtk2::Button->new ("Click Me");

          $widget->signal_connect (clicked => \&easter_egg_callback);

      } elsif ($i == 1) {
          my $menu = Gtk2::Menu->new;
          
          $widget = Gtk2::OptionMenu->new;

          #my $menu_item = Gtk2::MenuItem->new_with_label ("Option 1");
          my $menu_item = Gtk2::MenuItem->new ("Option 1");
          $menu->append ($menu_item);
          #$menu_item = Gtk2::MenuItem->new_with_label ("Option 2");
          $menu_item = Gtk2::MenuItem->new ("Option 2");
          $menu->append ($menu_item);
          #$menu_item = Gtk2::MenuItem->new_with_label ("Option 3");
          $menu_item = Gtk2::MenuItem->new ("Option 3");
          $menu->append ($menu_item);

          $widget->set_menu ($menu);

      } elsif ($i == 2) {
          $widget = Gtk2::HScale->new (undef);
          $widget->set_range (0, 100);
          $widget->set_size_request (70, -1);

      } elsif ($i == 3) {
	  ##my $filename = demo_find_file ("floppybuddy.gif", undef);
	  my $filename = "floppybuddy.gif";
	  $widget = Gtk2::Image->new_from_file ($filename);

      } elsif ($i == 4) {
          $widget = Gtk2::Entry->new;

      } else {
          #widget = NULL; /* avoids a compiler warning */
          #g_assert_not_reached ();
	  croak "shouldn't get here";
      }

      $text_view->add_child_at_anchor ($widget, $anchor);

      $widget->show_all;

      ++$i;
  }
}

my $window;

#GtkWidget *
#do_textview (void)
sub do_textview {
  #static GtkWidget *window = NULL;

  if (!$window) {
      
      $window = Gtk2::Window->new ('toplevel');
      $window->set_default_size (450, 450);
      
      $window->signal_connect (destroy => sub { $window = undef; });

      $window->set_title ("TextView");
      $window->set_border_width (0);

      my $vpaned = Gtk2::VPaned->new;
      $vpaned->set_border_width (5);
      $window->add ($vpaned);

      # For convenience, we just use the autocreated buffer from
      # the first text view; you could also create the buffer
      # by itself with gtk_text_buffer_new(), then later create
      # a view widget.
      
      my $view1 = Gtk2::TextView->new;
      my $buffer = $view1->get_buffer;
      my $view2 = Gtk2::TextView->new_with_buffer ($buffer);
      
      my $sw = Gtk2::ScrolledWindow->new (undef, undef);
      $sw->set_policy ('automatic', 'automatic');
      $vpaned->add1 ($sw);

      $sw->add ($view1);

      $sw = Gtk2::ScrolledWindow->new (undef, undef);
      $sw->set_policy ('automatic', 'automatic');
      $vpaned->add2 ($sw);

      $sw->add ($view2);

      create_tags ($buffer);
      insert_text ($buffer);

      attach_widgets ($view1);
      attach_widgets ($view2);
      
      $vpaned->show_all;
  }

  if (!$window->visible) {
      $window->show;

  } else {
      $window->destroy;
      $window = undef;
  }

  return $window;
}


#static void
#recursive_attach_view (int                 depth,
#                       GtkTextView        *view,
#                       GtkTextChildAnchor *anchor)
sub recursive_attach_view {
  my ($depth, $view, $anchor) = @_;
  
  return if $depth > 4;
  
  my $child_view = Gtk2::TextView->new_with_buffer ($view->get_buffer);

  # Event box is to add a black border around each child view
  my $event_box = Gtk2::EventBox->new;
  my $color = Gtk2::Gdk::Color->parse ("black");
  $event_box->modify_bg ('normal', $color);

  my $align = Gtk2::Alignment->new (0.5, 0.5, 1.0, 1.0);
  $align->set_border_width (1);
  
  $event_box->add ($align);
  $align->add ($child_view);
  
  $view->add_child_at_anchor ($event_box, $anchor);

  recursive_attach_view ($depth + 1, $child_view, $anchor);
}

#static void
#easter_egg_callback (GtkWidget *button,
#                     gpointer   data)
sub easter_egg_callback {
  my $button = shift;

  if ($tvee_window) {
      $tvee_window->present;
      return;
  }
  
  my $buffer = Gtk2::TextBuffer->new (undef);

  my $iter = $buffer->get_start_iter;

  $buffer->insert ($iter, "This buffer is shared by a set of nested text views.\n Nested view:\n");
  my $anchor = $buffer->create_child_anchor ($iter);
  $buffer->insert ($iter, "\nDon't do this in real applications, please.\n");

  my $view = Gtk2::TextView->new_with_buffer ($buffer);
  
  recursive_attach_view (0, $view, $anchor);
  
  #g_object_unref (buffer);

  $tvee_window = Gtk2::Window->new ('toplevel');
  my $sw = Gtk2::ScrolledWindow->new (undef, undef);
  $sw->set_policy ('automatic', 'automatic');

  $tvee_window->add ($sw);
  $sw->add ($view);

#  g_object_add_weak_pointer (G_OBJECT (window),
#                             (gpointer *) &window);
  $tvee_window->signal_connect (destroy => sub {$tvee_window = undef; 1});

  $tvee_window->set_default_size (300, 400);
  
  $tvee_window->show_all;
}

Gtk2->init;
do_textview;
Gtk2->main;
