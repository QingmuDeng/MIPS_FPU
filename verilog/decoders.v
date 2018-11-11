// 32 bit decoder with enable signal
//   enable=0: all output bits are 0
//   enable=1: out[address] is 1, all other outputs are 0
module decoder1to32
(
output[31:0]	out,
input		enable,
input[4:0]	address
);

    assign out = enable<<address;

endmodule

/*
This decoder utilizes a binary shift operator. It shifts the value of enable
to the left by "address" number of bits. If enable is 0, this will simply
shift 0 to the left by "address" number of places and then pad the most
significant bits with 0s, resulting in all output bits being sent to 0. If
enable is 1, then this shifts that 1 to the left by "address" number of places
and pads the most significant bits with 0 if necessary, which makes out[address]
equal to 1, while leaving all other bits at 0.
*/
