/*
 * Copyright 2017 Andrei-Costin Zisu
 *
 * This software is licensed under the GNU Lesser General Public License
 * (version 2.1 or later).  See the COPYING file in this distribution.
 */

namespace Basalt.Widgets {
    public abstract class SidebarParentRowModel : SidebarRowModel {
        
        public signal void items_changed (uint position, uint removed, uint added);
        public signal void expanded_changed (bool expanded);

        public Basalt.Widgets.SidebarStore children { 
            get; 
            private set; 
            default = new Basalt.Widgets.SidebarStore ();
        }

        private bool _expanded;
        public bool expanded {
            get {
                return _expanded;
            }
            set {
                _expanded = value;
                expanded_changed (_expanded);

                foreach (var item in children.root_items) {
                    if (value) {
                        item.show ();
                    } else {
                        item.hide ();
                    }
                }
            }
        }

        public SidebarParentRowModel (string label, bool expanded) {
            Object (label: label, expanded: expanded);
        }

        public SidebarParentRowModel.with_icon_name (string label, string icon_name, bool expanded) {
            Object (label: label, icon_name: icon_name, expanded: expanded);
        }

        construct {
            connect_signals ();
        }

        private void connect_signals () {
            children.items_changed.connect ((position, removed, added) => {
                items_changed (position, removed, added);
            });

            children.item_added.connect (handle_item_added);
            
            level_changed.connect (handle_level_changed);
            
            hide.connect (handle_hide_propagation);
            show.connect (handle_show_propagation);
        }
        
        private void handle_item_added (SidebarRowModel item) {
            if (expanded) {
                item.show ();
            } else {
                item.hide ();
            }
        }

        private void handle_level_changed (uint level) {
            children.level = level;
        }

        private void handle_show_propagation () {
            if (expanded) {                
                foreach (var item in children.root_items) {
                    item.show ();
                }
            }
        }
        
        private void handle_hide_propagation () {
            if (expanded) {
                foreach (var item in children.root_items) {
                    item.hide ();
                }
            }
        }
    }
}