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

top_charged="./topo/${LIGAND}_in_${SYSTEM}_open.top"
coord_bound=./coord/${LIGAND}_in_${SYSTEM}_open_bound.cnf
coord_unbound=./coord/${LIGAND}_in_${SYSTEM}_open_unbound.cnf

#settings for dGslv_pbsolv
charge_ligand="-1"
charge_bucky="-1"
atomstocharge_bucky="2:56-58"
atomstocharge_ligand="1:a"
atomsincluded="1-2:a"


[[ -d ./results_DGdsm ]] || mkdir results_DGdsm
    
${BIN} \
    @topo $top_charged \
    @pbc r cog \
    @centre $atomstocharge_ligand \
    @with s:a \
    @cut  1.4 \
    @grid 500 \
    @traj  $(echo $coord_bound) > \
    results_DGdsm/OUT_rdf_bound_ligand.arg
    
${BIN} \
    @topo $top_charged \
    @pbc r cog \
    @centre $atomstocharge_bucky \
    @with s:a \
    @cut  1.4 \
    @grid 500 \
    @traj  $(echo $coord_bound) > \
    results_DGdsm/OUT_rdf_bound_bucky.arg

${BIN} \
    @topo $top_charged \
    @pbc r cog \
    @centre $atomstocharge_ligand \
    @with s:a \
    @cut  1.4 \
    @grid 500 \
    @traj  $(echo $coord_unbound) > \
    results_DGdsm/OUT_rdf_unbound_ligand.arg
    
${BIN} \
    @topo $top_charged \
    @pbc r cog \
    @centre $atomstocharge_bucky \
    @with s:a \
    @cut  1.4 \
    @grid 500 \
    @traj  $(echo $coord_unbound) > \
    results_DGdsm/OUT_rdf_unbound_bucky.arg
    

#---------------------------
#END END END END END END END
#---------------------------
