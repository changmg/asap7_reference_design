# Setup design parameters
# set DESIGN_NAME "adder"
# set TOP_MODULE "adder"
set DESIGN_NAME "multiplier"
set TOP_MODULE "top"
# change your timing constraint here
set CLOCK_CYCLE 1000 

# Setup directories
set RTL_DIR "./design/$DESIGN_NAME/rtl"
set NET_DIR "./design/$DESIGN_NAME/netlist"
set RPT_DIR "./design/$DESIGN_NAME/report"
if {![file isdirectory $RPT_DIR]} {
    # make parent first if it doesn’t exist
    if {![file isdirectory [file dirname $RPT_DIR]]} {
        file mkdir [file dirname $RPT_DIR]
    }
    file mkdir $RPT_DIR
}
if {![file isdirectory $NET_DIR]} {
    if {![file isdirectory [file dirname $NET_DIR]]} {
        file mkdir [file dirname $NET_DIR]
    }
    file mkdir $NET_DIR
}

source -echo -verbose ./scripts/dc_scripts/0_setup.tcl
source -echo -verbose ./scripts/dc_scripts/1_readfile.tcl 
source -echo -verbose ./scripts/dc_scripts/2_setting_comb.tcl 
source -echo -verbose ./scripts/dc_scripts/3_compile.tcl 
source -echo -verbose ./scripts/dc_scripts/4_report.tcl 

exit
