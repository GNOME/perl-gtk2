#include "gtk2perl.h"

/*
struct _GtkActionEntry 
{
  gchar     *name;
  gchar     *stock_id;
  gchar     *label;
  gchar     *accelerator;
  gchar     *tooltip;
  GCallback  callback;
};

struct _GtkToggleActionEntry 
{
  gchar     *name;
  gchar     *stock_id;
  gchar     *label;
  gchar     *accelerator;
  gchar     *tooltip;
  GCallback  callback;
  gboolean   is_active;
};

struct _GtkRadioActionEntry 
{
  gchar *name;
  gchar *stock_id;
  gchar *label;
  gchar *accelerator;
  gchar *tooltip;
  gint   value; 
};
*/

MODULE = Gtk2::ActionGroup	PACKAGE = Gtk2::ActionGroup	PREFIX = gtk_action_group_

GtkActionGroup_noinc *gtk_action_group_new (class, const gchar *name);
    C_ARGS:
	name

const gchar *gtk_action_group_get_name (GtkActionGroup *action_group);

GtkAction *gtk_action_group_get_action (GtkActionGroup *action_group, const gchar *action_name);

void gtk_action_group_list_actions (GtkActionGroup *action_group);
    PREINIT:
	GList * actions, * i;
    PPCODE:
	actions = gtk_action_group_list_actions (action_group);
	for (i = actions ; i != NULL ; i = i->next)
		XPUSHs (sv_2mortal (newSVGtkAction (i->data)));
	g_list_free (actions);

void gtk_action_group_add_action (GtkActionGroup *action_group, GtkAction *action);

void gtk_action_group_remove_action (GtkActionGroup *action_group, GtkAction *action);

## FIXME
##void gtk_action_group_add_actions (GtkActionGroup *action_group, GtkActionEntry *entries, guint n_entries, gpointer user_data);
##void gtk_action_group_add_actions_full (GtkActionGroup *action_group, GtkActionEntry *entries, guint n_entries, gpointer user_data, GDestroyNotify destroy);

## FIXME
##void gtk_action_group_add_toggle_actions (GtkActionGroup *action_group, GtkToggleActionEntry *entries, guint n_entries, gpointer user_data);
##void gtk_action_group_add_toggle_actions_full (GtkActionGroup *action_group, GtkToggleActionEntry *entries, guint n_entries, gpointer user_data, GDestroyNotify destroy);

## FIXME
##void gtk_action_group_add_radio_actions (GtkActionGroup *action_group, GtkRadioActionEntry *entries, guint n_entries, gint value, GCallback on_change, gpointer user_data);
##void gtk_action_group_add_radio_actions_full (GtkActionGroup *action_group, GtkRadioActionEntry *entries, guint n_entries, gint value, GCallback on_change, gpointer user_data, GDestroyNotify destroy);

## FIXME
##void gtk_action_group_set_translate_func (GtkActionGroup *action_group, GtkTranslateFunc func, gpointer data, GtkDestroyNotify notify);

void gtk_action_group_set_translation_domain (GtkActionGroup *action_group, const gchar *domain); 
