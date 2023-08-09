//----------------- base_sequence-----------------------------------
class base_sequence extends uvm_sequence;
	`uvm_object_utils (base_sequence)
endclass

//----------------- seq1 -------------------------------------------
class seq1 extends base_sequence;
   `uvm_object_utils (seq1)
endclass

//----------------- seq2 -------------------------------------------
class seq2 extends base_sequence;
   `uvm_object_utils (seq2)
endclass

//----------------- seq3 -------------------------------------------
class seq3 extends base_sequence;
   `uvm_object_utils (seq3)
endclass