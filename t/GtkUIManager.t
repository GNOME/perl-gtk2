#
# $Header$
#

use Gtk2::TestHelper
	# FIXME 2.4
	at_least_version => [2, 3, 0, "GtkUIManager is new in 2.4"],
	tests => 3, noinit => 1;


my $ui_manager = Gtk2::UIManager->new;
isa_ok ($ui_manager, 'Gtk2::UIManager');

$ui_manager->set_add_tearoffs (TRUE);
ok ($ui_manager->get_add_tearoffs);

$ui_manager->set_add_tearoffs (FALSE);
ok (!$ui_manager->get_add_tearoffs);

__END__

$ui_manager->insert_action_group (GtkActionGroup *action_group, gint pos);

$ui_manager->remove_action_group (GtkActionGroup *action_group);

$ui_manager->get_action_groups

GtkAccelGroup *$ui_manager->get_accel_group

GtkWidget *$ui_manager->get_widget (const gchar *path);

## GSList *$ui_manager->get_toplevels (GtkUIManagerItemType types);
my @toplevels = $ui_manager->get_toplevels (GtkUIManagerItemType types)

GtkAction *$ui_manager->get_action (const gchar *path);

guint $ui_manager->add_ui_from_string (const gchar_length *buffer);

guint $ui_manager->add_ui_from_file (const gchar *filename);

$ui_manager->add_ui (guint merge_id, const gchar *path, const gchar *name, const gchar_ornull *action, GtkUIManagerItemType type, gboolean top);

$ui_manager->remove_ui (guint merge_id);

gchar_own *$ui_manager->get_ui

$ui_manager->ensure_update

guint $ui_manager->new_merge_id


