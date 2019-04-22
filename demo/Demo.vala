public class Basalt.Demo : Granite.Application {
    Gtk.Window window;
    Gtk.Paned main_paned;
    Gtk.Stack main_stack;
    Gtk.Button home_button;

    /**
     * Basic app information for Granite.Application. This is used by the About dialog.
     */
    construct {
        application_id = "com.github.matzipan.basalt";
        flags = ApplicationFlags.FLAGS_NONE;

        program_name = "Basalt Demo";
    }

    public override void activate () {
        window = new Gtk.Window ();
        window.window_position = Gtk.WindowPosition.CENTER;
        add_window (window);

        main_stack = new Gtk.Stack ();
        main_stack.transition_type = Gtk.StackTransitionType.SLIDE_LEFT_RIGHT;
        main_paned = new Gtk.Paned (Gtk.Orientation.HORIZONTAL);

        create_headerbar ();
        create_welcome ();
        create_sidebar ();

        window.add (main_stack);
        window.set_default_size (800, 550);
        window.show_all ();
        home_button.hide ();
    }

    private void create_headerbar () {
        var headerbar = new Gtk.HeaderBar ();
        headerbar.title = "Basalt Demo";
        headerbar.show_close_button = true;

        window.set_titlebar (headerbar);
    }

    private void create_welcome () {
        var welcome = new Granite.Widgets.Welcome ("Sample Window", "This is a demo of the Granite library.");
        welcome.append ("tag-new", "Sidebar", "A new widget that can display a list of items organized in categories.");
        
        welcome.activated.connect ((index) => {
            switch (index) {
                case 0:
                    home_button.show ();
                    main_stack.set_visible_child_name ("sidebar");
                    break;
            }
        });
        var scrolled = new Gtk.ScrolledWindow (null, null);
        scrolled.add (welcome);
        main_stack.add_named (scrolled, "welcome");
    }

    private void create_sidebar () {
        var sidebar = new Basalt.Widgets.Sidebar ();

        var mode = new Granite.Widgets.ModeButton ();
        mode.append_text ("Real world");
        mode.append_text ("Stress");
        
        var layout = new Gtk.Grid ();
        layout.row_spacing = 12;
        layout.orientation = Gtk.Orientation.VERTICAL;
        layout.width_request = 650;
        layout.margin = 24;
        layout.add (mode);
        
        var paned = new Gtk.Paned (Gtk.Orientation.HORIZONTAL);
        paned.add (sidebar);
        paned.add (layout);

        main_stack.add_named (paned, "sidebar");
        
        mode.mode_changed.connect (() => {
            foreach (var i in layout.get_children ()) {
                layout.remove (i);
            }
            layout.add (mode);
            
            if (mode.selected == 0) {
                create_sidebar_realworld (layout, sidebar);
            } else {
                create_sidebar_stress (layout, sidebar);
            }
        });
        
    }
    
    private void create_sidebar_realworld (Gtk.Grid layout, Basalt.Widgets.Sidebar sidebar) {
        var store = new Basalt.Widgets.SidebarStore ();
        
        var personal = new Basalt.Widgets.SidebarHeaderModel ("Personal", true);
        store.append (personal);

        personal.children.append (new Basalt.Widgets.SidebarRowModel.with_icon_name ("Home", "user-home"));
        personal.children.append (new Basalt.Widgets.SidebarRowModel.with_icon_name ("Recent", "folder-recent"));
        personal.children.append (new Basalt.Widgets.SidebarRowModel.with_icon_name ("Documents", "folder-documents"));
        personal.children.append (new Basalt.Widgets.SidebarRowModel.with_icon_name ("Music", "folder-music"));
        personal.children.append (new Basalt.Widgets.SidebarRowModel.with_icon_name ("Trash", "user-trash"));
        
        var devices = new Basalt.Widgets.SidebarHeaderModel ("Devices", false);
        store.append(devices);
        
        var file_system = new Basalt.Widgets.SidebarRowModel.with_icon_name ("File System", "drive-harddisk");
        file_system.indicator_level = 0.4;
        devices.children.append (file_system);
        
        var removable_drive = new Basalt.Widgets.SidebarRowModel.with_icon_name ("Removable Drive", "drive-removable-media");
        removable_drive.action_icon_name = "media-eject-symbolic";
        removable_drive.action_visible = true;
        removable_drive.indicator_level = 0.8;
        removable_drive.action_clicked.connect (() => {
            removable_drive.busy = true;
            
            Timeout.add(1000, () => {
                devices.children.remove (removable_drive); 
                return false; 
            });
        });
        removable_drive.popup_menu.connect ((model) => {
            var menu = new Gtk.Menu ();
            
            menu.add (new Gtk.MenuItem.with_label ("Unmount"));
            menu.add (new Gtk.MenuItem.with_label ("Properties"));
            
            menu.show_all ();
            
            return menu;
        });
        devices.children.append (removable_drive);
        
        var inbox = new Basalt.Widgets.SidebarExpandableRowModel.with_icon_name ("Inbox", "mail-inbox", false);
        inbox.badge = 100;
        store.append(inbox);

        var gmail = new Basalt.Widgets.SidebarRowModel.with_icon_name ("Gmail", "mail-inbox");
        gmail.badge = 50;
        inbox.children.append(gmail);
        
        var yahoo = new Basalt.Widgets.SidebarRowModel.with_icon_name ("Yahoo", "mail-inbox");
        yahoo.badge = 50;
        inbox.children.append(yahoo);

        sidebar.bind_model (store);
    }
    
    private void create_sidebar_stress (Gtk.Grid layout, Basalt.Widgets.Sidebar sidebar) {
        // AZ:  Each item has a number in its name. I used this number to check the
        //      items end up in the correct place while in development. This function
        //      also adds items from all over the place, and with all possible
        //      methods. I wanted to make sure most code paths are checked.
        //      So the messy code is on purpose :P

        var store = new Basalt.Widgets.SidebarStore ();

        var test1 = new Basalt.Widgets.SidebarHeaderModel ("Item 1", false);
        test1.tooltip_text = "This is a header item";
        test1.indicator_level = 0.3;

        test1.children.append (new Basalt.Widgets.SidebarRowModel.with_icon_name ("Item 11", "user-home"));
        test1.children.append (new Basalt.Widgets.SidebarRowModel.with_icon_name ("Item 12", "folder-recent"));
        test1.children.append (new Basalt.Widgets.SidebarRowModel.with_icon_name ("Item 13", "folder-documents"));
        test1.children.append (new Basalt.Widgets.SidebarRowModel.with_icon_name ("Item 14", "folder-music"));
        test1.children.append (new Basalt.Widgets.SidebarRowModel.with_icon_name ("Item 15", "user-trash"));

        int width = 16 * layout.scale_factor;
        int height = 16 * layout.scale_factor;
        var drawbuf = new uint8[width*height*3];

        for (int y = 0; y < width; y++) {
          for (int x = 0; x < height; x++) {
            uint pixel_index = y * width * 3 + x * 3;

            drawbuf[pixel_index] = (uint8) (y * 255 / height);
            drawbuf[pixel_index + 1] = (uint8) (128 - (x + y) * 255 / (width * height));
            drawbuf[pixel_index + 2] = (uint8) (x * 255 / width);
          }
        }
        
        var pixbuf = new Gdk.Pixbuf.from_data (drawbuf, Gdk.Colorspace.RGB, false, 8, width, height, width * 3);
        var pixbuf_item = new Basalt.Widgets.SidebarRowModel.with_icon_pixbuf ("Item 12", pixbuf);

        pixbuf_item.action_icon_pixbuf = pixbuf;
        pixbuf_item.action_visible = true;
        pixbuf_item.action_icon_name = "media-eject-symbolic";

        test1.children.append (pixbuf_item);

        store.append (test1);

        test1.children.append (new Basalt.Widgets.SidebarRowModel.with_icon_name ("Item 13", "folder-documents"));
        test1.children.append (new Basalt.Widgets.SidebarRowModel.with_icon_name ("Item 14", "folder-music"));
        test1.children.append (new Basalt.Widgets.SidebarRowModel.with_icon_name ("Item 15", "user-trash"));

        store.append (new Basalt.Widgets.SidebarRowModel.with_icon_name ("Item 2", "user-home"));

        sidebar.bind_model (store);

        var test4 = new Basalt.Widgets.SidebarExpandableRowModel.with_icon_name ("Item 4", "folder-documents", true);
        test4.children.append (new Basalt.Widgets.SidebarRowModel ("Item 41"));
        test4.children.append (new Basalt.Widgets.SidebarRowModel ("Item 42"));

        store.append (test4);

        test4.action_icon_name = "user-trash-symbolic";

        var test43 = new Basalt.Widgets.SidebarExpandableRowModel ("Item 43", false);
        test4.children.append(test43);
        var test431 = new Basalt.Widgets.SidebarRowModel ("Item 431");
        test431.badge = 9;
        test43.children.append(test431);

        store.append (new Basalt.Widgets.SidebarRowModel ("Item 5"));

        store.insert (2, new Basalt.Widgets.SidebarRowModel ("Item 3"));

        var unexpand_button = new Gtk.Button.with_label ("Unexpand");

        unexpand_button.clicked.connect (() => {
                test4.expanded = false;
        });

        var toggle_busy_button = new Gtk.Button.with_label ("Toggle busy");

        toggle_busy_button.clicked.connect (() => {
            test4.busy = !test4.busy;
        });

        var toggle_badge_button = new Gtk.Button.with_label ("Toggle badge");

        toggle_badge_button.clicked.connect (() => {
            if (test4.badge == 0) {
                test4.badge = 100;
            } else {
                test4.badge = 0;
            }
        });

        var remove_row_button = new Gtk.Button.with_label ("Remove children rows");

        remove_row_button.clicked.connect (() => {
            test43.children.remove (test431);
            test1.children.remove_at (0);
            test1.children.remove_at (0);
            test1.children.remove_at (0);
            test1.children.remove_at (0);
            test1.children.remove_at (0);
        });

        var toggle_icon_button = new Gtk.Button.with_label ("Toggle icon");

        toggle_icon_button.clicked.connect (() => {
            if (test4.icon_name != "folder-documents") {
                test4.icon_name = "folder-documents";
            } else {
                test4.icon_name = "";
            }
        });

        var toggle_action_button = new Gtk.Button.with_label ("Toggle action button");

        toggle_action_button.clicked.connect (() => {
            test4.action_visible = !test4.action_visible;
        });

        var added = false;

        var add_new_row_button = new Gtk.Button.with_label ("Add new row");

        add_new_row_button.clicked.connect (() => {
            if (!added) {
                var new_row = new Basalt.Widgets.SidebarRowModel ("Item 44");

                new_row.action_icon_name = "user-home";
                new_row.icon_name = "user-home";
                new_row.badge = 20;

                test4.children.append (new_row);

                new_row.show ();

                added = true;
            }
        });

        layout.add (unexpand_button);
        layout.add (toggle_badge_button);
        layout.add (toggle_action_button);
        layout.add (toggle_busy_button);
        layout.add (toggle_icon_button);
        layout.add (add_new_row_button);
        layout.add (remove_row_button);
        
        layout.show_all ();
    }
}
