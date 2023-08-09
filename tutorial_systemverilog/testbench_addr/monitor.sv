/**

*/

class monitor;
   
    //creating virtual interface handle
    virtual intf vif;
    
    //creating mailbox handle
    mailbox mon2scb;
    
    //constructor
    function new(virtual intf vif, mailbox mon2scb);
        //getting the interface
        this.vif = vif;
        //getting the mailbox handles from  environment
        this.mon2scb = mon2scb;
    endfunction
    
    //Samples the interface signal and send the sample packet to scoreboard
    task main;
        forever begin
        transaction trans;
        trans = new();
        @(posedge vif.clk);
        wait(vif.valid);
        trans.a   = vif.a;
        trans.b   = vif.b;
        @(posedge vif.clk);
        trans.c   = vif.c;
        @(posedge vif.clk);
        mon2scb.put(trans);             // send mailbox event when transaction values are monitored 
        trans.display("[ Monitor ]");
        end
    endtask
   
endclass