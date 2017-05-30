/*
 * Copyright 2017 Andrei-Costin Zisu
 *
 * This software is licensed under the GNU Lesser General Public License
 * (version 2.1 or later).  See the COPYING file in this distribution.
 */

namespace Basalt.Widgets {
    public class SidebarHeader : SidebarRow {
        public SidebarHeaderModel header_model {
            get {
                return (SidebarHeaderModel) model;
            }
        }

        private Gtk.Revealer disclosure_image_revealer;
        private Gtk.Image disclosure_image;
        private Gtk.Grid row_layout;
        
        private bool primary_press = false;

        public SidebarHeader (SidebarHeaderModel model) {
            Object (model: (SidebarRowModel) model);
            
            build_ui ();
            connect_signals ();
            load_data ();
        }

        private void build_ui () {
            selectable = false;

            disclosure_image = new Gtk.Image.from_icon_name ("pan-down-symbolic", Gtk.IconSize.BUTTON);

            disclosure_image_revealer = new Gtk.Revealer ();
            disclosure_image_revealer.transition_type = Gtk.RevealerTransitionType.CROSSFADE;
            disclosure_image_revealer.add (disclosure_image);

            row_layout = build_grid ();
            row_layout.attach (disclosure_image_revealer, 4, 0, 1, 2);
            set_bold ();
            
            add_to_row_box (row_layout);
        }

        protected new void connect_signals () {
            base.connect_signals ();
            
            header_model.children.items_changed.connect (handle_children_items_changed);
            
            header_model.expanded_changed.connect (update_disclosure_image);
            
            row_box.set_events (Gdk.EventMask.BUTTON_PRESS_MASK | Gdk.EventMask.BUTTON_RELEASE_MASK);
            row_box.button_press_event.connect ((event) => {
                if (event.type == Gdk.EventType.BUTTON_PRESS) {
                    var button_event = (Gdk.EventButton) event;
                    if (button_event.button == Gdk.BUTTON_PRIMARY) {
                        primary_press = true;
                        return Gdk.EVENT_STOP;
                    } else {
                        primary_press = false;
                    }
                }
                
                return Gdk.EVENT_PROPAGATE;
            });
            
            button_release_event.connect ((event) => {
                if (event.type == Gdk.EventType.BUTTON_RELEASE) {
                    if (primary_press) {
                        toggle_reveal_children ();
                    }

                    primary_press = false;
                    return Gdk.EVENT_STOP;
                }
                
                return Gdk.EVENT_PROPAGATE;
            });

            row_box.enter_notify_event.connect (() => {
                disclosure_image_revealer.reveal_child = true;
                return Gdk.EVENT_PROPAGATE;
            });
            
            row_box.leave_notify_event.connect (() => {
                disclosure_image_revealer.reveal_child = false;
                primary_press = false;

                return Gdk.EVENT_PROPAGATE;
            });
            
            header_model.show.connect (() => { show (); });
            header_model.hide.connect (() => { hide (); });
        }

        private new void load_data () {
            base.load_data ();

            update_disclosure_image (header_model.expanded);
            
            handle_children_items_changed ();
        }

        private void handle_children_items_changed () {
            if (header_model.children.get_n_items () == 0) {
                no_show_all = true;
                hide ();
            } else {
                no_show_all = false;
                show_all ();
            }
        }

        private void update_disclosure_image (bool expanded) {
            if (expanded) {
                disclosure_image.icon_name = "pan-down-symbolic";
            } else {
                disclosure_image.icon_name = "pan-end-symbolic";
            }
        }

        private void toggle_reveal_children () {
            header_model.expanded = !header_model.expanded;
        }
    }
}