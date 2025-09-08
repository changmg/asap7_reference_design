#========================
# Version selector
#========================
# the script is slightly different for different versions of innovus. please set this variable wit the version number
#set VERSION 17
set VERSION 18
#set VERSION 19
#set VERSION 20
#set VERSION 21

#========================
# Design & paths
#========================
# specify the design name and the top cell
# set DESIGN_NAME "adder"
# set TOP_MODULE "adder"
set DESIGN_NAME "multiplier"
set TOP_MODULE "multiplier"
# init paths
set NET_DIR "./design/$DESIGN_NAME/netlist/"
set RPT_DIR "./design/$DESIGN_NAME/report/"
set OUTPUT_DIR "./design/$DESIGN_NAME/post_pnr/"
set LEF_PATH "./lef/scaled/"
set TLEF_PATH "./techlef/"
# timing constraints/libraries are setup via the MMMC file
set MMMC_FILE "./scripts/mmmc/general.mmmc"
set NETLIST_FILE "${NET_DIR}/${DESIGN_NAME}_netlist.v"

#========================
# Init netlist
#========================
set init_design_uniquify 1
puts "Reading netlist: ${NETLIST_FILE}"
set init_verilog "${NETLIST_FILE}"
set top_name "${TOP_MODULE}"
set init_design_netlisttype {Verilog}
set init_design_settop {1}
 
#========================
# Init LEFs, tech lef first, cell lef later
#========================
set CELL_LEF "$LEF_PATH/asap7sc7p5t_28_L_4x_220121a.lef $LEF_PATH/asap7sc7p5t_28_SL_4x_220121a.lef"
set TECH_LEF $TLEF_PATH/asap7_tech_4x_201209.lef
set init_lef_file "$TECH_LEF $CELL_LEF"

# init design parameters
# Aspect ratio = (core width) / (core height)
set fp_core_cntl {aspect}
set fp_aspect_ratio {1.0000}
set extract_shrink_factor {1.0}
set init_assign_buffer {0}
set init_pwr_net {VDD}
set init_gnd_net {VSS}

#========================
# MMMC
#========================
set init_cpf_file {}
puts "mmmc file: ${MMMC_FILE}"
set init_mmmc_file "${MMMC_FILE}"

#========================
# Initialize the design
#========================
init_design

#========================
# Tech/Process mode
#========================
# defines tech node
if {$VERSION <= 19} {
	setDesignMode -process 7 
} else {
	setDesignMode -process 7 -node N7
}
setMultiCpuUsage -localCpu 8
# Routing layer bounds
if {$VERSION <= 20} {
	setNanoRouteMode -routeBottomRoutingLayer 2
	setNanoRouteMode -routeTopRoutingLayer 7
} else {
	setDesignMode -bottomRoutingLayer 2
    setDesignMode -topRoutingLayer 7
}

#========================
# Logical PG connections
#========================
globalNetConnect VDD -type pgpin -pin VDD -inst * 
globalNetConnect VSS -type pgpin -pin VSS -inst * 

#========================
# Floorplan
#========================
# important: these numbers cannot be chosen arbitrarily, otherwise all VDD/VSS stripes are offgrid or there are no valid vias that can drop on them 
# FP_TARGET is the only variable you can freely modify. this one determines the number of standard cell rows in your design
# FP_MUL controls the aspect ratio. FP_MUL = 5 gives you a perfectly square design
# the additional 0.1 is to account for situations where innovus snaps the fplan and the space becomes too narrow to fit the rings 
set FP_TARGET 165
set FP_MUL 5

set cellheight [expr 0.270 * 4 ]
set cellhgrid  0.216

set fpxdim [expr $cellhgrid * $FP_TARGET * $FP_MUL]
set fpydim [expr $cellheight * $FP_TARGET ]

# Small uniform margins (micron), margins small since no PG rings
set CORE_MARGIN 2.0

# this command prints the snapping rules, it is useful for debugging
fpiGetSnapRule

floorPlan -site asap7sc7p5t -s $fpxdim $fpydim $CORE_MARGIN $CORE_MARGIN $CORE_MARGIN $CORE_MARGIN -noSnap

# the interval setting matches the M3 stripes for saving some resources. 
addWellTap -cell TAPCELL_ASAP7_75t_L -cellInterval 12.960 -inRowOffset 1.296

#========================
# Init Pins
#========================
# Collect ports by direction via dbGet
set in_pins  {}
set out_pins {}
foreach p [dbGet top.terms.name] {
    # Query this port's direction (values are typically "INPUT"/"OUTPUT"/"INOUT")
    set d [dbGet [dbGet -p top.terms.name $p].direction]
    if {[string equal -nocase $d "INPUT"]}  { lappend in_pins  $p }
    if {[string equal -nocase $d "OUTPUT"]} { lappend out_pins $p }
    # If you want to place INOUTs too, add another branch here.
}
puts "in_pins: ${in_pins}"
puts "out_pins: ${out_pins}"

# Let Innovus spread them on the sides and snap to routing tracks
setPinAssignMode -pinEditInBatch true
if {[llength $in_pins]} {
    editPin -fixOverlap 1 -unit TRACK -spacing 3 -spreadDirection clockwise \
            -side Left  -layer 3 -spreadType center -pin $in_pins
    # editPin -side LEFT  -layer 3 -spreadType SIDE -spacing 3 -unit TRACK -pin $in_pins
}
if {[llength $out_pins]} {
    editPin -fixOverlap 1 -unit TRACK -spacing 3 -spreadDirection clockwise \
            -side Right -layer 3 -spreadType center -pin $out_pins
    # editPin -side RIGHT -layer 3 -spreadType SIDE -spacing 3 -unit TRACK -pin $out_pins
}
# # Optional: place INOUTs on Top/Bottom if you have any:
# # if {[llength $io_pins]} { editPin ... -side Top -pin $io_pins }

editPin -snap TRACK -pin *
setPinAssignMode -pinEditInBatch false
legalizePin

#========================
# The initialization of power grid is skipped
# The purpose of this script is only to estimate the power consumption
# Although the power grid is not initialized, the estimation is good
#========================

#========================
# Place & Opt
#========================
place_design

# add tie hi lo at this point. could have been handled in genus too.
setTieHiLoMode -maxFanout 5
addTieHiLo -prefix TIE -cell {TIELOx1_ASAP7_75t_SL TIEHIx1_ASAP7_75t_SL}

# There's no clock in a combinational design
# # CTS
# ccopt_design

set_interactive_constraint_modes [all_constraint_modes -active]
# There's no clock in a combinational design
# reset_propagated_clock [all_clocks]
# if {$VERSION == 21} {
# 	set_propagated_clock [all_clocks]
# 	#update_io_latency -source -verbose
# } else {
# 	set_propagated_clock [all_clocks]
# }

legalizePin  

#========================
# Route
#========================
routeDesign

# for some versions of innovus, silly mistakes are made when assigning colors to vias on the power rings. these lines fix it.
setAnalysisMode -analysisType onChipVariation
setSIMode -enable_glitch_report true
setSIMode -enable_glitch_propagation true
setSIMode -enable_delay_report true

optDesign -postRoute
optDesign -postRoute -hold

#========================
# Design rule check
#========================
verify_drc -report drc_detail.rpt
verifyConnectivity -type all

#========================
# Outputs
#========================
set defOutLefVia 1
set defOutLefNDR 1
defOut -netlist -routing -allLayers ${OUTPUT_DIR}/${top_name}.def
rcOut -rc_corner rc_typ_25 -spef ${OUTPUT_DIR}/${top_name}.spef
saveNetlist ${OUTPUT_DIR}/${top_name}_postpnr.v

#========================
# Reports
#=======================
report_area > ${RPT_DIR}/innovus_${DESIGN_NAME}.log
report_timing >> ${RPT_DIR}/innovus_${DESIGN_NAME}.log
report_power -hierarchy all >> ${RPT_DIR}/innovus_${DESIGN_NAME}.log
