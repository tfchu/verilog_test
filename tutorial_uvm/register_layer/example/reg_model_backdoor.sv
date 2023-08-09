// Assume that ral_cfg_ctl and other "uvm_reg" classes are already
// defined as in the frontdoor example

class ral_block_traffic_cfg extends uvm_reg_block;
	rand ral_cfg_ctl    ctrl;       // RW
	rand ral_cfg_timer  timer[2];   // RW
           ral_cfg_stat   stat;       // RO

	`uvm_object_utils(ral_block_traffic_cfg)

	function new(string name = "traffic_cfg");
		super.new(name, build_coverage(UVM_NO_COVERAGE));
	endfunction

  virtual function void build();
    default_map = create_map("", 0, 4, UVM_LITTLE_ENDIAN, 0);
    ctrl = ral_cfg_ctl::type_id::create("ctrl",,get_full_name());
    ctrl.configure(this, null, "");
    ctrl.build();
    
    // HDL path to this instance is "tb.DUT.ctl_reg"
    ctrl.add_hdl_path_slice("ctl_reg", 0, ctrl.get_n_bits());
    default_map.add_reg(this.ctrl, `UVM_REG_ADDR_WIDTH'h0, "RW", 0);
    
    timer[0] = ral_cfg_timer::type_id::create("timer[0]",,get_full_name());
    timer[0].configure(this, null, "");
    timer[0].build();
    
    // HDL path to this instance is "tb.DUT.timer_0"
    timer[0].add_hdl_path_slice("timer_0", 0, timer[0].get_n_bits());
    default_map.add_reg(this.timer[0], `UVM_REG_ADDR_WIDTH'h4, "RW", 0);

    timer[1] = ral_cfg_timer::type_id::create("timer[1]",,get_full_name());
    timer[1].configure(this, null, "");
    timer[1].build();
    
    // HDL path to this instance is "tb.DUT.timer_1"
    timer[1].add_hdl_path_slice("timer_1", 0, timer[1].get_n_bits());
    default_map.add_reg(this.timer[1], `UVM_REG_ADDR_WIDTH'h8, "RW", 0);

    stat = ral_cfg_stat::type_id::create("stat",,get_full_name());
    stat.configure(this, null, "");
    stat.build();
    
    // HDL path from DUT to the status register will now be 
    // "tb.DUT.stat_reg" after the previous hierarchies are used 
    // for path concatenation
    stat.add_hdl_path_slice("stat_reg", 0, stat.get_n_bits());
    default_map.add_reg(this.stat, `UVM_REG_ADDR_WIDTH'hc, "RO", 0);
    add_hdl_path("DUT");
  endfunction 
endclass 

class ral_sys_traffic extends uvm_reg_block;
    rand ral_block_traffic_cfg cfg;

	`uvm_object_utils(ral_sys_traffic)
	function new(string name = "traffic");
		super.new(name);
	endfunction

	function void build();
               default_map = create_map("", 0, 4, UVM_LITTLE_ENDIAN, 0);
               cfg = ral_block_traffic_cfg::type_id::create("cfg",,get_full_name());
    
               // Since registers exist at the DUT level in our design, configure
               // "cfg" class to have an HDL path called "DUT". So complete path to 
               // DUT is now "tb.DUT"
               cfg.configure(this, "DUT");
               cfg.build();
    
               // Path to this top level regblock in our testbench environment is "tb"
               add_hdl_path("tb");
               default_map.add_submap(this.cfg.default_map, `UVM_REG_ADDR_WIDTH'h0);
	endfunction
endclass