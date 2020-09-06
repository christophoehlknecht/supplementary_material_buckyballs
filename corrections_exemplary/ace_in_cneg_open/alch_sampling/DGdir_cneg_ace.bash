#!/bin/bash
trap "kill 0" EXIT

#This program calculates the corrections dGpol

#>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
#>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
#path to GROMOS++ ener
BIN="/home/ajk88/software/gromos_180917/gromosPlsPls/gromos++/BUILD16_PBSOLV_UPDATE3/programs/ener"

#system information
SYSTEM="cneg"
LIGAND="ace"
NAME=${LIGAND}_in_${SYSTEM}_open
#------

top_charged="./topo/${LIGAND}_in_${SYSTEM}_open_L_0.0.top"
atomstocharge="1:a"

[[ -d results_DGdir ]] || mkdir results_DGdir

for LAM in L_0.0 L_0.2 L_0.4 L_0.6 L_0.8 L_1.0
do
    cnf="./coord/${LIGAND}_in_${SYSTEM}_open_${LAM}.cnf"

    ## ---------------------
    ## simulation conditions
    ## ---------------------
${BIN} \
    @traj $cnf \
	@topo $top_charged \
	@pbc r cog\
	@atoms "$atomstocharge" \
	@cut 1.4 \
	@eps 66.6 \
	@RFex on \
	@energies 2 \
	> results_DGdir/OUT_ener_${NAME}_${LAM}_sim.out

    ## ----------------------
    ## macroscopic conditions
    ## ----------------------
${BIN} \
    @traj $cnf \
	@topo $top_charged \
	@pbc r cog\
	@atoms "$atomstocharge" \
	@cut 10000 \
	@eps 0 \
	@RFex off \
	@energies 2 \
	> results_DGdir/OUT_ener_${NAME}_${LAM}_macro.out

done
#---------------------------
#END END END END END END END
#---------------------------

