/*
 * Copyright 2017 Andrei-Costin Zisu
 *
 * This software is licensed under the GNU Lesser General Public License
 * (version 2.1 or later).  See the COPYING file in this distribution.
 */

namespace Basalt.Widgets {
    public class SidebarHeaderModel : SidebarParentRowModel {
        public SidebarHeaderModel (string label, bool expanded) {
            Object (label: label, expanded: expanded);
        }
    }
}