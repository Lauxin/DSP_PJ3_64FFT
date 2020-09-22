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
  #  Created        : 2020-05-25 by HLL
  #  Description    : chk_view created
  #                   other targets tidied up
  #  Created        : 2020-05-29 by HLL
  #  Description    : chk_view updated to support 115, 16 and 172 server
  #  Created        : 2020-05-31 by HLL
  #  Description    : SEED and DBUG added
  #                   other parameters reordered
  #
#-------------------------------------------------------------------------------

#*** MAIN BODY *****************************************************************
#--- USAGE -----------------------------
default:
	@ clear
	@ echo "MAKE TARGETS:                                                                                                                     "
	@ echo "                                                                                                                                  "
	@ echo "  clean                                                                                                                           "
	@ echo "    clean                                                                            clean temperary files                        "
	@ echo "    cleanall                                                                         clean all generated files                    "
	@ echo "                                                                                                                                  "
	@ echo "  single targets                                                                                                                  "
	@ echo "    com_view                                                                         elaborate designs with ncverilog             "
	@ echo "                                                                                     show the elaboration warnings and errors     "
	@ echo "    chk_view                                                                         elaborate designs with verdi                 "
	@ echo "                                                                                     show the elaboration warnings and errors     "
	@ echo "    sim              [SEED=<seed>] [debug=<state>]                                   simulate designs with ncverilog              "
	@ echo "                     [DMP_SHM=<state>] [DMP_SHM_BGN=<time>] [DMP_SHM_LVL=<level>]                                                 "
	@ echo "                     [STP_LVL=<state>]                                                                                            "
	@ echo "    sim_view                                                                         show the waveform                            "
	@ echo "    cov              [COV_TOP=<module_name>]                                         do coverage collection with ncverilog        "
	@ echo "    cov_view                                                                         show the coverage reports                    "
	@ echo "                                                                                                                                  "
	@ echo "  regression targets                                                                                                               "
	@ echo "    sim_regr         [SEED=<seed>] [DBUG=<state>]                                    run regression for simulation                "
	@ echo "                     [T_V_DIR=<test_directory>] [T_V_PTN=<test_target>]                                                           "
	@ echo "                     [STP_LVL=<state>]                                                                                            "
	@ echo "                     [DSP_PRM=<state>]                                                                                            "
	@ echo "                     [DMP_SHM=<state>] [DMP_SHM_BGN=<time>] [DMP_SHM_LVL=<level>]                                                 "
	@ echo "                     [BAK_SIM=<state>]                                                                                            "
	@ echo "                     [NUM_JOB=<number>]                                                                                           "
	@ echo "    sim_regr_view                                                                    show the regression results for simulation   "
	@ echo "    cov_regr         [COV_TOP=<module_name>]                                         run regression for coverage                  "
	@ echo "                     [SEED=<seed>] [DBUG=<state>]                                                                                 "
	@ echo "                     [T_V_DIR=<test_directory>] [T_V_PTN=<test_target>]                                                           "
	@ echo "                     [NUM_JOB=<number>]                                                                                           "
	@ echo "    cov_regr_view                                                                    show the regression results for coverage     "
	@ echo "                                                                                                                                   "
	@ echo "  parameters                                                                                                                       "
	@ echo "    COV_TOP                                                                          name of the module to do coverage collection "
	@ echo "    SEED             %d                                                              seed of random function                      "
	@ echo "    DBUG             on / off                                                        enable debug code                            "
	@ echo "    T_V_DIR                                                                          directory of the interested test vectors     "
	@ echo "    T_V_PTN                                                                          pattern of the interested test vectors       "
	@ echo "    STP_LVL          global / local / off                                            stop all/cur/no case when encounter any error"
	@ echo "    DSP_PRM          on / off                                                        display parameters                           "
	@ echo "    DMP_SHM          on / off                                                        dump shm                                     "
	@ echo "    DMP_SHM_BGN      %d                                                              begin time to dump shm                       "
	@ echo "    DMP_SHM_LVL      as (all) / a (just tb)                                          dump level of shm                            "
	@ echo "    BAK_SIM          on / off                                                        backup simulation results                    "
	@ echo "    NUM_JOB          %d                                                              number of jobs running parallelly            "
	@ echo ""


#--- SINGLE TASKS ----------------------
clean:
	@ rm -rf INCA_libs
	@ rm -rf *.bak*
	@ rm -rf *.key*
	@ rm -rf *.log*
	@ rm -rf *.rpt*
	@ rm -rf *.sim*
	@ rm -rf *.tmp*
	@ rm -rf *.txt*
	@ rm -rf *verdi*
	@ rm -rf *novas*

cleanall: clean
	@ rm -rf .simvision
	@ rm -rf simul_data
	@ rm -rf simul_data_regr

com_view: clean
	@  mkdir -p simul_data
	@- ncverilog +elaborate                                \
	             +access+r                                 \
	             +nospecify                                \
	             +ncseq_udp_delay+1                        \
	             +nctop+$(SIM_TOP)                         \
	             +define+SIM_TOP=$(SIM_TOP)                \
	             +define+SIM_TOP_STR=\"$(SIM_TOP)\"        \
	             +define+DUT_TOP=$(DUT_TOP)                \
	             +define+DUT_TOP_STR=\"$(DUT_TOP)\"        \
	             +define+SEED=$(SEED)                      \
	             +define+DBUG=\"$(DBUG)\"                  \
	             +define+STP_LVL=\"$(STP_LVL)\"            \
	             +define+DMP_SHM=\"$(DMP_SHM)\"            \
	             +define+DMP_SHM_BGN=$(DMP_SHM_BGN)        \
	             +define+DMP_SHM_LVL=\"$(DMP_SHM_LVL)\"    \
	             -f $(SRC_LST)                             \
	             -l simul_data/nc_com_and_sim.log
	@  echo '-----------------------------------'
	@  echo '- WARNINGS                        -'
	@  echo '-----------------------------------'
	@- cat simul_data/nc_com_and_sim.log    \
	   | grep    '*W'                       \
	   | grep -v 'MRSTAR'                   \
	   | grep -v 'RECOME'
	@  echo '-----------------------------------'
	@  echo '- ERRORS                          -'
	@  echo '-----------------------------------'
	@- cat simul_data/nc_com_and_sim.log    \
	   | grep    '*E'

chk_view: clean
	@  mkdir -p simul_data
	@  echo 'PLEASE WAIT FOR A LITTLE WHILE...'
	@  verdi -sx                                       \
	         -nogui                                    \
	         +define+SIM_TOP=$(SIM_TOP)                \
	         +define+SIM_TOP_STR=\"$(SIM_TOP)\"        \
	         +define+DUT_TOP=$(DUT_TOP)                \
	         +define+DUT_TOP_STR=\"$(DUT_TOP)\"        \
	         +define+SEED=$(SEED)                      \
	         +define+DBUG=\"$(DBUG)\"                  \
	         +define+STP_LVL=\"$(STP_LVL)\"            \
	         +define+DMP_SHM=\"$(DMP_SHM)\"            \
	         +define+DMP_SHM_BGN=$(DMP_SHM_BGN)        \
	         +define+DMP_SHM_LVL=\"$(DMP_SHM_LVL)\"    \
	         -f $(SIM_LST)                             \
	         -f $(DUT_LST_INC)                         \
	         -f $(DUT_LST_LIB)                         \
	         -f $(DUT_LST_RTL) > /dev/null
	@  cp verdiLog/compiler.log simul_data/verdi_com.log
	@  echo '-----------------------------------'
	@  echo '- WARNINGS                        -'
	@  echo '-----------------------------------'
	@- cat simul_data/verdi_com.log        \
	   | grep -v 'Unknown argument -sx'    \
	   | grep    '*Warning*' -A 1
	@  echo '-----------------------------------'
	@  echo '- ERRORS                          -'
	@  echo '-----------------------------------'
	@- cat simul_data/verdi_com.log    \
	   | grep -v 'redefined'           \
	   | grep    '*Error*'   -A 1      \

sim:
	@ mkdir -p simul_data
	@ ncverilog +access+r                                 \
	            +nospecify                                \
	            +ncseq_udp_delay+1                        \
	            +nctop+$(SIM_TOP)                         \
	            +define+SIM_TOP=$(SIM_TOP)                \
	            +define+SIM_TOP_STR=\"$(SIM_TOP)\"        \
	            +define+DUT_TOP=$(DUT_TOP)                \
	            +define+DUT_TOP_STR=\"$(DUT_TOP)\"        \
	            +define+SEED=$(SEED)                      \
	            +define+DBUG=\"$(DBUG)\"                  \
	            +define+STP_LVL=\"$(STP_LVL)\"            \
	            +define+DMP_SHM=\"$(DMP_SHM)\"            \
	            +define+DMP_SHM_BGN=$(DMP_SHM_BGN)        \
	            +define+DMP_SHM_LVL=\"$(DMP_SHM_LVL)\"    \
	            -f $(SRC_LST)                             \
	            -l simul_data/nc_com_and_sim.log

sim_view:
	@ simvision -64bit    \
	            -waves    \
	            simul_data/wave_form.shm/wave_form.trn &

cov:
	@ ncverilog +access+r                                 \
	            +nospecify                                \
	            +ncseq_udp_delay+1                        \
	            +nctop+$(SIM_TOP)                         \
	            +define+SIM_TOP=$(SIM_TOP)                \
	            +define+SIM_TOP_STR=\"$(SIM_TOP)\"        \
	            +define+DUT_TOP=$(DUT_TOP)                \
	            +define+DUT_TOP_STR=\"$(DUT_TOP)\"        \
	            +nccovdut+$(COV_TOP)                      \
	            +nccoverage+all                           \
	            +nccovworkdir+simul_data                  \
	            -covoverwrite                             \
	            +define+SEED=$(SEED)                      \
	            +define+DBUG=\"$(DBUG)\"                  \
	            +define+STP_LVL=\"global\"                \
	            +define+DMP_SHM=\"off\"                   \
	            +define+DMP_SHM_BGN=$(DMP_SHM_BGN)        \
	            +define+DMP_SHM_LVL=\"$(DMP_SHM_LVL)\"    \
	            -f $(SIM_LST)                             \
	            -l simul_data/nc_com_and_sim.log

cov_view:
	@ iccr -GUI -test "simul_data/scope/test" &


#--- REGRESSION TASKS ------------------
sim_regr: cleanall
	@ clear
	@ chmod a+x ../script/regr.sh
	@ ../script/regr.sh off               \
	                    $(SIM_TOP)        \
	                    $(COV_TOP)        \
	                    $(SEED)           \
	                    $(DBUG)           \
	                    "$(T_V_DIR)"      \
	                    "$(T_V_PTN)"      \
	                    $(STP_LVL)        \
	                    $(DSP_PRM)        \
	                    $(DMP_SHM)        \
	                    $(DMP_SHM_BGN)    \
	                    $(DMP_SHM_LVL)    \
	                    $(BAK_SIM)        \
	                    $(NUM_JOB)        \
	                    | tee sim_regr.log

sim_regr_view:
	@ cat error.log

cov_regr:
	@ clear
	@ chmod a+x ../script/regr.sh
	@ ../script/regr.sh on                \
	                    $(SIM_TOP)        \
	                    $(COV_TOP)        \
	                    $(SEED)           \
	                    $(DBUG)           \
	                    "$(T_V_DIR)"      \
	                    "$(T_V_PTN)"      \
	                    global            \
	                    $(DSP_PRM)        \
	                    off               \
	                    $(DMP_SHM_BGN)    \
	                    $(DMP_SHM_LVL)    \
	                    on                \
	                    $(NUM_JOB)        \
	                    | tee cov_regr.log

cov_regr_view:
	@ echo 'merge simul_data_regr*/*/*/* -output merged_cov' > iccr.tmp
	@ echo 'load_test simul_data_regr*/*/*/merged_cov' >> iccr.tmp
	@ rm -rf simul_data_regr*/*/*/merged_cov
	@ iccr -GUI iccr.tmp &
