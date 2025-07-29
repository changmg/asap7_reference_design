###-----------------------------Naming Rules----------------------------
set bus_inference_style {%s[%d]}
set bus_naming_style {%s[%d]}
set hdlout_internal_busses true
change_names -rules verilog -hierarchy
define_name_rules name_rule -allowed {a-z A-Z 0-9 _} -max_length 255 -type cell
define_name_rules name_rule -allowed {a-z A-Z 0-9 _[]} -max_length 255 -type net
define_name_rules name_rule -map {{"\\*cell\\*" "cell"}}
define_name_rules name_rule -case_insensitive
change_names -hierarchy -rules name_rule

###-----------------------------Create directories----------------------------
sh mkdir -p $RPT_DIR
sh mkdir -p $NET_DIR

###---------------------------Syntheis result reports----------------------------
report_units > $RPT_DIR/report_${OUTPUT_NAME}.log
# ===== Timing report =====
# report_timing -delay min -max_paths 4 > $RPT_DIR/report_hold_${OUTPUT_NAME}.log
# report_timing -delay max -max_paths 4 > $RPT_DIR/report_setup_${OUTPUT_NAME}.log
report_timing -path full -delay max -max_paths 1 -nworst 1 -significant_digits 4 >> $RPT_DIR/report_${OUTPUT_NAME}.log

# ===== Area report =====
report_area -hier >> $RPT_DIR/report_${OUTPUT_NAME}.log

# ===== Power report =====
report_power >> $RPT_DIR/report_${OUTPUT_NAME}.log
report_power -hier >> $RPT_DIR/report_${OUTPUT_NAME}.log

# ===== violations =====
report_constraint -all_violators >> $RPT_DIR/report_${OUTPUT_NAME}.log

###--------------------------Netlist-related------------------------------------
# write -format verilog -hierarchy -output $NET_DIR/${OUTPUT_NAME}_syn.v
ungroup -all -flatten
write -format verilog -output $NET_DIR/${OUTPUT_NAME}_syn.v