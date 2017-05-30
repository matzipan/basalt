/*
 * Copyright 2017 Andrei-Costin Zisu
 *
 * This software is licensed under the GNU Lesser General Public License
 * (version 2.1 or later).  See the COPYING file in this distribution.
 */

namespace Basalt.Widgets {
    private class CustomPixbuf : Gtk.DrawingArea {
        private int HEIGHT = 16;
        private int WIDTH = 16;
        
        private Gdk.Pixbuf _pixbuf;
        public Gdk.Pixbuf pixbuf {
            get {
                return _pixbuf;
            }

            set {
                _pixbuf = value;

                queue_draw ();
            }
        }

        public CustomPixbuf () {
            Object ();
        }

        construct {
            set_size_request (WIDTH, HEIGHT);
        }

        public override bool draw (Cairo.Context context) {
            var width = get_allocated_width ();
            var height = get_allocated_height ();
            var padding_top = (height - HEIGHT) / 2;
            
            if(_pixbuf!=null) {
                var surface = Gdk.cairo_surface_create_from_pixbuf (pixbuf, scale_factor, null);
                context.set_source_surface (surface, 0, padding_top);
            }
            
            context.rectangle (0, 0, width, height);
            context.fill ();

            return Gdk.EVENT_STOP;
        }        
    }
}