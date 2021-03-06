/*
 * Copyright 2017 Andrei-Costin Zisu
 *
 * This software is licensed under the GNU Lesser General Public License
 * (version 2.1 or later).  See the COPYING file in this distribution.
 */

namespace Basalt.Widgets {
    public class SidebarRow : Gtk.ListBoxRow {
        public SidebarRowModel model { get; construct; }

        protected Gtk.EventBox row_box;

        private Gtk.Button action_button;
        private PixbuffableIcon action_image;
        private PixbuffableIcon icon;
        private Gtk.Revealer icon_revealer;
        private Gtk.Label badge_label;
        private Gtk.Label row_label;
        private Gtk.Revealer badge_revealer;
        private Gtk.Revealer button_revealer;
        private Gtk.Spinner spinner;
        private IndicatorBar indicator_bar;
        private Gtk.Stack button_stack;

        public SidebarRow (SidebarRowModel model) {
            Object (model: model);

            build_ui ();
            connect_signals ();
            load_data ();
        }

        private void build_ui () {
            add_to_row_box (build_grid ());
        }

        protected Gtk.Grid build_grid () {
            icon = new PixbuffableIcon ();
            icon.get_style_context ().add_class ("icon");

            icon_revealer = new Gtk.Revealer ();
            icon_revealer.transition_type = Gtk.RevealerTransitionType.CROSSFADE;
            icon_revealer.add (icon);

            row_label = new Gtk.Label ("");
            row_label.ellipsize = Pango.EllipsizeMode.END;
            row_label.xalign = 0;
            row_label.hexpand = true;
            row_label.get_style_context ().add_class ("row-label");

            badge_label = new Gtk.Label ("");
            badge_label.get_style_context ().add_class ("badge");
            badge_label.valign = Gtk.Align.CENTER;

            badge_revealer = new Gtk.Revealer ();
            badge_revealer.transition_type = Gtk.RevealerTransitionType.CROSSFADE;
            badge_revealer.add (badge_label);

            action_image = new PixbuffableIcon ();

            action_button = new Gtk.Button ();
            action_button.get_style_context ().add_class (Gtk.STYLE_CLASS_FLAT);
            action_button.get_style_context ().remove_class (Gtk.STYLE_CLASS_BUTTON);
            action_button.image = action_image;

            spinner = new Gtk.Spinner ();

            button_stack = new Gtk.Stack ();
            button_stack.transition_type = Gtk.StackTransitionType.CROSSFADE;
            button_stack.margin_start = 3;
            button_stack.add (action_button);
            button_stack.add (spinner);

            button_revealer = new Gtk.Revealer ();
            button_revealer.transition_type = Gtk.RevealerTransitionType.CROSSFADE;
            button_revealer.add (button_stack);

            indicator_bar = new IndicatorBar ();
            indicator_bar.margin_bottom = 2;

            var layout = new Gtk.Grid ();
            layout.margin_start = (int) model.level * 6 + 8;
            layout.margin_end = 6;
            layout.attach (icon_revealer, 0, 0, 1, 2);
            layout.attach (row_label, 1, 0, 1, 1);
            layout.attach (indicator_bar, 1, 1, 1, 1);
            layout.attach (button_revealer, 3, 0, 1, 2);
            layout.attach (badge_revealer, 2, 0, 1, 2);

            return layout;
        }

        protected void add_to_row_box (Gtk.Widget widget) {
            row_box = new Gtk.EventBox ();
            row_box.add (widget);

            add (row_box);
        }

        protected void connect_signals () {
            action_button.clicked.connect (() => {
                model.action_clicked ();
            });

            model.badge_changed.connect (handle_badge_changed);
            model.icon_name_changed.connect (handle_icon_name_changed);
            model.icon_pixbuf_changed.connect (handle_icon_pixbuf_changed);
            model.label_changed.connect (handle_label_changed);
            model.tooltip_text_changed.connect (handle_tooltip_text_changed);
            model.busy_changed.connect (handle_busy_changed);
            model.action_icon_name_changed.connect (handle_action_icon_name_changed);
            model.action_icon_pixbuf_changed.connect (handle_action_icon_pixbuf_changed);
            model.action_visible_changed.connect (handle_action_visible_changed);
            model.indicator_level_changed.connect (handle_indicator_level_changed);
            model.show.connect (() => { no_show_all = false; show_all (); });
            model.hide.connect (() => { no_show_all = true; hide (); });

            badge_revealer.notify["child-revealed"].connect (handle_badge_revealer_state_changed);
            button_revealer.notify["child-revealed"].connect (handle_button_revealer_state_changed);
            icon_revealer.notify["child-revealed"].connect (handle_icon_revealer_state_changed);

            realize.connect (() => {
                if (model.visible) {
                    show_all ();
                    no_show_all = false;
                } else {
                    hide ();
                    no_show_all = true;
                }
            });

            row_box.set_events (Gdk.EventMask.BUTTON_PRESS_MASK);
        }

        private void menu_position_func (Gtk.Menu menu, ref int x, ref int y, out bool push_in) {
            push_in = true;
        }

        protected void load_data () {
            handle_badge_changed (model.badge);
            handle_label_changed (model.label);
            handle_tooltip_text_changed (model.tooltip_text);
            handle_icon_name_changed (model.icon_name);
            handle_icon_pixbuf_changed (model.icon_pixbuf);
            handle_action_icon_name_changed (model.action_icon_name);
            handle_action_icon_pixbuf_changed (model.action_icon_pixbuf);
            handle_action_visible_changed (model.action_visible);
            handle_busy_changed (model.busy);
            handle_indicator_level_changed (model.indicator_level);
        }

        private void handle_indicator_level_changed (double indicator_level) {
            if (indicator_level < 0) {
                get_style_context ().remove_class ("indicator-present");
                indicator_bar.no_show_all = true;
                indicator_bar.hide ();
            } else {
                get_style_context ().add_class ("indicator-present");
                indicator_bar.no_show_all = false;
                indicator_bar.fill = indicator_level;
                indicator_bar.show_all ();
            }
        }

        private void handle_badge_revealer_state_changed () {
            if (!badge_revealer.reveal_child) {
                badge_revealer.visible = false;
            }
        }

        private void handle_icon_revealer_state_changed () {
            if (!icon_revealer.reveal_child) {
                icon_revealer.visible = false;
            }
        }

        private void handle_button_revealer_state_changed () {
            if (!button_revealer.reveal_child) {
                button_revealer.visible = false;

                if (!model.busy) {
                    spinner.active = false;
                }
            }
        }

        private void handle_badge_changed (uint badge) {
            if (badge != 0) {
                if (badge > 999) {
                    badge_label.label = "∞";
                } else {
                    badge_label.label = badge.to_string ();
                }

                badge_revealer.no_show_all = false;
                badge_revealer.show_all ();
                badge_revealer.reveal_child = true;
            } else {
                badge_revealer.no_show_all = true;
                badge_revealer.reveal_child = false;
            }
        }

        private void handle_label_changed (string label) {
            row_label.set_text (label);
        }

        private void handle_tooltip_text_changed (string? tooltip_text) {
            if (tooltip_text == null) {
                return;
            }

            this.tooltip_text = tooltip_text;
        }

        private void handle_icon_name_changed (string? icon_name) {
            if (icon_name == null || icon_name == "") {
                can_hide_icon ();
            } else {
                icon.icon_name = icon_name;
                icon_revealer.no_show_all = false;
                icon_revealer.show_all ();
                icon_revealer.reveal_child = true;
            }
        }

        private void handle_icon_pixbuf_changed (Gdk.Pixbuf? icon_pixbuf) {
            if (icon_pixbuf == null) {
                can_hide_icon ();
            } else {
                icon.pixbuf = icon_pixbuf;

                icon_revealer.no_show_all = false;
                icon_revealer.show_all ();
                icon_revealer.reveal_child = true;
            }
        }

        private void can_hide_icon () {
            if (model.icon_pixbuf == null && (model.icon_name == null || model.icon_name == "")) {
                icon_revealer.reveal_child = false;
                icon_revealer.no_show_all = true;
            }
        }

        private void handle_action_icon_name_changed (string? action_icon_name) {
            if (action_icon_name == null) {
                return;
            }

            action_image.icon_name = action_icon_name;
        }

        private void handle_action_icon_pixbuf_changed (Gdk.Pixbuf? action_icon_pixbuf) {
            if (action_icon_pixbuf == null) {
                return;
            }

            action_image.pixbuf = action_icon_pixbuf;
        }

        private void handle_action_visible_changed (bool action_visible) {
            if (action_visible) {
                show_button_revealer (action_button);
            } else {
                hide_button_revealer ();
            }
        }

        private void handle_busy_changed (bool busy) {
            if (busy) {
                spinner.active = true;
                show_button_revealer (spinner);
            } else {
                hide_button_revealer ();
            }
        }

        private void show_button_revealer (Gtk.Widget item) {
            button_revealer.no_show_all = false;
            button_revealer.show_all ();
            switch_button_stack_to (item);
            button_revealer.reveal_child = true;
        }

        private void hide_button_revealer () {
            if (model.busy) {
                switch_button_stack_to (spinner);
            } else if (model.action_visible) {
                switch_button_stack_to (action_button);
            } else {
                button_revealer.no_show_all = true;
                button_revealer.reveal_child = false;
            }
        }

        private void switch_button_stack_to (Gtk.Widget item) {
            if (model.busy) {
                button_stack.visible_child = spinner;
            } else {
                button_stack.visible_child = item;
            }
        }

        public void set_bold () {
            row_label.get_style_context ().add_class ("h4");
        }
    }
}
