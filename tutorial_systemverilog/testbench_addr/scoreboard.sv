/**

*/

class scoreboard;
    
    //creating mailbox handle
    mailbox mon2scb;
    
    //used to count the number of transactions
    int no_transactions;
    
    //constructor
    function new(mailbox mon2scb);
        //getting the mailbox handles from  environment
        this.mon2scb = mon2scb;
    endfunction
    
    //Compares the Actual result with the expected result
    task main;
        transaction trans;
        forever begin
            mon2scb.get(trans);
            if((trans.a + trans.b) == trans.c)
                $display("Result is as Expected");
            else
                $error("Wrong Result.\n\tExpeced: %0d Actual: %0d",(trans.a+trans.b),trans.c);
            no_transactions++;
            trans.display("[ Scoreboard ]");
        end
    endtask
   
endclass