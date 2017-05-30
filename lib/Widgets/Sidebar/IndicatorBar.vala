/*
 * Copyright 2017 Andrei-Costin Zisu
 *
 * This software is licensed under the GNU Lesser General Public License
 * (version 2.1 or later).  See the COPYING file in this distribution.
 */

namespace Basalt.Widgets {
    private class IndicatorBar : Gtk.DrawingArea {
        private uint PADDING = 4;
        private int HEIGHT = 4;

        private double _fill = 0;
        public double fill {
            get {
                return _fill;
            }

            set {
                _fill = value;

                queue_draw ();
            }
        }

        public IndicatorBar () {
            Object ();
        }

        construct {
            hexpand = true;

            set_size_request (-1, HEIGHT);
        }

        public override bool draw (Cairo.Context context) {
            var width = get_allocated_width () - 2 * PADDING;
            var fill_width = fill * width;
            var height = get_allocated_height ();
            var x = PADDING;
            var y = 0;

            var style_context = get_style_context ();
            style_context.render_background (context, x, y, width, height);
            style_context.add_class ("fill");
            style_context.render_background (context, x, y, fill_width, height);
            style_context.remove_class ("fill");
            style_context.render_frame (context,  x, y, width, height);

            return Gdk.EVENT_STOP;
        }        
    }
}