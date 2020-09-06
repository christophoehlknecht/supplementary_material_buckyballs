#!/bin/bash
trap "kill 0" EXIT

#This program calculates the corrections dGpol

#>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\
\
#>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\
\
#path to GROMOS MD and GROMOS++ ener
BIN="/home/ajk88/software/gromos_180917/gromosPlsPls/gromos++/BUILD16_PBSOLV_UPDATE3/programs/ener"
MD=/home/ajk88/software/gromos_20181008/gromosXX/gromosXX/BUILD16/program/md

ID="ligands_in_buckies"
ELEC="PME"
LIGAND="ace"
BUCKY="cneg"
SYSTEM="saline"
NAME=${LIGAND}_in_${BUCKY}_${SYSTEM}

atomstocharge="1:a"
top_charged="./topo/${NAME}_L_1.0.top"
top_neutral="./topo/${NAME}_L_0.0.top"
[[ -d results_DGdir ]] || mkdir results_DGdir

for LAM in L_0.0 L_0.2 L_0.4 L_0.6 L_0.8 L_1.0
do
    cnf="./coord/${NAME}_${LAM}_vacuum.cnf"
    
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
    
    # -----------------
    # PBC  CALCULATIONS
    # -----------------
    
    $MD \
	@topo $top_charged \
	@conf $cnf \
	@input input_PBC.imd \
	@fin new.cnf | grep "E_El (LS)" \
			    > results_DGdir/OUT_ener_${NAME}_${LAM}_sim_charged.out
    $MD \
	@topo $top_neutral \
	@conf $cnf \
	@input input_PBC.imd \
	@fin new.cnf | grep "E_El (LS)" \
			    > results_DGdir/OUT_ener_${NAME}_${LAM}_sim_neutral.out
    rm new.cnf
done


#---------------------------
#END END END END END END END
#---------------------------
