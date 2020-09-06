#!/bin/bash
trap "kill 0" EXIT

#This program calculates the corrections dGpol

#>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
#>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# path to GROMOS++ dGslv_pbsolv
BIN=/home/ajk88/software/gromos_180917/gromosPlsPls/gromos++/BUILD16_PBSOLV_UPDATE3/programs/dGslv_pbsolv \

# system information
ID="ligands_in_buckies"
ELEC="RF"
LIGAND="ace"
BUCKY="cneg"
SYSTEM="saline"
NAME=${LIGAND}_in_${BUCKY}_${SYSTEM}

#------
#settings for dGslv_pbsolv
gridspacing="0.04"
atomstocharge="1:a"
atomsincluded="1-2:a"


[[ -d results_DGpol ]] || mkdir results_DGpol

for LAM in L_0.0 L_0.2 L_0.4 L_0.6 L_0.8 L_1.0
do
topo="./topo/${NAME}_${LAM}.top"
cnf="./coord/${NAME}_${LAM}.cnf"

${BIN} \
    @topo $topo \
    @pbc r cog \
    @atoms $atomsincluded \
    @atomsTOcharge $atomstocharge \
    @coord $cnf \
    @schemeELEC RF \
    @epsSOLV 66.6 \
    @rcut 1.4 \
    @epsRF 66.6 \
    @gridspacing $gridspacing \
    @probeIAC 5 \
    @increasegrid 1 1 1 \
    > results_DGpol/OUT_pBsolv_${NAME}_${LAM}
done

#---------------------------
#END END END END END END END
#---------------------------
