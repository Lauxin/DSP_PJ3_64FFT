.EXPORT_ALL_VARIABLES:
PRJ_DIR        := ..

SRC_LST        := sim_file_list.f

DUT_TOP        := fft_core8
SIM_TOP        ?= sim_$(DUT_TOP)

COV_TOP        ?= $(DUT_TOP)

SEED           ?= 0
DBUG           ?= off

T_V_DIR        ?= check_data
T_V_PTN        ?= none

STP_LVL        ?= local

DSP_PRM        ?= off

DMP_SHM        ?= off
DMP_SHM_BGN    ?= 0
DMP_SHM_LVL    ?= ASTF

BAK_SIM        ?= off

NUM_JOB        ?= 1

include ../script/makefile.mk
