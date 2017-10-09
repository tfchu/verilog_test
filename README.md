# Install
## iverilog
(mac)
$ brew install icarus-verilog

## yosys (https://github.com/cliffordwolf/yosys/blob/master/README.md)
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
- copy the 2 xdot.py & xdot.pyc for Python2.7 from ubuntu (brew gets these two files for Python3)
to /usr/local/Cellar/xdot/0.7_1/libexec/lib/python2.7/site-packages/

### gtk+3
(mac)
```$ brew install gtk+3```

### gv for yosys (optional, if xdot does not work)
(mac)
- ```$ brew cask reinstall xquartz```
- ```$ brew install gv```
- ```$ sudo nano /etc/ssh/sshd_config```
  - change `# X11Forwarding no` to `X11Forwarding yes`

# Run
## iverilog (check RTL design)
- write synthesizable code: design.v
- write testbench code: testbench.v
- ```$ iverilog -o testbench.vvp testbench.v    //compile (creates vvp file)```
- ```$ vvp testbench.vvp  //run vvp (creates vcd file)```
- ```$ gtkwave   // view waveform, then select signal and append```

## yosys (logic sythesize)
- ```$ yosys```
- ```yosys> read_verilog design.v```
- ```yosys> techmap      // map the design to default technology```
- ```yosys> opt          // optimize the design```
- ```yosys> show         // show the synthesized result, (alternative) show -format ps -viewer gv```
note: fundamental building block (e.g. NOT gate) are called "cells". Rarely need to look into it. 