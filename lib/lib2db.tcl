# -rw-r--r--. 1 cmeng LSI1-unit 22088791 Jul 29 16:13 asap7sc7p5t_AO_LVT_TT_nldm_211120.lib
# -rw-r--r--. 1 cmeng LSI1-unit 22007379 Jul 29 16:13 asap7sc7p5t_AO_SLVT_TT_nldm_211120.lib
# -rw-r--r--. 1 cmeng LSI1-unit   308471 Jul 29 16:13 asap7sc7p5t_INVBUF_LVT_TT_nldm_220122.lib
# -rw-r--r--. 1 cmeng LSI1-unit   307077 Jul 29 16:13 asap7sc7p5t_INVBUF_SLVT_TT_nldm_220122.lib
# -rw-r--r--. 1 cmeng LSI1-unit 19868587 Jul 29 16:13 asap7sc7p5t_OA_LVT_TT_nldm_211120.lib
# -rw-r--r--. 1 cmeng LSI1-unit 19794509 Jul 29 16:13 asap7sc7p5t_OA_SLVT_TT_nldm_211120.lib
# -rw-r--r--. 1 cmeng LSI1-unit  1510902 Jul 29 16:13 asap7sc7p5t_SEQ_LVT_TT_nldm_220123.lib
# -rw-r--r--. 1 cmeng LSI1-unit  1506211 Jul 29 16:13 asap7sc7p5t_SEQ_SLVT_TT_nldm_220123.lib
# -rw-r--r--. 1 cmeng LSI1-unit  2301259 Jul 29 16:13 asap7sc7p5t_SIMPLE_LVT_TT_nldm_211120.lib
# -rw-r--r--. 1 cmeng LSI1-unit  2291693 Jul 29 16:13 asap7sc7p5t_SIMPLE_SLVT_TT_nldm_211120.lib
set lib_files [list \
"./asap7sc7p5t_AO_LVT_TT_nldm_211120.lib"      \
"./asap7sc7p5t_AO_SLVT_TT_nldm_211120.lib"     \
"./asap7sc7p5t_INVBUF_LVT_TT_nldm_220122.lib"  \
"./asap7sc7p5t_INVBUF_SLVT_TT_nldm_220122.lib" \
"./asap7sc7p5t_OA_LVT_TT_nldm_211120.lib"      \
"./asap7sc7p5t_OA_SLVT_TT_nldm_211120.lib"     \
"./asap7sc7p5t_SEQ_LVT_TT_nldm_220123.lib"     \
"./asap7sc7p5t_SEQ_SLVT_TT_nldm_220123.lib"    \
"./asap7sc7p5t_SIMPLE_LVT_TT_nldm_211120.lib"  \
"./asap7sc7p5t_SIMPLE_SLVT_TT_nldm_211120.lib" \
]

# read_lib ./asap7sc7p5t_AO_LVT_TT_nldm_211120.lib
# write_lib asap7sc7p5t_AO_LVT_TT_nldm_211120 -format db -output asap7sc7p5t_AO_LVT_TT_nldm_211120.db

foreach lib_path $lib_files {
    # extract filename without directory
    set filename [file tail $lib_path]
    set basename [file rootname $filename]
    # fix mismatched names in ASAP7 library
    switch -- $lib_path {
        "./asap7sc7p5t_INVBUF_SLVT_TT_nldm_220122.lib" {
            set libname "asap7sc7p5t_INVBUF_SLVT_TT_nldm_211120"
        }
        "./asap7sc7p5t_INVBUF_LVT_TT_nldm_220122.lib" {
            set libname "asap7sc7p5t_INVBUF_LVT_TT_nldm_211120"
        }
        default {
            set libname [file rootname $filename]
        }
    }
    puts "Converting $lib_path to ${basename}.db"
    read_lib $lib_path
    write_lib $libname -format db -output ${basename}.db
}

exit
