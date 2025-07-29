# compile the design
compile_ultra

# remove dummy ports
remove_unconnected_ports [get_cells -hierarchical *]
remove_unconnected_ports [get_cells -hierarchical *] -blast_buses

# output gate netlist
ungroup -all -flatten
write -format verilog -output $NET_DIR/${DESIGN_NAME}_netlist.v
