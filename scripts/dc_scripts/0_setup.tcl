# Setup library
set LIB_PATH     "./lib"
set search_path "$search_path $LIB_PATH"
set synthetic_library "dw_foundation.sldb"
set target_library [list \
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
set link_library "* $synthetic_library $target_library"
set symbol_library "generic.sdb"
set synthetic_library "dw_foundation.sldb"

# Setup environment
set command_log_file "./command.log"
set view_command_log_file "./view_command.log"
set verilogout_no_tri true
set hdlin_ff_always_sync_set_reset "TRUE"
history keep 100
alias h history

