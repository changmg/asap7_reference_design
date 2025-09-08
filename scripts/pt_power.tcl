# Setup library
set LIB_PATH     "./lib"
set_app_var search_path "$search_path $LIB_PATH"
set_app_var target_library [list \
    "asap7sc7p5t_AO_LVT_TT_nldm_211120.db"      \
    "asap7sc7p5t_AO_SLVT_TT_nldm_211120.db"     \
    "asap7sc7p5t_INVBUF_LVT_TT_nldm_220122.db"  \
    "asap7sc7p5t_INVBUF_SLVT_TT_nldm_220122.db" \
    "asap7sc7p5t_OA_LVT_TT_nldm_211120.db"      \
    "asap7sc7p5t_OA_SLVT_TT_nldm_211120.db"     \
    "asap7sc7p5t_SEQ_LVT_TT_nldm_220123.db"     \
    "asap7sc7p5t_SEQ_SLVT_TT_nldm_220123.db"    \
    "asap7sc7p5t_SIMPLE_LVT_TT_nldm_211120.db"  \
    "asap7sc7p5t_SIMPLE_SLVT_TT_nldm_211120.db" \
]
set_app_var link_library   "* $target_library"
set_app_var power_enable_analysis true

# read files
set DESIGN_FOLDER "./design/multiplier/"
set TOP_MODULE multiplier
set VERILOG_FILE "$DESIGN_FOLDER/post_pnr/${TOP_MODULE}_postpnr.v"
set SPEF_FILE "$DESIGN_FOLDER/post_pnr/${TOP_MODULE}.spef"
set SAIF_FILE "$DESIGN_FOLDER/sim/${TOP_MODULE}.saif"
set REPORT_FILE "$DESIGN_FOLDER/report/post_pnr_power.log"
read_verilog $VERILOG_FILE
current_design $TOP_MODULE
link_design
# create_clock clk -name ideal_clock -period 10

# source ./SYNTH/post-synth.namemap
read_saif ${SAIF_FILE} -strip_path "${TOP_MODULE}_tb"
read_parasitics -format spef "${SPEF_FILE}"
update_power
report_power -nosplit -hierarchy > ${REPORT_FILE}

exit