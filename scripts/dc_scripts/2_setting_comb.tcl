# Setting wireload model
set auto_wire_load_selection area_reselect
set_wire_load_mode enclosed

# Set a relaxed maximum transition time. Default value in ASAP7 is 320
set_max_transition 320 [current_design]

# Setting Timing Constraints
set_max_delay $CLOCK_CYCLE -from [all_inputs] -to [all_outputs]

# Set output load
set_load [expr [load_of asap7sc7p5t_INVBUF_LVT_TT_nldm_211120/INVx1_ASAP7_75t_L/A] * 4] [all_outputs]
