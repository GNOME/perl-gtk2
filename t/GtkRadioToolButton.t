#
# $Header$
#

use Gtk2::TestHelper
	# FIXME 2.4
	at_least_version => [2, 3, 0, "Action-based menus are new in 2.4"],
	tests => 1, noinit => 1;

SKIP: { skip "NOT IMPLEMENTED", 1; }
__END__

MODULE = Gtk2::RadioToolButton PACKAGE = Gtk2::RadioToolButton PREFIX = gtk_radio_tool_button_

## this group implementation is similiar to what GtkRadioButton does.

 ## GtkToolItem *gtk_radio_tool_button_new (GSList *group);
GtkToolItem *gtk_radio_tool_button_new (class, SV * member_or_listref=NULL)
    C_ARGS:
	group_from_sv (member_or_listref)

 ## GtkToolItem *gtk_radio_tool_button_new_from_stock (GSList *group, const gchar *stock_id);
GtkToolItem *
gtk_radio_tool_button_new_from_stock (class, member_or_listref, stock_id)
	SV * member_or_listref
	const gchar * stock_id
    C_ARGS:
	group_from_sv (member_or_listref), stock_id

GtkToolItem *gtk_radio_tool_button_new_from_widget (class, GtkRadioToolButton_ornull *group);
    C_ARGS:
	group

GtkToolItem *gtk_radio_tool_button_new_with_stock_from_widget (class, GtkWidget_ornull *group, const gchar *stock_id);
    C_ARGS:
	(GtkRadioToolButton*)group, stock_id

 ##GSList * gtk_radio_tool_button_get_group (GtkRadioToolButton *button);
SV *
gtk_radio_tool_button_get_group (GtkRadioToolButton *button)
    CODE:
	RETVAL = sv_from_group (gtk_radio_tool_button_get_group (button));
    OUTPUT:
	RETVAL

 ##void gtk_radio_tool_button_set_group (GtkRadioToolButton *button, GSList *group);
void
gtk_radio_tool_button_set_group (button, member_or_listref)
	GtkRadioToolButton *button
	SV *member_or_listref
    C_ARGS:
	button, group_from_sv (member_or_listref)

