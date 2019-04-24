/*
 * Copyright 2017 Andrei-Costin Zisu
 *
 * This software is licensed under the GNU Lesser General Public License
 * (version 2.1 or later).  See the COPYING file in this distribution.
 */

namespace Basalt.Widgets {
    public class SidebarRowModel : GLib.Object {
        public SidebarStore parent_store { get; private set; }

        public bool visible { get; private set; default = true; }

        // AZ:  I'm not sure how to prevent these from being called from the
        //      outside. It will be overrided as soon as an expand/contract
        //      happens on a parent row.
        public signal void hide ();
        public signal void show ();

        public signal void action_clicked ();

        private uint _level;
        public uint level {
            get {
                return _level;
            }
            set {
                _level = value;

                level_changed (value);
            }
        }
        public signal void level_changed (uint level);

        private double _indicator_level = -1;
        public double indicator_level {
            get {
                return _indicator_level;
            }
            set {
                _indicator_level = value;

                indicator_level_changed (value);
            }
        }
        public signal void indicator_level_changed (double indicator_level);

        private bool _busy;
        public bool busy {
            get {
                return _busy;
            }
            set {
                _busy = value;

                busy_changed (value);
            }
        }
        public signal void busy_changed (bool busy);


        private string _label;
        public string label {
            get {
                return _label;
            }
            construct set {
                _label = value;

                label_changed (value);
            }
        }
        public signal void label_changed (string label);

        private string _tooltip_text;
        public string tooltip_text {
            get {
                return _tooltip_text;
            }
            construct set {
                _tooltip_text = value;

                tooltip_text_changed (value);
            }
        }
        public signal void tooltip_text_changed (string tooltip_text);

        private string _icon_name = "";
        public string icon_name {
            get {
                return _icon_name;
            }
            set {
                _icon_pixbuf = null;
                _icon_name = value;

                icon_name_changed (value);
            }
        }
        public signal void icon_name_changed (string icon_name);

        private string _action_icon_name = "";
        public string action_icon_name {
            get {
                return _action_icon_name;
            }
            set {
                _action_icon_pixbuf = null;
                _action_icon_name = value;

                action_icon_name_changed (value);
            }
        }
        public signal void action_icon_name_changed (string label);

        private Gdk.Pixbuf _icon_pixbuf = null;
        
        /* 
         * The developer is responsible with providing a bigger pixbuf for 
         * hidpi/high scale factor displays.
         */
        public Gdk.Pixbuf icon_pixbuf {
            get {
                return _icon_pixbuf;
            }
            set {
                _icon_name = null;
                _icon_pixbuf = value;

                icon_pixbuf_changed (value);
            }
        }
        public signal void icon_pixbuf_changed (Gdk.Pixbuf icon_pixbuf);

        private Gdk.Pixbuf _action_icon_pixbuf = null;
        
        /* 
         * The developer is responsible with providing a bigger pixbuf for 
         * hidpi/high scale factor displays.
         */
        public Gdk.Pixbuf action_icon_pixbuf {
            get {
                return _action_icon_pixbuf;
            }
            set {
                _action_icon_name = null;
                _action_icon_pixbuf = value;

                action_icon_pixbuf_changed (value);
            }
        }
        public signal void action_icon_pixbuf_changed (Gdk.Pixbuf action_icon_pixbuf);

        private bool _action_visible;
        public bool action_visible {
            get {
                return _action_visible;
            }
            set {
                _action_visible = value;

                action_visible_changed (value);
            }
        }
        public signal void action_visible_changed (bool level);

        private uint _badge;
        public uint badge {
            get {
                return _badge;
            }
            set {
                _badge = value;

                badge_changed (value);
            }
        }
        public signal void badge_changed (uint label);

        public SidebarRowModel (string label) {
            Object(label: label);
        }

        public SidebarRowModel.with_icon_name (string label, string icon_name) {
            Object(label: label, icon_name: icon_name);
        }

        public SidebarRowModel.with_icon_pixbuf (string label, Gdk.Pixbuf icon_pixbuf) {
            Object (label: label, icon_pixbuf: icon_pixbuf);
        }

        construct {
            connect_signals ();
        }

        private void connect_signals () {
            hide.connect (handle_hide);
            show.connect (handle_show);
        }

        private void handle_hide () {
            visible = false;
        }

        private void handle_show () {
            visible = true;
        }

        public void register_parent_store (SidebarStore parent_store) {
            this.parent_store = parent_store;

            parent_store.level_changed.connect(handle_parent_store_level_changed);

            handle_parent_store_level_changed (parent_store.level);
        }

        public void unregister_parent_store () {
            parent_store.level_changed.disconnect (handle_parent_store_level_changed);

            parent_store = null;
        }


        private void handle_parent_store_level_changed (uint level) {
            this.level = level+1;
        }
    }

}
