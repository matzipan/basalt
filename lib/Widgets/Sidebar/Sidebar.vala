/*
 * Copyright 2017 Andrei-Costin Zisu
 *
 * This software is licensed under the GNU Lesser General Public License
 * (version 2.1 or later).  See the COPYING file in this distribution.
 */

namespace Basalt.Widgets {
    public class Sidebar : Gtk.ScrolledWindow {
        
        private Gtk.ListBox listbox; 
    
        public Sidebar () {
            Object ();
        }
        
        construct {
            build_ui ();
        }

        private void build_ui () {  
            width_request = 176;
            get_style_context ().add_class (Gtk.STYLE_CLASS_SIDEBAR);

            listbox = new Gtk.ListBox ();
            add (listbox);
        }

        public void bind_model (ListModel? model) {
            listbox.bind_model (model, walk_model_items);
            
            listbox.show_all ();
        }
        
        private Gtk.Widget walk_model_items (Object item) {
            assert (item is SidebarRowModel);    

            if (item is SidebarExpandableRowModel) {
                var sidebar_model = (SidebarExpandableRowModel) item;
                
                return new SidebarExpandableRow (sidebar_model);
            } else if (item is SidebarHeaderModel) {
                var sidebar_model = (SidebarHeaderModel) item;
                
                return new SidebarHeader (sidebar_model);
            } else {
                var sidebar_model = (SidebarRowModel) item;

                return new SidebarRow (sidebar_model);
            }


        }
    }
}