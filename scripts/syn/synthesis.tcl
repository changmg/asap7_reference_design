# setup environments
set LIB_PATH     "../std_cells"
set search_path "$search_path $LIB_PATH"
set synthetic_library "dw_foundation.sldb"
set target_library [list \
    "$LIB_PATH/asap7sc7p5t_AO_RVT_TT_ccs_211120.db" \
    "$LIB_PATH/asap7sc7p5t_INVBUF_RVT_TT_ccs_211120.db" \
    "$LIB_PATH/asap7sc7p5t_OA_RVT_TT_ccs_211120.db" \
    "$LIB_PATH/asap7sc7p5t_SEQ_RVT_TT_ccs_220123.db" \
    "$LIB_PATH/asap7sc7p5t_SIMPLE_RVT_TT_ccs_211120.db" \
]
set link_library "* $synthetic_library $target_library"
set symbol_library "generic.sdb"
set synthetic_library "dw_foundation.sldb"

# Environment Settings
#set command_log_file "./command.log"
#set view_command_log_file "./view_command.log"
#
#set hdlin_translate_off_skip_text "TRUE"
#set verilogout_no_tri true
#
#set hdlin_ff_always_sync_set_reset "TRUE"
#
#set sh_enable_line_editing true
#set sh_line_editing_mode emacs
#history keep 100
#alias h history
#
#echo "\n\nI am ready...\n"

# set output file name
set OUTPUT_NAME "8x8_w8a8_ampps_s2"

# set directories
set HDL_LOCATION "w8a8_ampps_s2"
set RPT_DIR "./report/$HDL_LOCATION"
set NET_DIR "./netlist/$HDL_LOCATION"
set HDL_DIR "../rtl/$HDL_LOCATION"

# set the TOP_MODULE
set TOP_MODULE "Systolic_array"

# change your timing constraint here
set TEST_CYCLE 1000

source -echo -verbose 0_readfile.tcl 
source -echo -verbose 1_setting.tcl 
source -echo -verbose 2_compile.tcl 
source -echo -verbose 3_report.tcl 

# exit
