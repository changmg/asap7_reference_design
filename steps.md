=================Setup enviroment==================
1. Edit ~/.bashrc as follows:
source /edadk/startup/bashrc
export LC_ALL=C
export LANG=C

2. Source bashrc:
bash> source ~/.bashrc

3. Clone the project:
bash> git clone https://github.com/changmg/asap7_reference_design.git
bash> cd asap7_reference_design/

4. Setup the EDA environment using "edadk.conf"
This file has already been generated in the GIT repository.
"./edadk.conf" specifies the path to the Synopsys & Cadence tools.

================Run DC script (optional)================
bash> dc_shell -f scripts/dc_synth.tcl
Convert RTL (e.g., ./design/multiplier/rtl/multiplier.v) to gate netlist (e.g., ./design/multiplier/netlist/multiplier_netlist.v)

Notes:
1. ./design/multiplier/netlist/multiplier_netlist.v will be used as the starting point of Innovus
2. In "scripts/dc_synth.tcl", use "set CLOCK_CYCLE <MAX_DELAY>" to set the delay constraint. 
In "scripts/dc_synth.tcl", change "DESIGN_NAME" to specify the design file name (e.g., adder, multiplier, ...)
In "scripts/dc_synth.tcl", change "TOP_MODULE" to specify top module.
3. The PPA report by DC is ./design/multiplier/report/dc_multiplier.log

================Run Innovus script===================
bash> innovus -log innovus.log -batch -files scripts/innovus_pnr.tcl

Notes:
1. In "scripts/innovus_pnr.tcl", change "DESIGN_NAME" to specify the design file name (e.g., adder, multiplier, ...)
In "scripts/innovus_pnr.tcl", change "TOP_MODULE" to specify top module.
2. In "scripts/sdc/general.sdc", set the delay constraint
3. The output DEF file is "./design/multiplier/def/top_v18.def"
4. The post PnR PPA report by Innovus is "./design/multiplier/report/innovus_multiplier.log"