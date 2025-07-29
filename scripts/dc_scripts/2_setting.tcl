# Setting wireload model
set auto_wire_load_selection area_reselect
set_wire_load_mode enclosed

# Set a relaxed maximum transition time. Default value in ASAP7 is 320
set_max_transition 320 [current_design]

# Setting Timing Constraints
create_clock -name clk -period $CLOCK_CYCLE  [get_ports clk]
set_ideal_network [get_ports clk]
# set_dont_touch_network  [all_clocks]

# I/O delay should depend on the real enironment. Here only shows an example of setting
set_input_delay  [expr $CLOCK_CYCLE*0.5]  -clock clk [remove_from_collection [all_inputs] [get_ports clk]]
set_output_delay [expr $CLOCK_CYCLE*0.5]  -clock clk [all_outputs]

# Area Constraint
# set_max_area   0
