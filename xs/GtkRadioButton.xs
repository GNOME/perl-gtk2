#include "gtk2perl.h"

MODULE = Gtk2::RadioButton	PACKAGE = Gtk2::RadioButton	PREFIX = gtk_radio_button_


 ##GtkWidget*
 ##gtk_radio_button_new (class, group, label=NULL)
 ##	SV * class
 ##	GSList * group
 ##	const gchar * label
 ##    CODE:
 ##	if (label)
 ##		RETVAL = gtk_radio_button_new_with_label (group, label);
 ##	else
 ##		RETVAL = gtk_radio_button_new (group);
 ##    OUTPUT:
 ##	RETVAL

GtkWidget *
gtk_radio_button_new_from_widget (class, group, label=NULL)
	SV * class
	GtkRadioButton_ornull *group
	const gchar * label
    CODE:
	if (label)
		RETVAL = gtk_radio_button_new_with_label_from_widget (group, label);
	else
		RETVAL = gtk_radio_button_new_from_widget (group);
    OUTPUT:
	RETVAL


 # GtkWidget* gtk_radio_button_new_with_mnemonic             (GSList         *group,
 #                                                            const gchar    *label);
 # GtkWidget* gtk_radio_button_new_with_mnemonic_from_widget (GtkRadioButton *group,
 #                                                            const gchar    *label);
 # GSList*    gtk_radio_button_get_group                     (GtkRadioButton *radio_button);
 # void       gtk_radio_button_set_group                     (GtkRadioButton *radio_button,
 #                                                            GSList         *group);

