/**

icarys verilog 0.10.0 coredumped

Synopsys VCS
Hello!
H
e
l
l
o
!
    How are you?
w are you doing?
*/

module tb;

string dialog = "Hello!";       // SV style
reg [16*8 - 1 :0] my_str;       // verilog style, store 16 characters (1 byte per char)

initial begin
    $display("%s", dialog);

    foreach(dialog[i]) begin
        $display("%s", dialog[i]);
    end

    my_str = "How are you?";        // total 16 chars: 4 zero padding + 12 (this string)
    $display("%s", my_str);
    my_str = "How are you doing?";  // total 16 chars: 1st characters "Ho" are truncated
    $display("%s", my_str);
end

endmodule