/*
 * Copyright 2017 Andrei-Costin Zisu
 *
 * This software is licensed under the GNU Lesser General Public License
 * (version 2.1 or later).  See the COPYING file in this distribution.
 */

namespace Basalt.Widgets {
    public class SidebarExpandableRowModel : SidebarParentRowModel {
        public SidebarExpandableRowModel (string label, bool expanded) {
            Object (label: label, expanded: expanded);
        }

        public SidebarExpandableRowModel.with_icon_name (string label, string icon_name, bool expanded) {
            Object (label: label, icon_name: icon_name, expanded: expanded);
        }

        public SidebarExpandableRowModel.with_icon_pixbuf (string label, Gdk.Pixbuf icon_pixbuf, bool expanded) {
            Object (label: label, icon_pixbuf: icon_pixbuf, expanded: expanded);
        }

    }
}
