import os
from optparse import OptionParser


def GetOpt():
    parser = OptionParser()
    parser.add_option('-n', '--net',
                      action='store',
                      dest='net',
                      default='./app_mults_test/dc_in/8_8_U_SP_WT_CL_GenMul.v',
                      help='gate netlist file')
    parser.add_option('-t', '--tb',
                      action='store',
                      dest='tb',
                      default='./sign_mult_9x8/sim/sign_mult_9x8_tb.v',
                      help='test bench file')
    options, _ = parser.parse_args()
    return options


args = GetOpt()

# Run the simulation
comm = f"vcs -sverilog -full64 -LDFLAGS -Wl,--no-as-needed -cc gcc-4.8 -cpp g++-4.8 -debug_all +v2k -timescale=1ns/1ps ./lib/asap7sc7p5t_AO_LVT_TT_201020.v ./lib/asap7sc7p5t_INVBUF_LVT_TT_201020.v ./lib/asap7sc7p5t_OA_LVT_TT_201020.v ./lib/asap7sc7p5t_SEQ_LVT_TT_201020.v ./lib/asap7sc7p5t_SIMPLE_LVT_TT_201020.v ./lib/asap7sc7p5t_AO_SLVT_TT_201020.v ./lib/asap7sc7p5t_INVBUF_SLVT_TT_201020.v ./lib/asap7sc7p5t_OA_SLVT_TT_201020.v ./lib/asap7sc7p5t_SEQ_SLVT_TT_201020.v ./lib/asap7sc7p5t_SIMPLE_SLVT_TT_201020.v {args.net} {args.tb}"
print(comm)
os.system(comm)
# comm = f"./simv > ./tmp/vcs_sim.log"
# print(comm)
# os.system(comm)

# # Convert VCD to SAIF
# comm = f"vcd2saif -input temp.vcd -output ./saif/8x8_w8a8_reconf.saif"
# print(comm)
# os.system(comm)