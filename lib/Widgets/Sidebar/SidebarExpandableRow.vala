/*
 * Copyright 2017 Andrei-Costin Zisu
 *
 * This software is licensed under the GNU Lesser General Public License
 * (version 2.1 or later).  See the COPYING file in this distribution.
 */
 
namespace Basalt.Widgets {
    public class SidebarExpandableRow : SidebarRow {
        public SidebarExpandableRowModel expandable_model {
            get {
                return (SidebarExpandableRowModel) model;
            }
        }

        private Gtk.Button disclosure_button;
        private Gtk.Revealer disclosure_button_revealer;
        private Gtk.Grid row_layout;

        public SidebarExpandableRow (SidebarExpandableRowModel model) {
            Object (model: (SidebarRowModel) model);

            build_ui ();
            connect_signals ();
            load_data ();
        }

        private void build_ui () {
            disclosure_button = new Gtk.Button.from_icon_name ("pan-down-symbolic", Gtk.IconSize.BUTTON);
            disclosure_button.get_style_context ().add_class (Gtk.STYLE_CLASS_FLAT);
            disclosure_button.get_style_context ().remove_class (Gtk.STYLE_CLASS_BUTTON);
            disclosure_button.get_style_context ().add_class ("disclosure-button");

            disclosure_button_revealer = new Gtk.Revealer ();
            disclosure_button_revealer.transition_type = Gtk.RevealerTransitionType.CROSSFADE;
            disclosure_button_revealer.add (disclosure_button);

            row_layout = build_grid ();
            row_layout.insert_column (0);
            row_layout.attach (disclosure_button_revealer, 0, 0, 1, 2);

            add_to_row_box (row_layout);
        }

        protected new void connect_signals () {
            base.connect_signals ();

            expandable_model.children.items_changed.connect (handle_children_items_changed);

            expandable_model.expanded_changed.connect (update_disclosure_button_icon);
            disclosure_button.clicked.connect (toggle_reveal_children);

            disclosure_button_revealer.notify["child-revealed"].connect (handle_disclosure_button_revealer_state_changed);

            expandable_model.show.connect (() => { show (); });
            expandable_model.hide.connect (() => { hide (); });
        }

        private new void load_data () {
            base.load_data ();

            update_disclosure_button_icon (expandable_model.expanded);

            handle_children_items_changed ();
        }

        private void handle_disclosure_button_revealer_state_changed () {
            if (!disclosure_button_revealer.reveal_child) {
                disclosure_button_revealer.visible = false;
            }
        }

        private void handle_children_items_changed () {
            if (expandable_model.children.get_n_items () == 0) {
                disclosure_button_revealer.no_show_all = true;
                disclosure_button_revealer.reveal_child = false;
            } else {
                disclosure_button_revealer.no_show_all = false;
                disclosure_button_revealer.show_all ();
                disclosure_button_revealer.reveal_child = true;
            }
        }

        private void update_disclosure_button_icon (bool expanded) {
            if (expanded) {
                ((Gtk.Image) disclosure_button.image).icon_name = "pan-down-symbolic";
            } else {
                ((Gtk.Image) disclosure_button.image).icon_name = "pan-end-symbolic";
            }
        }

        private void toggle_reveal_children () {
            expandable_model.expanded = !expandable_model.expanded;
        }
    }
}
