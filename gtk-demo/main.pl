#!/usr/bin/perl -w
#
# $Header$
#


use strict;
use Carp;

use blib '../../G';
use blib '../';
use lib '../';

use constant FALSE => 0;
use constant TRUE => 1;

use Gtk2;

#include <demos.h>
#require 'demos.pl';
use vars qw/ @testgtk_demos /;

my @child0 = (
  { title => "Editable Cells", filename => "editable_cells.c", func => \&do_editable_cells, },
  { title => "List Store",     filename => "list_store.c",     func => \&do_list_store, },
  { title => "Tree Store",     filename => "tree_store.c",     func => \&do_tree_store, },
);

@testgtk_demos = (
  { title => "Application main window",     filename => "appwindow.c",     func => \&do_appwindow, }, 
  { title => "Button Boxes",                filename => "button_box.c",    func => \&do_button_box, }, 
  { title => "Change Display",              filename => "changedisplay.c", func => \&do_changedisplay, }, 
  { title => "Color Selector",              filename => "colorsel.c",      func => \&do_colorsel, }, 
  { title => "Dialog and Message Boxes",    filename => "dialog.c",        func => \&do_dialog, }, 
  { title => "Drawing Area",                filename => "drawingarea.c",   func => \&do_drawingarea, }, 
  { title => "Images",                      filename => "images.c",        func => \&do_images, }, 
  { title => "Item Factory",                filename => "item_factory.c",  func => \&do_item_factory, }, 
  { title => "Menus",                       filename => "menus.c",         func => \&do_menus, }, 
  { title => "Paned Widgets",               filename => "panes.c",         func => \&do_panes, }, 
  { title => "Pixbufs",                     filename => "pixbufs.c",       func => \&do_pixbufs, }, 
  { title => "Size Groups",                 filename => "sizegroup.c",     func => \&do_sizegroup, }, 
  { title => "Stock Item and Icon Browser", filename => "stock_browser.c", func => \&do_stock_browser, }, 
  { title => "Text Widget",                 filename => "textview.c",      func => \&do_textview, }, 
  { title => "Tree View", children => \@child0 },
);

#static GtkTextBuffer *info_buffer;
my $info_buffer;
#static GtkTextBuffer *source_buffer;
my $source_buffer;

#static gchar *current_file = NULL;
my $current_file;

use constant TITLE_COLUMN    => 0;
use constant FILENAME_COLUMN => 1;
use constant FUNC_COLUMN     => 2;
use constant ITALIC_COLUMN   => 3;
use constant NUM_COLUMNS     => 4;

#typedef struct _CallbackData CallbackData;
#struct _CallbackData
#{
#  GtkTreeModel *model;
#  GtkTreePath *path;
#};

#/**
# * demo_find_file:
# * @base: base filename
# * @err:  location to store error, or %NULL.
# * 
# * Looks for @base first in the current directory, then in the
# * location GTK+ where it will be installed on make install,
# * returns the first file found.
# * 
# * Return value: the filename, if found or %NULL
# **/
sub demo_find_file {
	my $base = shift;

	#  if (g_file_test (base, G_FILE_TEST_EXISTS))
	#    return g_strdup (base);
	return $base if -e $base;

	#{
	# char *filename = g_build_filename (DEMOCODEDIR, base, NULL);
	# if (!g_file_test (filename, G_FILE_TEST_EXISTS))
	#{
	#  g_set_error (err, G_FILE_ERROR, G_FILE_ERROR_NOENT,
	#	       "Cannot find demo data file \"%s\"", base);
	#  g_free (filename);
	#  return NULL;
	use File::Spec;
#	my $filename = File::Spec->catfile (DEMOCODEDIR, $base);
	my $filename = $base;
	croak "Cannot find demo data file $base\n"
		unless -e $filename;

	return $filename;
}

sub window_closed_cb {
	my ($window, $cbdata) = @_;
	# CallbackData *cbdata = data;

	# GtkTreeIter iter;
	# gtk_tree_model_get_iter (cbdata->model, &iter, cbdata->path);
	my $iter = $cbdata->{model}->get_iter ($cbdata->{path});
	# gtk_tree_model_get (GTK_TREE_MODEL (cbdata->model), &iter,
	#		      ITALIC_COLUMN, &italic,
	#		      -1);
	my ($italic) = $cbdata->{model}->get ($iter, ITALIC_COLUMN);
	if ($italic) {
		# gtk_tree_store_set (GTK_TREE_STORE (cbdata->model), &iter,
		#		      ITALIC_COLUMN, !italic,
		#		      -1);
		$cbdata->{model}->set ($iter, 
				       ITALIC_COLUMN, !$italic);
	}

	# these should be handled by the unref on the $cbdata SV when
	# the closure is invalidated.
	# gtk_tree_path_free (cbdata->path);
	# g_free (cbdata);
}

=out

gboolean
read_line (FILE *stream, GString *str)
{
  int n_read = 0;
  
#ifdef HAVE_FLOCKFILE
  flockfile (stream);
#endif

  g_string_truncate (str, 0);
  
  while (1)
    {
      int c;
      
#ifndef G_OS_WIN32
      c = getc_unlocked (stream);
#else
      c = getc (stream);
#endif

      if (c == EOF)
	goto done;
      else
	n_read++;

      switch (c)
	{
	case '\r':
	case '\n':
	  {
#ifdef HAVE_FLOCKFILE
	    int next_c = getc_unlocked (stream);
#else
	    int next_c = getc (stream);
#endif
	    
	    if (!(next_c == EOF ||
		  (c == '\r' && next_c == '\n') ||
		  (c == '\n' && next_c == '\r')))
	      ungetc (next_c, stream);
	    
	    goto done;
	  }
	default:
	  g_string_append_c (str, c);
	}
    }

 done:

#ifdef HAVE_FLOCKFILE
  funlockfile (stream);
#endif

  return n_read > 0;
}


/* Stupid syntax highlighting.
 *
 * No regex was used in the making of this highlighting.
 * It should only work for simple cases.  This is good, as
 * that's all we should have in the demos.
 */
/* This code should not be used elsewhere, except perhaps as an example of how
 * to iterate through a text buffer.
 */
enum {
  STATE_NORMAL,
  STATE_IN_COMMENT
};

static gchar *tokens[] =
{
  "/*",
  "\"",
  NULL
};

static gchar *types[] =
{
  "static",
  "const ",
  "void",
  "gint",
  "int ",
  "char ",
  "gchar ",
  "gfloat",
  "float",
  "gint8",
  "gint16",
  "gint32",
  "guint",
  "guint8",
  "guint16",
  "guint32",
  "guchar",
  "glong",
  "gboolean" ,
  "gshort",
  "gushort",
  "gulong",
  "gdouble",
  "gldouble",
  "gpointer",
  "NULL",
  "GList",
  "GSList",
  "FALSE",
  "TRUE",
  "FILE ",
  "GtkObject ",
  "GtkColorSelection ",
  "GtkWidget ",
  "GtkButton ",
  "GdkColor ",
  "GdkRectangle ",
  "GdkEventExpose ",
  "GdkGC ",
  "GdkPixbufLoader ",
  "GdkPixbuf ",
  "GError",
  "size_t",
  NULL
};

static gchar *control[] =
{
  " if ",
  " while ",
  " else",
  " do ",
  " for ",
  "?",
  ":",
  "return ",
  "goto ",
  NULL
};
void
parse_chars (gchar     *text,
	     gchar    **end_ptr,
	     gint      *state,
	     gchar    **tag,
	     gboolean   start)
{
  gint i;
  gchar *next_token;

  /* Handle comments first */
  if (*state == STATE_IN_COMMENT)
    {
      *end_ptr = strstr (text, "*/");
      if (*end_ptr)
	{
	  *end_ptr += 2;
	  *state = STATE_NORMAL;
	  *tag = "comment";
	}
      return;
    }

  *tag = NULL;
  *end_ptr = NULL;

  /* check for comment */
  if (!strncmp (text, "/*", 2))
    {
      *end_ptr = strstr (text, "*/");
      if (*end_ptr)
	*end_ptr += 2;
      else
	*state = STATE_IN_COMMENT;
      *tag = "comment";
      return;
    }

  /* check for preprocessor defines */
  if (*text == '#' && start)
    {
      *end_ptr = NULL;
      *tag = "preprocessor";
      return;
    }

  /* functions */
  if (start && * text != '\t' && *text != ' ' && *text != '{' && *text != '}')
    {
      if (strstr (text, "("))
	{
	  *end_ptr = strstr (text, "(");
	  *tag = "function";
	  return;
	}
    }
  /* check for types */
  for (i = 0; types[i] != NULL; i++)
    if (!strncmp (text, types[i], strlen (types[i])))
      {
	*end_ptr = text + strlen (types[i]);
	*tag = "type";
	return;
      }

  /* check for control */
  for (i = 0; control[i] != NULL; i++)
    if (!strncmp (text, control[i], strlen (control[i])))
      {
	*end_ptr = text + strlen (control[i]);
	*tag = "control";
	return;
      }

  /* check for string */
  if (text[0] == '"')
    {
      gint maybe_escape = FALSE;

      *end_ptr = text + 1;
      *tag = "string";
      while (**end_ptr != '\000')
	{
	  if (**end_ptr == '\"' && !maybe_escape)
	    {
	      *end_ptr += 1;
	      return;
	    }
	  if (**end_ptr == '\\')
	    maybe_escape = TRUE;
	  else
	    maybe_escape = FALSE;
	  *end_ptr += 1;
	}
      return;
    }

  /* not at the start of a tag.  Find the next one. */
  for (i = 0; tokens[i] != NULL; i++)
    {
      next_token = strstr (text, tokens[i]);
      if (next_token)
	{
	  if (*end_ptr)
	    *end_ptr = (*end_ptr<next_token)?*end_ptr:next_token;
	  else
	    *end_ptr = next_token;
	}
    }

  for (i = 0; types[i] != NULL; i++)
    {
      next_token = strstr (text, types[i]);
      if (next_token)
	{
	  if (*end_ptr)
	    *end_ptr = (*end_ptr<next_token)?*end_ptr:next_token;
	  else
	    *end_ptr = next_token;
	}
    }

  for (i = 0; control[i] != NULL; i++)
    {
      next_token = strstr (text, control[i]);
      if (next_token)
	{
	  if (*end_ptr)
	    *end_ptr = (*end_ptr<next_token)?*end_ptr:next_token;
	  else
	    *end_ptr = next_token;
	}
    }
}

/* While not as cool as c-mode, this will do as a quick attempt at highlighting */
static void
fontify ()
{
  GtkTextIter start_iter, next_iter, tmp_iter;
  gint state;
  gchar *text;
  gchar *start_ptr, *end_ptr;
  gchar *tag;

  state = STATE_NORMAL;

  gtk_text_buffer_get_iter_at_offset (source_buffer, &start_iter, 0);

  next_iter = start_iter;
  while (gtk_text_iter_forward_line (&next_iter))
    {
      gboolean start = TRUE;
      start_ptr = text = gtk_text_iter_get_text (&start_iter, &next_iter);

      do
	{
	  parse_chars (start_ptr, &end_ptr, &state, &tag, start);

	  start = FALSE;
	  if (end_ptr)
	    {
	      tmp_iter = start_iter;
	      gtk_text_iter_forward_chars (&tmp_iter, end_ptr - start_ptr);
	    }
	  else
	    {
	      tmp_iter = next_iter;
	    }
	  if (tag)
	    gtk_text_buffer_apply_tag_by_name (source_buffer, tag, &start_iter, &tmp_iter);

	  start_iter = tmp_iter;
	  start_ptr = end_ptr;
	}
      while (end_ptr);

      g_free (text);
      start_iter = next_iter;
    }
}

=cut

#void
#load_file (const gchar *filename)
#{
#  FILE *file;
#  GtkTextIter start, end;
#  char *full_filename;
#  GError *err = NULL;
#  GString *buffer = g_string_new (NULL);
#  int state = 0;
#  gboolean in_para = 0;
#
#  if (current_file && !strcmp (current_file, filename))
#    {
#      g_string_free (buffer, TRUE);
#      return;
#    }
#
#  g_free (current_file);
#  current_file = g_strdup (filename);
#  
#  gtk_text_buffer_get_bounds (info_buffer, &start, &end);
#  gtk_text_buffer_delete (info_buffer, &start, &end);
#
#  gtk_text_buffer_get_bounds (source_buffer, &start, &end);
#  gtk_text_buffer_delete (source_buffer, &start, &end);
#
#  full_filename = demo_find_file (filename, &err);
#  if (!full_filename)
#    {
#      g_warning ("%s", err->message);
#      g_error_free (err);
#      return;
#    }
#
#  file = fopen (full_filename, "r");
#
#  if (!file)
#    g_warning ("Cannot open %s: %s\n", full_filename, g_strerror (errno));
#
#  g_free (full_filename);
#
#  if (!file)
#    return;
#
#  gtk_text_buffer_get_iter_at_offset (info_buffer, &start, 0);
#  while (read_line (file, buffer))
#    {
#      gchar *p = buffer->str;
#      gchar *q;
#      gchar *r;
#      
#      switch (state)
#	{
#	case 0:
#	  /* Reading title */
#	  while (*p == '/' || *p == '*' || g_ascii_isspace (*p))
#	    p++;
#	  r = p;
#	  while (*r != '/' && strlen (r))
#	    r++;
#	  if (strlen (r) > 0)
#	    p = r + 1;
#	  q = p + strlen (p);
#	  while (q > p && g_ascii_isspace (*(q - 1)))
#	    q--;
#
#	  if (q > p)
#	    {
#	      int len_chars = g_utf8_pointer_to_offset (p, q);
#
#	      end = start;
#
#	      g_assert (strlen (p) >= q - p);
#	      gtk_text_buffer_insert (info_buffer, &end, p, q - p);
#	      start = end;
#
#	      gtk_text_iter_backward_chars (&start, len_chars);
#	      gtk_text_buffer_apply_tag_by_name (info_buffer, "title", &start, &end);
#
#	      start = end;
#	      
#	      state++;
#	    }
#	  break;
#	    
#	case 1:
#	  /* Reading body of info section */
#	  while (g_ascii_isspace (*p))
#	    p++;
#	  if (*p == '*' && *(p + 1) == '/')
#	    {
#	      gtk_text_buffer_get_iter_at_offset (source_buffer, &start, 0);
#	      state++;
#	    }
#	  else
#	    {
#	      int len;
#	      
#	      while (*p == '*' || g_ascii_isspace (*p))
#		p++;
#
#	      len = strlen (p);
#	      while (g_ascii_isspace (*(p + len - 1)))
#		len--;
#	      
#	      if (len > 0)
#		{
#		  if (in_para)
#		    gtk_text_buffer_insert (info_buffer, &start, " ", 1);
#
#		  g_assert (strlen (p) >= len);
#		  gtk_text_buffer_insert (info_buffer, &start, p, len);
#		  in_para = 1;
#		}
#	      else
#		{
#		  gtk_text_buffer_insert (info_buffer, &start, "\n", 1);
#		  in_para = 0;
#		}
#	    }
#	  break;
#
#	case 2:
#	  /* Skipping blank lines */
#	  while (g_ascii_isspace (*p))
#	    p++;
#	  if (*p)
#	    {
#	      p = buffer->str;
#	      state++;
#	      /* Fall through */
#	    }
#	  else
#	    break;
#	  
#	case 3:
#	  /* Reading program body */
#	  gtk_text_buffer_insert (source_buffer, &start, p, -1);
#	  gtk_text_buffer_insert (source_buffer, &start, "\n", 1);
#	  break;
#	}
#    }
#
#  fontify ();
#
#  g_string_free (buffer, TRUE);
#}

#void
#row_activated_cb (GtkTreeView       *tree_view,
#                  GtkTreePath       *path,
#		  GtkTreeViewColumn *column)
sub row_activated_cb {
   my ($tree_view, $path, $column) = @_;
#{
#  GtkTreeIter iter;
#  gboolean italic;
#  GDoDemoFunc func;
#  GtkWidget *window;
#  GtkTreeModel *model;
#
#  model = gtk_tree_view_get_model (tree_view);
   my $model = $tree_view->get_model;
#  
#  gtk_tree_model_get_iter (model, &iter, path);
   my $iter = $model->get_iter ($path);
#  gtk_tree_model_get (GTK_TREE_MODEL (model),
#		      &iter,
#		      FUNC_COLUMN, &func,
#		      ITALIC_COLUMN, &italic,
#		      -1);
   my ($func, $italic) = $model->get ($iter, FUNC_COLUMN, ITALIC_COLUMN);
use Data::Dumper;
print Dumper($func);

   if ($func) {
#      gtk_tree_store_set (GTK_TREE_STORE (model),
#			  &iter,
#			  ITALIC_COLUMN, !italic,
#			  -1);
#      window = (func) ();
#      
#      if (window != NULL)
#	{
#	  CallbackData *cbdata;
#	  
#	  cbdata = g_new (CallbackData, 1);
#	  cbdata->model = model;
#	  cbdata->path = gtk_tree_path_copy (path);
#	  
#	  g_signal_connect (window, "destroy",
#			    G_CALLBACK (window_closed_cb), cbdata);
#	}
   }
}

#static void
#selection_cb (GtkTreeSelection *selection,
#	      GtkTreeModel     *model)
sub selection_cb {
  my ($selection, $model) = @_;
  warn "selection_sb -- STUB!";
#{
#  GtkTreeIter iter;
#  GValue value = {0, };
#
#  if (! gtk_tree_selection_get_selected (selection, NULL, &iter))
#    return;
#
#  gtk_tree_model_get_value (model, &iter,
#			    FILENAME_COLUMN,
#			    &value);
#  if (g_value_get_string (&value))
#    load_file (g_value_get_string (&value));
#  g_value_unset (&value);
}

#static GtkWidget *
#create_text (GtkTextBuffer **buffer,
#	     gboolean        is_source)
#{
sub create_text {
  my $buffer_ref = shift;
  my $is_source = shift;

#  GtkWidget *scrolled_window;
#  GtkWidget *text_view;
#  PangoFontDescription *font_desc;
#
#  scrolled_window = gtk_scrolled_window_new (NULL, NULL);
#  gtk_scrolled_window_set_policy (GTK_SCROLLED_WINDOW (scrolled_window),
#				  GTK_POLICY_AUTOMATIC,
#				  GTK_POLICY_AUTOMATIC);
#  gtk_scrolled_window_set_shadow_type (GTK_SCROLLED_WINDOW (scrolled_window),
#				       GTK_SHADOW_IN);
## my $scrolled_window = Gtk2::ScrolledWindow->new;
  my $scrolled_window = Gtk2::ScrolledWindow->new (undef, undef);
  $scrolled_window->set_policy ('automatic', 'automatic');
  $scrolled_window->set_shadow_type ('in');

#  text_view = gtk_text_view_new ();
  my $text_view = Gtk2::TextView->new;

#  *buffer = gtk_text_buffer_new (NULL);
#  gtk_text_view_set_buffer (GTK_TEXT_VIEW (text_view), *buffer);
#  gtk_text_view_set_editable (GTK_TEXT_VIEW (text_view), FALSE);
#  gtk_text_view_set_cursor_visible (GTK_TEXT_VIEW (text_view), FALSE);
  $$buffer_ref = Gtk2::TextBuffer->new (undef);
  $text_view->set_buffer ($$buffer_ref);
  $text_view->set_editable (FALSE);
  $text_view->set_cursor_visible (FALSE);

#  gtk_container_add (GTK_CONTAINER (scrolled_window), text_view);
  $scrolled_window->add ($text_view);

  if ($is_source)
    {
#      font_desc = pango_font_description_from_string ("Courier 12");
#      gtk_widget_modify_font (text_view, font_desc);
#      pango_font_description_free (font_desc);
       my $font_desc = Gtk2::Pango::FontDescription->from_string ("Courier 12");
       $text_view->modify_font ($font_desc);

#      gtk_text_view_set_wrap_mode (GTK_TEXT_VIEW (text_view),
#                                   GTK_WRAP_NONE);
       $text_view->set_wrap_mode ('none');
    }
  else
    {
       # Make it a bit nicer for text.
#      gtk_text_view_set_wrap_mode (GTK_TEXT_VIEW (text_view),
#                                   GTK_WRAP_WORD);
#      gtk_text_view_set_pixels_above_lines (GTK_TEXT_VIEW (text_view),
#                                            2);
#      gtk_text_view_set_pixels_below_lines (GTK_TEXT_VIEW (text_view),
#                                            2);
       $text_view->set_wrap_mode ('word');
       $text_view->set_pixels_above_lines (2);
       $text_view->set_pixels_below_lines (2);
    }
  
  return $scrolled_window;
}

#static GtkWidget *
#create_tree (void)
sub create_tree {
#  GtkTreeSelection *selection;
#  GtkCellRenderer *cell;
#  GtkWidget *tree_view;
#  GtkTreeViewColumn *column;
#  GtkTreeStore *model;
#  GtkTreeIter iter;
#
#  Demo *d = testgtk_demos;
#
#  model = gtk_tree_store_new (NUM_COLUMNS, G_TYPE_STRING, G_TYPE_STRING, G_TYPE_POINTER, G_TYPE_BOOLEAN);
####   my $model = Gtk2::TreeStore->new ('G::String', 'G::String', 'G::Pointer', 'G::Boolean');
   my $model = Gtk2::TreeStore->new ('G::String', 'G::String', 'G::Uint', 'G::Boolean');
#  tree_view = gtk_tree_view_new ();
#  gtk_tree_view_set_model (GTK_TREE_VIEW (tree_view), GTK_TREE_MODEL (model));
#  selection = gtk_tree_view_get_selection (GTK_TREE_VIEW (tree_view));
   my $tree_view = Gtk2::TreeView->new;
   $tree_view->set_model ($model);
   my $selection = $tree_view->get_selection;

#  gtk_tree_selection_set_mode (GTK_TREE_SELECTION (selection),
#			       GTK_SELECTION_BROWSE);
   $selection->set_mode ('browse');
#  gtk_widget_set_size_request (tree_view, 200, -1);
   $tree_view->set_size_request (200, -1);

#  /* this code only supports 1 level of children. If we
#   * want more we probably have to use a recursing function.
#   */
#  while (d->title)
#    {
   foreach my $d (@testgtk_demos) {
#      Demo *children = d->children;
#
#      gtk_tree_store_append (GTK_TREE_STORE (model), &iter, NULL);
      my $iter = $model->append (undef);
#
#      gtk_tree_store_set (GTK_TREE_STORE (model),
#			  &iter,
#			  TITLE_COLUMN, d->title,
#			  FILENAME_COLUMN, d->filename,
#			  FUNC_COLUMN, d->func,
#			  ITALIC_COLUMN, FALSE,
#			  -1);
      $model->set ($iter,
                   TITLE_COLUMN,    $d->{title},
                   FILENAME_COLUMN, $d->{filename},
                   FUNC_COLUMN,     $d->{func},
                   ITALIC_COLUMN,   FALSE);
#
#      d++;
#
#      if (!children)
#	continue;
      next unless $d->{children};

#      while (children->title)
#	{
      foreach my $child (@{ $d->{children} }) {
#	  GtkTreeIter child_iter;
#
#	  gtk_tree_store_append (GTK_TREE_STORE (model), &child_iter, &iter);
         my $child_iter = $model->append ($iter);

#	  gtk_tree_store_set (GTK_TREE_STORE (model),
#			      &child_iter,
#			      TITLE_COLUMN, children->title,
#			      FILENAME_COLUMN, children->filename,
#			      FUNC_COLUMN, children->func,
#			      ITALIC_COLUMN, FALSE,
#			      -1);
         $model->set ($child_iter,
                      TITLE_COLUMN,    $child->{title},
                      FILENAME_COLUMN, $child->{filename},
                      FUNC_COLUMN,     $child->{func},
                      ITALIC_COLUMN,   FALSE);

#	  children++;
      }
   }
#
#  cell = gtk_cell_renderer_text_new ();
   my $cell = Gtk2::CellRendererText->new;

#  g_object_set (G_OBJECT (cell),
#                "style", PANGO_STYLE_ITALIC,
#                NULL);
  $cell->set ('style' => 'italic');
  
#  column = gtk_tree_view_column_new_with_attributes ("Widget (double click for demo)",
#						     cell,
#						     "text", TITLE_COLUMN,
#						     "style_set", ITALIC_COLUMN,
#						     NULL);
# my $column = Gtk2::TreeViewColumn->new ("Widget (double click for demo)",
 my $column = Gtk2::TreeViewColumn->new_with_attributes
 					("Widget (double click for demo)",
                                        $cell,
                                        'text' => TITLE_COLUMN,
                                        'style_set' => ITALIC_COLUMN);

#  gtk_tree_view_append_column (GTK_TREE_VIEW (tree_view),
#			       GTK_TREE_VIEW_COLUMN (column));
  $tree_view->append_column ($column);

#  g_signal_connect (selection, "changed", G_CALLBACK (selection_cb), model);
#  g_signal_connect (tree_view, "row_activated", G_CALLBACK (row_activated_cb), model);
  $selection->signal_connect (changed => \&selection_cb, $model);
  $tree_view->signal_connect (row_activated => \&row_activated_cb, $model);

#  gtk_tree_view_expand_all (GTK_TREE_VIEW (tree_view));
  $tree_view->expand_all;
  return $tree_view;
}

sub setup_default_icon {
#  GdkPixbuf *pixbuf;
#  char *filename;
#  GError *err;
#
#  err = NULL;
#
#  pixbuf = NULL;
#  filename = demo_find_file ("gtk-logo-rgb.gif", &err);
#  if (filename)
#    {
#      pixbuf = gdk_pixbuf_new_from_file (filename, &err);
#      g_free (filename);
#    }
#
#  /* Ignoring this error (passing NULL instead of &err above)
#   * would probably be reasonable for most apps.  We're just
#   * showing off.
#   */
#  if (err)
#    {
#      GtkWidget *dialog;
#      
#      dialog = gtk_message_dialog_new (NULL, 0,
#				       GTK_MESSAGE_ERROR,
#				       GTK_BUTTONS_CLOSE,
#				       "Failed to read icon file: %s",
#				       err->message);
#      g_error_free (err);
#
#      g_signal_connect (dialog, "response",
#			G_CALLBACK (gtk_widget_destroy), NULL);
#    }

  my $pixbuf;
  eval { $pixbuf = Gtk2::Gdk::Pixbuf->new_from_file 
      				(demo_find_file ("gtk-logo-rgb.gif")); };
  if ($@) {
     my $dialog = Gtk2::MessageDialog->new (undef, [], 'error', 'close',
                                            "Failed to read icon file: $@");
     $dialog->signal_connect (response => sub { $_[0]->destroy; 1 });
  }

#  if (pixbuf)
#    {
#      GList *list;      
#      GdkPixbuf *transparent;
#
#      /* The gtk-logo-rgb icon has a white background, make it transparent */
#      transparent = gdk_pixbuf_add_alpha (pixbuf, TRUE, 0xff, 0xff, 0xff);
#
#      list = NULL;
#      list = g_list_append (list, transparent);
#      gtk_window_set_default_icon_list (list);
#      g_list_free (list);
#      g_object_unref (pixbuf);
#      g_object_unref (transparent);
#    }
  if ($pixbuf) {
#      GList *list;      
#      GdkPixbuf *transparent;
#
#      /* The gtk-logo-rgb icon has a white background, make it transparent */
#      transparent = gdk_pixbuf_add_alpha (pixbuf, TRUE, 0xff, 0xff, 0xff);
    my $transparent = $pixbuf->add_alpha (TRUE, 0xff, 0xff, 0xff);
#
#      list = NULL;
#      list = g_list_append (list, transparent);
#      gtk_window_set_default_icon_list (list);
    # only one item on the parameter list, but the parameter list is a list
    Gtk2::Window->set_default_icon_list ($transparent);
#      g_list_free (list);
#      g_object_unref (pixbuf);
#      g_object_unref (transparent);
    }
}

#int
#main (int argc, char **argv)
#{
#  GtkWidget *window;
#  GtkWidget *notebook;
#  GtkWidget *hbox;
#  GtkWidget *tree;
#  GtkTextTag *tag;

Gtk2->init;

setup_default_icon ();
  
# gtk_window_new (GTK_WINDOW_TOPLEVEL);
my $window = Gtk2::Window->new ('toplevel');
#  gtk_window_set_title (GTK_WINDOW (window), "GTK+ Code Demos");
$window->set_title ("Gtk2-Perl Code Demos");
#  g_signal_connect (window, "destroy",
#		    G_CALLBACK (gtk_main_quit), NULL);
$window->signal_connect (destroy => sub { Gtk2->main_quit; 1 });

#  hbox = gtk_hbox_new (FALSE, 0);
#  gtk_container_add (GTK_CONTAINER (window), hbox);
my $hbox = Gtk2::HBox->new (FALSE, 0);
$window->add ($hbox);

my $tree = create_tree ();
#  gtk_box_pack_start (GTK_BOX (hbox), tree, FALSE, FALSE, 0);
$hbox->pack_start ($tree, FALSE, FALSE, 0);

#  notebook = gtk_notebook_new ();
#  gtk_box_pack_start (GTK_BOX (hbox), notebook, TRUE, TRUE, 0);
my $notebook = Gtk2::Notebook->new;
$hbox->pack_start ($notebook, TRUE, TRUE, 0);

#  gtk_notebook_append_page (GTK_NOTEBOOK (notebook),
#			    create_text (&info_buffer, FALSE),
#			    gtk_label_new_with_mnemonic ("_Info"));
$notebook->append_page (create_text (\$info_buffer, FALSE),
			Gtk2::Label->new_with_mnemonic ("_Info"));

#  gtk_notebook_append_page (GTK_NOTEBOOK (notebook),
#			    create_text (&source_buffer, TRUE),
#			    gtk_label_new_with_mnemonic ("_Source"));
$notebook->append_page (create_text (\$source_buffer, TRUE),
			Gtk2::Label->new_with_mnemonic ("_Source"));

  my $tag;
#  tag = gtk_text_buffer_create_tag (info_buffer, "title",
#                                    "font", "Sans 18",
#                                    NULL);
   $tag = $info_buffer->create_tag ("title", font => "Sans 18");

#  tag = gtk_text_buffer_create_tag (source_buffer, "comment",
#				    "foreground", "red",
#                                    NULL);
   $tag = $source_buffer->create_tag ("comment", foreground => "red");
#  tag = gtk_text_buffer_create_tag (source_buffer, "type",
#				    "foreground", "ForestGreen",
#                                    NULL);
   $tag = $source_buffer->create_tag ("type", foreground => "ForestGreen");
#  tag = gtk_text_buffer_create_tag (source_buffer, "string",
#				    "foreground", "RosyBrown",
#				    "weight", PANGO_WEIGHT_BOLD,
#                                    NULL);
   $tag = $source_buffer->create_tag ("string", 
                                      foreground => "RosyBrown",
                                      weight => 'bold');
#  tag = gtk_text_buffer_create_tag (source_buffer, "control",
#				    "foreground", "purple",
#                                    NULL);
   $tag = $source_buffer->create_tag ("control", "foreground", "purple");
#  tag = gtk_text_buffer_create_tag (source_buffer, "preprocessor",
#				    "style", PANGO_STYLE_OBLIQUE,
# 				    "foreground", "burlywood4",
#                                    NULL);
   $tag = $source_buffer->create_tag ('preprocessor', 
                                      style => 'oblique',
                                      foreground => 'burlywood4');
#  tag = gtk_text_buffer_create_tag (source_buffer, "function",
#				    "weight", PANGO_WEIGHT_BOLD,
# 				    "foreground", "DarkGoldenrod4",
#                                    NULL);
   $tag = $source_buffer->create_tag ('function',
                                      weight => 'bold',
                                      foreground => 'DarkGoldenrod4');

#  gtk_window_set_default_size (GTK_WINDOW (window), 600, 400);
#  gtk_widget_show_all (window);
   $window->set_default_size (600, 400);
   $window->show_all;


#  load_file (testgtk_demos[0].filename);
 
  Gtk2->main;

#  return 0;
#}
