#!/bin/bash
trap "kill 0" EXIT

#This program calculates the corrections dGpol

#>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
#>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# path to GROMOS++ dGslv_pbsolv
BIN=/home/ajk88/software/gromos_180917/gromosPlsPls/gromos++/BUILD16_PBSOLV_UPDATE3/programs/dGslv_pbsolv

# system information
SYSTEM="cneg"
LIGAND="ace"
NAME=${LIGAND}_in_${SYSTEM}_open
#------

#settings for dGslv_pbsolv
gridspacing="0.4"
atomstocharge="1:a"
atomsincluded="1-2:a"

[[ -d results_DGpol ]] || mkdir results_DGpol


for LAM in L_0.0 L_0.2 L_0.4 L_0.6 L_0.8 L_1.0
do
    topo="./topo/${LIGAND}_in_${SYSTEM}_open_${LAM}.top"
    cnf="./coord/${LIGAND}_in_${SYSTEM}_open_${LAM}.cnf"

${BIN} \
    @topo $topo \
    @pbc r cog \
    @atoms $atomsincluded \
    @atomsTOcharge $atomstocharge \
    @coord ${cnf} \
    @schemeELEC RF \
    @rcut 1.4 \
    @epsSOLV 66.6 \
    @epsRF 66.6 \
    @gridspacing $gridspacing \
    @probeIAC 5 \
    > ./results_DGpol/OUT_pBsolv_${NAME}_${LAM} 
    
done

#---------------------------
#END END END END END END END
#---------------------------
