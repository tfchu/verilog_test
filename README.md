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
- `git clone https://github.com/rubund/graywolf.git`
- tell cmake which compiler to use
  - `$ export CC=/usr/local/Cellar/gcc\@5/5.5.0/bin/gcc-5`
  - `$ export CXX=/usr/local/Cellar/gcc\@5/5.5.0/bin/g++-5`
- `cmake .`
  - note. require cmake, which may or may not come with libgsl (required to build graywolf)
- add X11 header path to default search directory
  - `$ ln -s /opt/local/include/X11 /usr/local/include/X11`
- `make`
- `make install`

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

## qflow
### [tutorial](http://opencircuitdesign.com/qflow/tutorial.html)
- `$ cd ~`
- create and enter project folder, create required sub-folders
  - `$ mkdir qflow_tutorial`
  - `$ cd qflow_tutorial`
  - `$ mkdir source synthesis layout`
- download `map9v3.v` from tutorial page, copy to *source* folder
- use qflow to synthesize, place and route the design file
  - `$ qflow synthesize place route map9v3`, sh files created
    - qflow_vars.sh
    - qflow.exec.sh
    - project_vars.sh
- download `load.tcl` from tutorial page, copy to *layout* folder
  - change *lef read /usr/local/share/qflow/...* to */usr/share/qflow/...*
    - qflow v1.1 changed technology file path to */usr/share/qflow/tech/xxx*
    - `$ cat layout/.magicrc` also shows the new path
- use *magic* to add power rails (note. % means in *magic console*)
  - `$ cd layout`
  - `$ magic`
    - `% source load.tcl`
    - `% writeall force map9v3`
    - Under *magic*, View/Full (or type 'v') to see the entire abstract cell view
    - `% quit`
- apply technology file
  - download technology files [here](https://vlsiarch.ecen.okstate.edu/flows/MOSIS_SCMOS/osu_soc_v2.7/osu_soc_v2.7.tar.gz)
  - create a folder and extract the files to the folder, e.g. *~/asic*
  - edit *layout/.magicrc*, add
    - addpath {technology folder}/asic
  - go back to magic to view the physical layout of the technology
    - `$ magic`
      - `% gds read osu35_stdcells.gds2`
      - 