# Design Flow
- (Synthesis) RTL - ***yosys*** -> BLIF netlist - ***yosys/abc*** -> mapped BLIF netlist - ***blifFanout*** -> .cel input for placement
- (Placement) (+).cel2 pin placement hints file - ***graywolf*** -> .pl1,.pl2,.pin placement results - ***place2def*** -> DEF file
- (Routing) - ***qrouter*** -> annotated DEF file
- (Display) - ***magic*** -> SPICE netlist .sim netlist GDS2 output

# Tools Intro
Tool     | Usage
---------|--------------
[iverilog](http://iverilog.icarus.com/) | Verilog simulation and synthesis tool
[yosys](https://github.com/cliffordwolf/yosys/blob/master/README.md) | Verilog parser, high-level synthesis, logic optimization and verification
[abc](https://people.eecs.berkeley.edu/~alanmi/abc/abc.htm) | Logic optimization
[graywolf](https://github.com/rubund/graywolf) | Placement
[qrouter](http://opencircuitdesign.com/qrouter/)* | Over-the-cell (sea-of-gates) detail router
[magic](http://opencircuitdesign.com/magic/)* | VLSI layout editor, extraction, and DRC tool
[qflow](http://opencircuitdesign.com/qflow/)* | a framework for managing a digital synthesis flow using open-source software and open-source standard cell libraries
[netgen](http://opencircuitdesign.com/netgen/index.html)* | Circuit netlist comparison (LVS) and netlist conversion tool (LVS: Layout vs Schematics)
[XCircuit](http://opencircuitdesign.com/xcircuit/index.html)* | Circuit drawing and schematic capture tool
[IRSIM](http://opencircuitdesign.com/irsim/index.html)* | Switch-level digital circuit simulator
[PCB](http://opencircuitdesign.com/pcb/index.html)* | Printed circuit board layout editor
[Opentimer](http://thuang19.web.engr.illinois.edu/software/timer/OpenTimer.html) | STA (static timing analysis) tool
[ngSPICE](http://ngspice.sourceforge.net/) | mixed-level/mixed-signal circuit simulator
[eSIM](http://esim.fossee.in/) | EDA tool for circuit design, simulation, analysis and PCB design
- *OCD (open-circuit-design) software

# Tool Installation (Ubuntu)
- [iverilog](http://iverilog.icarus.com/)
  - `$ sudo apt install iverilog`
- [yosys](https://github.com/cliffordwolf/yosys/blob/master/README.md)
  - method 1: use apt install
    - `$ sudo add-apt-repository ppa:saltmakrell/ppa`
		- `$ sudo apt update`                                                     
	  - `$ sudo apt install yosys`
  - method 2: compile from source
    - `$ sudo apt-get install build-essential clang bison flex libreadline-dev gawk tcl-dev libffi-dev git mercurial graphviz xdot pkg-config python3`
    - `$ git clone https://github.com/cliffordwolf/yosys`
    - `$ cd yosys`
    - `$ make config-gcc`
    - `$ make`
    - `$ make test`
    - `$ sudo make install`
- [graywolf](https://github.com/rubund/graywolf)
  - `$ git clone https://github.com/rubund/graywolf.git`
  - `$ cd graywolf`
  - `$ cmake .`
  - `$ make`
  - `$ make install`
- [qrouter](http://opencircuitdesign.com/qrouter/)
  - `$ sudo apt install qrouter`
- [magic](http://opencircuitdesign.com/magic/)
  - `$ sudo apt install magic`
- [qflow](http://opencircuitdesign.com/qflow/)
  - `$ sudo apt install qflow`
  - note. requires *yosys*, *abc*, *graywolf*, *qrouter*, *magic*
- [netgen](http://opencircuitdesign.com/netgen/index.html)
  - downdload the latest version [here](http://opencircuitdesign.com/netgen/archive/netgen-1.4.81.tgz)
    - get prerequisites tcl-dev, tk-dev
      - `$ sudo apt-cache search tcl` (tcl8.5-dev)
      - `$ sudo apt install tcl8.5-dev`
      - `$ sudo apt-cache search tk` (tk8.5-dev)
      - `$ sudo apt install tk8.5-dev`
  - `$ tar zxvf netgen-1.4.81.tgz`
  - `$ cd netgen-1.4.81`
  - `$ ./configure; make; sudo make install`
# Execution
## iverilog 
- design file
  - write synthesizable code: design.v
  - compile the code
    - `$ iverilog -o design design.v`
  - execute the code
    - `vvp design`

- test bench (check RTL design)
  - write synthesizable code: design.v
  - write testbench code: testbench.sv
  - compile (creates vvp file), design.v is used inside testbench hence not called
  - `$ iverilog -o testbench.vvp testbench.sv`
  - run vvp (creates vcd file)
    - `$ vvp testbench.vvp`
  - open vcd, then select signal and append
    - `$ gtkwave dump.vcd`

## yosys (logic sythesize)
- `$ yosys`
- `yosys> read_verilog design.v`
- map the design to default technology
  - `yosys> techmap`
- optimize the design
  - `yosys> opt`
- show the synthesized result, (alternative) show -format ps -viewer gv  
- `yosys> show`
- note: fundamental building block (e.g. NOT gate) are called "cells". Rarely need to look into it. 

## [qflow tutorial](http://opencircuitdesign.com/qflow/tutorial.html)
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

# Appendix
## Tool Installation (Mac)
- [iverilog](http://iverilog.icarus.com/)
  - (mac) `$ brew install icarus-verilog`
  - gtkwave: *displaying vcd (value change dump) for iverilog output*
    - (linux) `$ sudo apt install gtkwave`
    - (mac) `$ sudo port install gtkwave`
- [yosys](https://github.com/cliffordwolf/yosys/blob/master/README.md)
  - `$ git clone https://github.com/cliffordwolf/yosys`
  - `$ cd yosys`
  - `$ brew tap Homebrew/bundle && brew bundle`
  - `$ make config-clang`
  - `$ make`
  - `$ make test`
  - `$ sudo make install`
  - xdot & gtk3 (for xdot)
    - `$ brew install xdot`
    - copy *xdot.py* & *xdot.pyc* for Python2.7 from ubuntu (brew gets these two files for Python3)
    to */usr/local/Cellar/xdot/0.7_1/libexec/lib/python2.7/site-packages/*
    - `$ brew install gtk+3`
  - gv for yosys (optional, if xdot does not work)
    - `$ brew cask reinstall xquartz`
    - `$ brew install gv`
    - `$ sudo nano /etc/ssh/sshd_config`
      - change *# X11Forwarding no* to *X11Forwarding yes*
- [graywolf](https://github.com/rubund/graywolf)
  - `git clone https://github.com/rubund/graywolf.git`
  - tell cmake which compiler to use
    - `$ export CC=/usr/local/Cellar/gcc\@5/5.5.0/bin/gcc-5`
    - `$ export CXX=/usr/local/Cellar/gcc\@5/5.5.0/bin/g++-5`
  - `cmake .`
    - note. require cmake, which may or may not come with libgsl (required to build graywolf)
  - add X11 header path to default search directory
    - `$ ln -s /opt/local/include/X11 /usr/local/include/X11`
  - `make` (error occurs here)
  - `make install`
- other tools
  - cmake (for graywolf)
    - download the source code `https://cmake.org/files/v3.9/cmake-3.9.4.tar.gz`
    - move the downloaded file to home dir
    - `$ cd ~`
    - `$ tar zxvf cmake-3.9.4.tar.gz`
    - `$ ./bootstrap`
    - `$ make`
    - `$ make install`
  - libgsl (for graywolf)
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