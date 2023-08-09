/**
demo "inside" opeartor for if or ternary statement

m_data = 4 is inside [4:9], flag=1
m_data = 1 is NOT inside [4:9], flag=0
m_data = 9 is inside [4:9], flag=1
m_data = 3 is NOT inside [4:9], flag=0
m_data = 13 is NOT inside [4:9], flag=0
m_data = 13 is NOT inside [4:9], flag=0
m_data = 5 is inside [4:9], flag=1
m_data = 2 is NOT inside [4:9], flag=0
m_data = 1 is NOT inside [4:9], flag=0
m_data = 13 is NOT inside [4:9], flag=0
*/

module tb_inside_if;
    bit [3:0] m_data;
    bit flag;

    initial begin
        for (int i = 0; i < 10; i++) begin
            m_data = $random;

            flag = m_data inside {[4:9]}? 1 : 0;  // if m_data is inside 4 ~ 9 (inclusive), then flag is 1. else then flag is 0. 

            if (m_data inside {[4:9]})            // if m_data is inside 4 ~ 9 (inclusive)
                $display("m_data = %0d is inside [4:9], flag=%0d", m_data, flag);
            else
                $display("m_data = %0d is NOT inside [4:9], flag=%0d", m_data, flag);
        end
    end

endmodule