[CCode (cprefix = "Egg", gir_namespace = "Egg", gir_version = "0.1", lower_case_cprefix = "egg_")]
namespace Egg {
	[CCode (cheader_filename = "eggwrapbox.h", type_id = "egg_wrap_box_get_type ()")]
	public class WrapBox : Gtk.Container {
		[CCode (has_construct_function = false)]
		public WrapBox (Egg.WrapAllocationMode mode, Egg.WrapBoxSpreading horizontal_spreading, Egg.WrapBoxSpreading vertical_spreading, uint horizontal_spacing, uint vertical_spacing);
		public Egg.WrapAllocationMode get_allocation_mode ();
		public uint get_horizontal_spacing ();
		public Egg.WrapBoxSpreading get_horizontal_spreading ();
		public uint get_minimum_line_children ();
		public uint get_natural_line_children ();
		public uint get_vertical_spacing ();
		public Egg.WrapBoxSpreading get_vertical_spreading ();
		public void set_allocation_mode (Egg.WrapAllocationMode mode);
		public void set_horizontal_spacing (uint spacing);
		public void set_horizontal_spreading (Egg.WrapBoxSpreading spreading);
		public void set_minimum_line_children (uint n_children);
		public void set_natural_line_children (uint n_children);
		public void set_vertical_spacing (uint spacing);
		public void set_vertical_spreading (Egg.WrapBoxSpreading spreading);
		public uint allocation_mode { get; set; }
		public uint horizontal_spacing { get; set; }
		public uint horizontal_spreading { get; set; }
		public uint minimum_line_children { get; set; }
		public uint natural_line_children { get; set; }
		public uint vertical_spacing { get; set; }
		public uint vertical_spreading { get; set; }
	}
	[CCode (cheader_filename = "eggwrapbox.h", cprefix = "EGG_WRAP_ALLOCATE_", has_type_id = false)]
	public enum WrapAllocationMode {
		FREE,
		ALIGNED,
		HOMOGENEOUS
	}
	[CCode (cheader_filename = "eggwrapbox.h", cprefix = "EGG_WRAP_BOX_", has_type_id = false)]
	[Flags]
	public enum WrapBoxPacking {
		H_EXPAND,
		V_EXPAND
	}
	[CCode (cheader_filename = "eggwrapbox.h", cprefix = "EGG_WRAP_BOX_SPREAD_", has_type_id = false)]
	public enum WrapBoxSpreading {
		START,
		END,
		EVEN,
		EXPAND
	}
}
