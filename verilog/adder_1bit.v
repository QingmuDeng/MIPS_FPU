`define NOT not //#10
`define NAND nand// #20
`define AND and //#30
`define NOR nor// #20
`define OR or //#30
`define XOR xor //#30

module structuralFullAdder
(
    output sum,
    output carryout,
    input a,
    input b,
    input carryin
);
    // Your adder code here
    wire G, P, PandCin;

    `AND generator(G, a, b);
    `XOR propagate(P, a,b);

    `AND carry(PandCin, P, carryin);
    `OR Cout(carryout, PandCin, G);
    `XOR summation(sum, P, carryin);
endmodule
