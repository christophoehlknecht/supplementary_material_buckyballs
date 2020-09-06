#!/bin/bash
trap "kill 0" EXIT

#This program calculates the corrections DGdsm

#>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

#>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
#path to GROMOS++ rdf
BIN=/home/ajk88/software/gromos_180917/gromosPlsPls/gromos++/BUILD16_PBSOLV_UPDATE3/programs/rdf

#enter input files here
SYSTEM="cneg"
LIGAND="ace"
NAME=${LIGAND}_in_${SYSTEM}_open
#------

top_charged="./topo/${LIGAND}_in_${SYSTEM}_open_L_0.0.top"
atomstocharge="1:a"


[[ -d results_DGdsm ]] || mkdir results_DGdsm


for LAM in L_0.0
do
    cnf="./coord/${LIGAND}_in_${SYSTEM}_open_${LAM}.cnf"
    
    ${BIN} \
	@topo $top_charged \
	@pbc r cog \
	@centre $atomstocharge \
	@with s:a \
	@cut  1.4 \
	@grid 500 \
	@traj  $(echo $cnf) > \
	results_DGdsm/OUT_rdf_${NAME}_${LAM}.arg
	

done	
	

#---------------------------
#END END END END END END END
#---------------------------
