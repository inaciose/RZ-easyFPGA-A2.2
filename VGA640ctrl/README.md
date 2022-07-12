VHDL FPGA VGA sync controller to RZ-easyFPGA A2.2

Include controller and demo files

Based on the work of fsmiamoto available at:
- https://github.com/fsmiamoto/EasyFPGA-VGA

Pin defined in file: rz_easyfpga_2_2.qsf


Error: Can't place multiple pins assigned to pin location Pin_101 (IOPAD_X34_Y18_N21)
- On device window, click on "Device and Pin Options"
- Click on "Dual-Purpose Pins"
- For "nCEO" select "Use as regular I/O"
- In "Configuration" make sure that the "Configuration scheme" is "Active Serial (can use Configuration Device)"
