
This is an implementation in VHDL of Z80 computer with 8KB ROM, 16KB RAM, Character mode 80x25 on VGA, and PS/2 keyboard. The computer runs MS basic and its  Working on a RZ easyFPGA A2.2, Cyclone IV based board.

It is basicaly an copy from the work available on the following repository, that have a lot of spins of Grant Searle's MultiComp project on various hardware.

- https://github.com/douggilliland/MultiComp

My work was just check the code and notice that with only a litle adaptation done in a toplevel shell, the following multicomp spin works without any changes.

- https://github.com/douggilliland/MultiComp/tree/master/MultiComp_On_Cyclone%20IV%20VGA%20Card/Z80_VGA_PS2_UART_16K

In my little working adaptation, i collect the required components in subdirectories of the root directory of the quartus project, and wrote a litle topshel mainly to adapt the VGA output to the limitations of the RZ easyFPGA A2.2 board.

The quartus project also need the rz_easyfpga_2_2.qsf, file with the pin definitions for the RZ easyFPGA A2.2, Cyclone IV based board


Grant Searle's MultiComp 

http://searle.x10host.com/uk101FPGA/
