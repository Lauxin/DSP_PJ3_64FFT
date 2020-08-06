#-------------------------------------------------------------------------------
  #
  #  Filename       : makefile
  #  Author         : Huang Leilei
  #  Created        : 2019-06-19
  #  Description    : makefile to run ncsim
  #
#-------------------------------------------------------------------------------
  #
  #  Created        : 2020-03-26 by HLL
  #  Description    : parameters reordered
  #                   variable names tidied up
  #
#-------------------------------------------------------------------------------

#--- INFO ------------------------------
default:
	@ echo "MAKE TARGETS:                                                                                                                     "
	@ echo "                                                                                                                                  "
	@ echo "  clean                                                                                                                           "
	@ echo "    clean                                                                             clean temperary files                       "
	@ echo "    cleanall                                                                          clean all generated files                   "
	@ echo "                                                                                                                                  "
	@ echo "  single targets                                                                                                                  "
	@ echo "    com                                                                               elaborate design with ncverilog             "
	@ echo "    com_view                                                                          grep warn & error message during elaboration"
	@ echo "    sim               [DMP_SHM=<state>] [DMP_SHM_BGN=<time>] [DMP_SHM_LVL=<level>]    simulate design with ncverilog              "
	@ echo "    sim_view                                                                          view waveform genereted during simulation   "
	@ echo "    cov               [COV_TOP=<module_name>]                                         run simulation with coverage                "
	@ echo "    cov_view                                                                          view coverage report                        "
	@ echo "                                                                                                                                  "
	@ echo "  regression targets                                                                                                              "
	@ echo "    sim_regr          [T_V_DIR=<test_directory>] [T_V_TAR=<test_target>]              run regression for simulation               "
	@ echo "                      [DSP_PRM=<state>]                                                                                           "
	@ echo "                      [STP_LVL=<state>]                                                                                           "
	@ echo "                      [DMP_SHM=<state>] [DMP_SHM_BGN=<time>] [DMP_SHM_LVL=<level>]                                                "
	@ echo "                      [BAK_SIM=<state>]                                                                                           "
	@ echo "                      [NUM_JOB=<number>]                                                                                          "
	@ echo "    sim_regr_view                                                                     view regression results of simulation       "
	@ echo "    cov_regr          [COV_TOP=<module_name>]                                         run regression for coverage                 "
	@ echo "                      [T_V_DIR=<test_directory>] [T_V_TAR=<test_target>]                                                          "
	@ echo "                      [DSP_PRM=<state>]                                                                                           "
	@ echo "                      [NUM_JOB=<number>]                                                                                          "
	@ echo "    cov_regr_view                                                                     view regression results of coverage         "
	@ echo "                                                                                                                                  "
	@ echo "  parameters                                                                                                                      "
	@ echo "    COV_TOP                                                                           name of the module to be collected          "
	@ echo "    T_V_DIR                                                                           directory of test vectors                   "
	@ echo "    T_V_TAR                                                                           name/pattern of the targeted test vectors   "
	@ echo "    DSP_PRM        on / off                                                           display parameters                          "
	@ echo "    DMP_SHM        on / off                                                           dump shm                                    "
	@ echo "    DMP_SHM_BGN    %d                                                                 start time to dump shm                      "
	@ echo "    DMP_SHM_LVL    as (all) / a (just tb)                                             dump level of shm                           "
	@ echo "    STP_LVL        global / local / off                                               stop all/cur case when encounter any error  "
	@ echo "    BAK_SIM        on / off                                                           backup simulation results                   "
	@ echo "    NUM_JOB        %d                                                                 number of parallel running job              "




#--- SINGLE TASKS ----------------------
setup:
	@- export prjDir=$(PRJ_DIR)    # bash shell
	@- setenv prjDir $(PRJ_DIR)    # c shell

clean:
	rm -rf INCA_libs
	rm -rf *.bak*
	rm -rf *.key*
	rm -rf *.log*
	rm -rf *.rpt*
	rm -rf *.sim*
	rm -rf *.tmp*
	rm -rf *.txt*
	rm -rf *sim.*
	rm -rf *zoix*
	rm -rf __*__

cleanall:
	rm -rf INCA_libs
	rm -rf *.bak*
	rm -rf *.key*
	rm -rf *.log*
	rm -rf *.rpt*
	rm -rf *.sim*
	rm -rf *.tmp*
	rm -rf *.txt*
	rm -rf *sim.*
	rm -rf *zoix*
	rm -rf __*__
	rm -rf simul_data
	rm -rf simul_data_regr

com:
	@ mkdir -p simul_data
	- ncverilog +elaborate                                \
	            +access+r                                 \
	            +nospecify                                \
	            +nctop+$(T_B_TOP)                         \
	            +define+T_B_TOP=$(T_B_TOP)                \
	            +define+T_B_TOP_STR=\"$(T_B_TOP)\"        \
	            +define+DUT_TOP=$(DUT_TOP)                \
	            +define+DUT_TOP_STR=\"$(DUT_TOP)\"        \
	            +define+STP_LVL=\"$(STP_LVL)\"            \
	            +define+DMP_SHM=\"$(DMP_SHM)\"            \
	            +define+DMP_SHM_BGN=$(DMP_SHM_BGN)        \
	            +define+DMP_SHM_LVL=\"$(DMP_SHM_LVL)\"    \
	            -f $(T_B_LST)                             \
	            -l simul_data/nc_com_and_sim.log

com_view: clean com
	@ echo '-----------------------------------'
	@ echo '- WARNINGS                        -'
	@ echo '-----------------------------------'
	@- cat simul_data/nc_com_and_sim.log    \
	  | grep    '*W'                        \
	  | grep -v 'MACNDF'                    \
	  | grep -v 'MRSTAR'                    \
	  | grep -v 'RECOME'
	@ echo '-----------------------------------'
	@ echo '- ERRORS                          -'
	@ echo '-----------------------------------'
	@- cat simul_data/nc_com_and_sim.log    \
	  | grep    '*E'

sim:
	@ mkdir -p simul_data
	ncverilog +access+r                                 \
	          +nospecify                                \
	          +nctop+$(T_B_TOP)                         \
	          +define+T_B_TOP=$(T_B_TOP)                \
	          +define+T_B_TOP_STR=\"$(T_B_TOP)\"        \
	          +define+DUT_TOP=$(DUT_TOP)                \
	          +define+DUT_TOP_STR=\"$(DUT_TOP)\"        \
	          +define+STP_LVL=\"$(STP_LVL)\"            \
	          +define+DMP_SHM=\"$(DMP_SHM)\"            \
	          +define+DMP_SHM_BGN=$(DMP_SHM_BGN)        \
	          +define+DMP_SHM_LVL=\"$(DMP_SHM_LVL)\"    \
	          -f $(T_B_LST)                             \
	          -l simul_data/nc_com_and_sim.log

sim_view:
	simvision -64bit    \
	          -waves    \
	          simul_data/wave_form.shm/wave_form.trn &

cov:
	ncverilog +access+r                                 \
	          +nospecify                                \
	          +nctop+$(T_B_TOP)                         \
	          +define+T_B_TOP=$(T_B_TOP)                \
	          +define+T_B_TOP_STR=\"$(T_B_TOP)\"        \
	          +define+DUT_TOP=$(DUT_TOP)                \
	          +define+DUT_TOP_STR=\"$(DUT_TOP)\"        \
	          +define+STP_LVL=\"global\"                \
	          +define+DMP_SHM=\"off\"                   \
	          +define+DMP_SHM_BGN=$(DMP_SHM_BGN)        \
	          +define+DMP_SHM_LVL=\"$(DMP_SHM_LVL)\"    \
	          -f $(T_B_LST)                             \
	          +nccovdut+$(COV_TOP)                      \
	          +nccoverage+all                           \
	          +nccovworkdir+simul_data                  \
	          -covoverwrite                             \
	          -l simul_data/nc_com_and_sim.log

cov_view:
	iccr -GUI    \
	     -test "simul_data/scope/test" &




#--- REGRESSION TASKS ------------------
sim_regr: cleanall
	@ clear
	@ chmod a+x ../script/regr.sh
	@ ../script/regr.sh $(T_B_TOP)        \
	                    "off"             \
	                    $(COV_TOP)        \
	                    "$(T_V_DIR)"      \
	                    "$(T_V_TAR)"      \
	                    $(DSP_PRM)        \
	                    $(DMP_SHM)        \
	                    $(DMP_SHM_BGN)    \
	                    $(DMP_SHM_LVL)    \
	                    $(STP_LVL)        \
	                    $(BAK_SIM)        \
	                    $(NUM_JOB)        \
	                    | tee sim_regr.log

sim_regr_view:
	@ cat error.log

cov_regr:
	@ clear
	@ chmod a+x ../script/regr.sh
	@ ../script/regr.sh $(T_B_TOP)        \
	                    "on"              \
	                    $(COV_TOP)        \
	                    "$(T_V_DIR)"      \
	                    "$(T_V_TAR)"      \
	                    $(DSP_PRM)        \
	                    "off"             \
	                    $(DMP_SHM_BGN)    \
	                    $(DMP_SHM_LVL)    \
	                    "global"          \
	                    "on"              \
	                    $(NUM_JOB)        \
	                    | tee cov_regr.log

cov_regr_view:
	@ echo 'merge simul_data_regr*/*/*/* -output merged_cov' > iccr.tmp
	@ echo 'load_test simul_data_regr*/*/*/merged_cov' >> iccr.tmp
	@ rm -rf simul_data_regr*/*/*/merged_cov
	iccr -GUI    \
	     iccr.tmp &
