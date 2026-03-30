//CLOCK DIVIDER

module clock_divider (

    input wire clk_100mhz,   // 100 MHz input clock

    output reg clk_1hz      // 1 Hz divided clock output

);

reg [31:0] count = 0;

 

always @(posedge clk_100mhz) begin

    if (count == 32'd99999999) begin  // Divide by 100 million (100 MHz / 100 million = 1 Hz)

        clk_1hz <= ~clk_1hz;         // Toggle the output

        count <= 0;

    end else begin

        count <= count + 1;

    end

end
