# Design Flow
- (Synthesis) verilog - *yosys* -> BLIF netlist - *yosys/abc* -> mapped BLIF netlist - *blifFanout* -> .cel input for placement
- (Placement) (+).cel2 pin placement hints file - *graywolf* -> .pl1,.pl2,.pin placement results - *place2def* -> DEF file
- (Routing) - *qrouter* -> annotated DEF file
- (Display) - *magic* -> SPICE netlist .sim netlist GDS2 output

# Tools
## iverilog
- http://iverilog.icarus.com/

## yosys
- https://github.com/cliffordwolf/yosys/blob/master/README.md

## graywolf
- https://github.com/rubund/graywolf

## qrouter
- http://opencircuitdesign.com/qrouter/

## magic 
- http://opencircuitdesign.com/magic/

## qflow
- http://opencircuitdesign.com/qflow/

# Install
## iverilog
(mac)
- ```$ brew install icarus-verilog```

### gtkwave for displaying waveform for iverilog output
(mac)
- ````$ sudo port install gtkwave```

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

# Run
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