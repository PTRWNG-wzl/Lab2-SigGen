module sinegen(
    input logic clk,
    input logic rst,
    input logic [7:0] incr,       // Phase offset from Vbuddy
    output logic [7:0] data1,       // First sinusoid output
    output logic [7:0] data2        // Second sinusoid output
);

    logic [7:0] addr1;              // Address for first ROM port
    logic [7:0] addr2;              // Address for second ROM port
    logic [7:0] rom_data1;          // Data output from first ROM port
    logic [7:0] rom_data2;          // Data output from second ROM port

    // Instance of counter
    counter counter_inst (
        .clk(clk),
        .rst(rst),
        .addr(addr1)              // Connect address output from counter to addr1
    );

    // Instance of dual-port ROM
    rom2ports #(
        .ADDRESS_WIDTH(8),
        .DATA_WIDTH(8)
    ) rom_inst (
        .clk(clk),
        .addr1(addr1),
        .addr2(addr2),
        .dout1(rom_data1),
        .dout2(rom_data2)
    );

    // Assign address for second sinusoid using offset
    assign addr2 = addr1 + offset;

    // Output data for Vbuddy
    assign data1 = rom_data1;
    assign data2 = rom_data2;

    // Display on Vbuddy
    always_ff @(posedge clk) begin
        vbdPlot(data1[7:0]); // Plot first sinusoid
        vbdPlot(data2[7:0]); // Plot second sinusoid
    end

endmodule
