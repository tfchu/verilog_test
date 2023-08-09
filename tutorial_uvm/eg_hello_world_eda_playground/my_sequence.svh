// contains the command, address and data
class my_transaction extends uvm_sequence_item;

  `uvm_object_utils(my_transaction)

  rand bit cmd;
  rand int addr;
  rand int data;

  constraint c_addr { addr >= 0; addr < 256; }
  constraint c_data { data >= 0; data < 256; }

  function new (string name = "");
    super.new(name);
  endfunction

endclass: my_transaction

// contain multiple sequences or sequence items (transaction)
// here we have the sequence item "req" (type my_transaction)
class my_sequence extends uvm_sequence#(my_transaction);

  `uvm_object_utils(my_sequence)

  function new (string name = "");
    super.new(name);
  endfunction

  // where the sequence actually runs 
  // start_item/finish_item are standard methods that are called to send the transaction to the driver 
  // here we instantiate my_transaction, randomize it and send to the driver
  task body;
    repeat(8) begin
      req = my_transaction::type_id::create("req");
      start_item(req);

      if (!req.randomize()) begin
        `uvm_error("MY_SEQUENCE", "Randomize failed.");
      end

      // If using ModelSim, which does not support randomize(),
      // we must randomize item using traditional methods (in Verilog), like
      // req.cmd = $urandom;
      // req.addr = $urandom_range(0, 255);
      // req.data = $urandom_range(0, 255);

      finish_item(req);
    end
  endtask: body

endclass: my_sequence
