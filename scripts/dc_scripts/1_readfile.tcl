# Expand the list of .v files from the ../hdl directory
set verilog_files [glob $RTL_DIR/*.v]
puts "Verilog files: $verilog_files"

# Read design file
read_verilog $verilog_files

# link the design
current_design $TOP_MODULE
link
