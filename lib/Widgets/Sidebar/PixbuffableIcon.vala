/*
 * Copyright 2017 Andrei-Costin Zisu
 *
 * This software is licensed under the GNU Lesser General Public License
 * (version 2.1 or later).  See the COPYING file in this distribution.
 */

namespace Basalt.Widgets {
    private class PixbuffableIcon : Gtk.Stack {
        private Gtk.Image image;
        private CustomPixbuf custom_pixbuf;
        
        public Gdk.Pixbuf pixbuf {
            get {
                return custom_pixbuf.pixbuf;
            }

            set {
                custom_pixbuf.pixbuf = value;
                custom_pixbuf.visible = true;
                image.visible = false;
            }
        }
        
        public string icon_name {
            owned get {
                return image.icon_name;
            }

            set {
                image.icon_name = value;
                image.visible = true;
                custom_pixbuf.visible = false;
            }
        }
        
        construct {
            build_ui (); 
        }
        
        void build_ui () {
            image = new Gtk.Image ();
            image.icon_size = Gtk.IconSize.BUTTON;
            custom_pixbuf = new CustomPixbuf ();
            
            add (image);
            add (custom_pixbuf);
        }
    }
}