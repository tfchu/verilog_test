/**
class demo

Synopsys VCS
module tb_top
Header = 0x2, Encode = 0, Mode = 0x3, Stop = 1
Header = 0x1, Encode = 0, Mode = 0x5, Stop = 1

module tb_top1
Header = 0x1, Encode = 0, Mode = 0x5, Stop = 1
Header = 0x1, Encode = 0, Mode = 0x5, Stop = 1
Header = 0x1, Encode = 0, Mode = 0x5, Stop = 1

module tb_top2
Header = 0x1, Encode = 0, Mode = 0x5, Stop = 1
Parity = 1, CRC = 0x3
*/
// class declaration
class myPacket;
    // class property
    bit [2:0]   header;
    bit         encode;
    bit [2:0]   mode;
    bit [7:0]   data;
    bit         stop;

    // constructor, set defaults
    function new(bit [2:0] header = 3'h1, bit [2:0] mode = 5);
        this.header = header;   // this: current class
        this.encode = 0;
        this.mode = mode;
        this.stop = 1;
    endfunction

    // class function, use void as the function does not return, otherwise compiler gives warnings
    function void display();
        $display("Header = 0x%0h, Encode = %0b, Mode = 0x%0h, Stop = %0b", this.header, this.encode, this.mode, this.stop);
    endfunction
endclass

// class inheritance
class networkPkt extends myPacket;
    bit         parity;
    bit [1:0]   crc;

    function new();
        super.new();        // call parent class constructor 
        this.parity = 1;
        this.crc = 3;
    endfunction

    function display();
        super.display();    // call parent class function
        $display("Parity = %0b, CRC = 0x%0h", this.parity, this.crc);
    endfunction
endclass

// use the class
module tb_top;
    myPacket pkt0, pkt1;

    initial begin
        pkt0 = new(3'h2, 2'h3); // create a new object, with header = 2, mode = 3
        $display("Header = 0x%0h", pkt0.header);        // access the property
        pkt0.display();                                 // access the function

        pkt1 = new();           // create a new object with default values
        pkt1.display();
    end
endmodule

// class array
module tb_top1;
    myPacket pkt0 [3];

    initial begin
        for(int i = 0; i < $size (pkt0); i++) begin
            pkt0[i] = new();
            pkt0[i].display();
        end
    end
endmodule

// use child class
module tb_top2;
    networkPkt myNetworkPkt;

    initial begin
        myNetworkPkt = new();
        myNetworkPkt.display();
    end
endmodule