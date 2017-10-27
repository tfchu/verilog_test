# Design Flow
- (Synthesis) RTL - ***yosys*** -> BLIF netlist - ***yosys/abc*** -> mapped BLIF netlist - ***blifFanout*** -> .cel input for placement
- (Placement) (+).cel2 pin placement hints file - ***graywolf*** -> .pl1,.pl2,.pin placement results - ***place2def*** -> DEF file
- (Routing) - ***qrouter*** -> annotated DEF file
- (Display) - ***magic*** -> SPICE netlist .sim netlist GDS2 output

# Tools
- [iverilog](http://iverilog.icarus.com/)
- [yosys](https://github.com/cliffordwolf/yosys/blob/master/README.md)
- [graywolf](https://github.com/rubund/graywolf)
- [qrouter](http://opencircuitdesign.com/qrouter/)
- [magic](http://opencircuitdesign.com/magic/)
- [qflow](http://opencircuitdesign.com/qflow/)

# Installation
## iverilog
(mac)
- ```$ brew install icarus-verilog```

### gtkwave for displaying waveform for iverilog output
(mac)
- ```$ sudo port install gtkwave```

note. homebrew no longer supports gtkwave, use mac port instead

## yosys
- ```$ git clone https://github.com/cliffordwolf/yosys```
- go to /yosys
- ```$ brew tap Homebrew/bundle && brew bundle```
- ```$ make config-clang```
- ```$ make```
- ```$ make test```
- ```$ sudo make install```

### xdot for yosys
(mac)
- ```$ brew install xdot```
- copy xdot.py & xdot.pyc for Python2.7 from ubuntu (brew gets these two files for Python3)
to /usr/local/Cellar/xdot/0.7_1/libexec/lib/python2.7/site-packages/

### gtk+3
(mac)
- ```$ brew install gtk+3```

### gv for yosys (optional, if xdot does not work)
(mac)
- ```$ brew cask reinstall xquartz```
- ```$ brew install gv```
- ```$ sudo nano /etc/ssh/sshd_config```
  - change `# X11Forwarding no` to `X11Forwarding yes`

## graywolf
(mac)
- ```git clone https://github.com/rubund/graywolf.git```
- ```cmake .```
  - note. require cmake, which may or may not come with libgsl (required to build graywolf)
- ```make```
- ```make install```

### cmake
(mac)
- download the source code `https://cmake.org/files/v3.9/cmake-3.9.4.tar.gz`
- move the downloaded file to home dir
- `$ cd ~`
- `$ tar zxvf cmake-3.9.4.tar.gz`
- `$ ./bootstrap`
- `$ make`
- `$ make install`

### libgsl for graywolf
(mac)
- ```cd ~```
- ```mkdir gsl```
- ```wget ftp://ftp.gnu.org/gnu/gsl/gsl-2.4.tar.gz```
- ```tar zxvf gsl-2.4.tar.gz```
- ```cd gsl-2.4```
- ```./configure --prefix=/Users/my_home/gsl```
  - configure the installation
- ```make```
  - compile the library
- ```make check```
  - check and test the library
- ```make install```
  - install the library
- use /installation/libgsl.c to test if the installation is good
- how to include in cmake? 

# Execution
## iverilog 
### design file
- write synthesizable code: design.v
- ```$iverilog -o design design.v```
  - compile the code
- ```vvp design```
  - execute the code

### test bench (check RTL design)
- write synthesizable code: design.v
- write testbench code: testbench.sv
- ```$ iverilog -o testbench.vvp testbench.sv```
  - compile (creates vvp file), design.v is used inside testbench hence not called
- ```$ vvp testbench.vvp```
  - run vvp (creates vcd file)
- ```$ gtkwave dump.vcd```
  - open vcd, then select signal and append

## yosys (logic sythesize)
- ```$ yosys```
- ```yosys> read_verilog design.v```
- ```yosys> techmap```
  - map the design to default technology
- ```yosys> opt```
  - optimize the design
- ```yosys> show```
  - show the synthesized result, (alternative) show -format ps -viewer gv

note: fundamental building block (e.g. NOT gate) are called "cells". Rarely need to look into it. 