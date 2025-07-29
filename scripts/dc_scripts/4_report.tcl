# Naming Rules
set bus_inference_style {%s[%d]}
set bus_naming_style {%s[%d]}
set hdlout_internal_busses true
change_names -rules verilog -hierarchy
define_name_rules name_rule -allowed {a-z A-Z 0-9 _} -max_length 255 -type cell
define_name_rules name_rule -allowed {a-z A-Z 0-9 _[]} -max_length 255 -type net
define_name_rules name_rule -map {{"\\*cell\\*" "cell"}}
define_name_rules name_rule -case_insensitive
change_names -hierarchy -rules name_rule

# report
report_units > $RPT_DIR/report_${DESIGN_NAME}.log
report_timing -path full -delay max -max_paths 1 -nworst 1 -significant_digits 4 >> $RPT_DIR/report_${DESIGN_NAME}.log
report_area >> $RPT_DIR/report_${DESIGN_NAME}.log
# report_constraint -all_violators >> $RPT_DIR/report_${DESIGN_NAME}.log
# note: the power report here is very rough...
report_power >> $RPT_DIR/report_${DESIGN_NAME}.log
