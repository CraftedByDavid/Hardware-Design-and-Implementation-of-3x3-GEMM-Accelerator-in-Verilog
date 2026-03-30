module matrix(

    input wire clk,         // Clock input

    input wire reset,

    input start,

    output reg [7:0] data_c

);

 wire [31:0] bram_A;

 wire [31:0] bram_B;

   reg [2:0] addr_a_next = 3'b000;

   reg [2:0] addr_b_next = 3'b000;

   reg [3:0] addr_c_next = 4'b0000;

     reg wea = 0;

    reg wec;

     reg ena = 1;

   reg [31:0] din_A = 0, din_B = 0;

    reg done;

    reg [7:0] result;

    reg [2:0] PS, NS; // FSM states

    reg [7:0] temp_a [3:0]; // Temporary storage for BRAM A data

    reg [7:0] temp_b [3:0]; // Temporary storage for BRAM B data

 

 

    // Define FSM states

    parameter [2:0] IDLE = 3'b000;

    parameter [2:0] DELAY = 3'b001;

    parameter [2:0] READ_A = 3'b010;

    parameter [2:0] READ_B_MATRIX_MULT = 3'b011;

    parameter [2:0] INCREMENT_ADDR_B = 3'b100;

    parameter [2:0] INCREMENT_ADDR_A = 3'b101;

    parameter [2:0] DONE = 3'b110;

 

    // Define parameters for BRAM depth and width

    parameter MATRIX_SIZE = 4;

    parameter BRAM_WIDTH = 32;

    integer i;

    // Internal signals

    reg [7:0] temp_result;

    reg [7:0] result1, result2, result3, result4;

    wire clk_out;

   clock_divider uut(

             .clk_100mhz(clk),  

             .clk_1hz(clk_out)) ;

            

    design_1 design_1_i

       (.BRAM_PORTA_0_addr(addr_a_next),

        .BRAM_PORTA_0_clk(clk_out),

        .BRAM_PORTA_0_din(din_A),

        .BRAM_PORTA_0_dout(bram_A),

        .BRAM_PORTA_0_en(ena),

        .BRAM_PORTA_0_we(wea),

        .BRAM_PORTA_1_addr(addr_b_next),

        .BRAM_PORTA_1_clk(clk_out),

        .BRAM_PORTA_1_din(din_B),

        .BRAM_PORTA_1_dout(bram_B),

        .BRAM_PORTA_1_en(ena),

        .BRAM_PORTA_1_we(wea),

        .BRAM_PORTA_2_addr(addr_c_next),

        .BRAM_PORTA_2_clk(clk_out),

        .BRAM_PORTA_2_din(data_c),

        .BRAM_PORTA_2_dout(),

        .BRAM_PORTA_2_en(ena),

        .BRAM_PORTA_2_we(wec));

    // State transition (sequential logic)

    always @(posedge clk_out or posedge reset) begin

        if (reset) begin

            PS <= IDLE;

        end else begin

            PS <= NS;

        end

    end

 

   // Next state logic (combinational logic)

    always @(*) begin

        // Default values to prevent latches

        NS = PS;

     //   wec = 0;

 

       case (PS)

            IDLE: begin

                if (wea == 0 && start) begin

                    NS = DELAY;

                end else begin

                    NS = IDLE;

                end

            end

 

           DELAY: begin

                NS = READ_A;

            end

 

            READ_A: begin

                NS = READ_B_MATRIX_MULT;

            end

            READ_B_MATRIX_MULT: begin

                NS = INCREMENT_ADDR_B;

            end

            INCREMENT_ADDR_B: begin

                if (addr_b_next >= MATRIX_SIZE - 1) begin

                    NS = INCREMENT_ADDR_A; // Transition to INCREMENT_ADDR_A when addr_b_next reaches MATRIX_SIZE-1

 

                end else begin

                    NS = DELAY;

                end

            end

            INCREMENT_ADDR_A: begin

                if (addr_a_next >= MATRIX_SIZE - 1) begin

                    NS = DONE; // Transition to DONE state when addr_a_next reaches MATRIX_SIZE-1

                end else begin

                    NS = IDLE;

                end

            end

            DONE: begin

                if (addr_c_next == 4'b1111) begin

                    done = 1;

                end

            end

 

           default: begin

               NS = IDLE;

            end

        endcase

    end

 

    // Output logic (sequential logic)

    always @(posedge clk_out or posedge reset) begin

        if (reset) begin

            // Reset all outputs and internal signals

            temp_result <= 0;

            addr_a_next <= 3'b000;

            addr_b_next <= 3'b000;

            addr_c_next <= 4'b0000;

            wec <= 0;

        end else begin

            case (PS)

                IDLE: begin

                    // Do nothing

                end

 

               DELAY: begin

                    // Do nothing

                end

                READ_A: begin

                    {temp_a[3], temp_a[2], temp_a[1], temp_a[0]} = bram_A; // Reading data from BRAM A into temp_a

                end

 

                READ_B_MATRIX_MULT: begin

                    {temp_b[3], temp_b[2], temp_b[1], temp_b[0]} = bram_B; // Reading data from BRAM B into temp_b

                    temp_result = 0;

                    wec = 1;

                    result1 = temp_a[0] * temp_b[0];

                    result2 = temp_a[1] * temp_b[1];

                    result3 = temp_a[2] * temp_b[2];

                    result4 = temp_a[3] * temp_b[3];

                    temp_result = result1 + result2 + result3 + result4;

                    case ({addr_a_next, addr_b_next})

                        6'b000_000: addr_c_next = 4'b0000;

                        6'b000_001: addr_c_next = 4'b0001;

                        6'b000_010: addr_c_next = 4'b0010;

                        6'b000_011: addr_c_next = 4'b0011;

                        6'b001_000: addr_c_next = 4'b0100;

                        6'b001_001: addr_c_next = 4'b0101;

                        6'b001_010: addr_c_next = 4'b0110;

                        6'b001_011: addr_c_next = 4'b0111;

                        6'b010_000: addr_c_next = 4'b1000;

                        6'b010_001: addr_c_next = 4'b1001;

                        6'b010_010: addr_c_next = 4'b1010;

                        6'b010_011: addr_c_next = 4'b1011;

                        6'b011_000: addr_c_next = 4'b1100;

                        6'b011_001: addr_c_next = 4'b1101;

                        6'b011_010: addr_c_next = 4'b1110;

                        6'b011_011: addr_c_next = 4'b1111;

                    endcase

                   data_c = temp_result;

                end

 

                INCREMENT_ADDR_B: begin

                    addr_b_next = addr_b_next + 1; // Incrementing addr_b_next

                    if (addr_b_next >= MATRIX_SIZE) begin

                        addr_b_next = 3'b000; // Reset addr_b_next if it reaches MATRIX_SIZE

                    end

                end

 

                INCREMENT_ADDR_A: begin

                    addr_a_next = addr_a_next + 1; // Incrementing addr_a_next

                    if (addr_a_next >= MATRIX_SIZE) begin

                        addr_a_next = 3'b000; // Reset addr_a_next if it reaches MATRIX_SIZE

                    end

                end

                DONE: begin

                    if (addr_c_next == 4'b1111) begin

                        done = 1;

                    end

                end

            endcase

        end

    end

endmodule

 

 

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

endmodule

