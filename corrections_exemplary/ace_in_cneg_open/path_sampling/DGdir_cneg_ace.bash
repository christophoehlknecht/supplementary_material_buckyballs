#!/bin/bash
trap "kill 0" EXIT

#This program calculates the corrections DGdir

#>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
#>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
#path to GROMOS++ ener
BIN="/home/ajk88/software/gromos_180917/gromosPlsPls/gromos++/BUILD16_PBSOLV_UPDATE3/programs/ener"

#system information
SYSTEM="cneg"
LIGAND="ace"
NAME=${LIGAND}_in_${SYSTEM}_open

#path to files
top_bound="./topo/${LIGAND}_in_${SYSTEM}_open.top"
top_unbound_ligand="./topo/${LIGAND}_in_${SYSTEM}_open_zero_bucky.top"
top_unbound_bucky="./topo/${LIGAND}_in_${SYSTEM}_open_zero_ligand.top"
coord_bound=./coord/${LIGAND}_in_${SYSTEM}_open_bound.cnf
coord_unbound=./coord/${LIGAND}_in_${SYSTEM}_open_unbound.cnf

#settings for ener
atomstocharge_bound="1:a;2:56-58"
atomstocharge_unbound_ligand="1:a;2:56-58"
atomstocharge_unbound_bucky="2:56-58"
    
#-----------------------------    
[[ -d results_DGdir ]] || mkdir results_DGdir

###################################
# BOUND STATE SIMULATION CONDITIONS
###################################
${BIN} \
    @traj $coord_bound \
    @topo $top_bound \
    @pbc r cog \
    @atoms "$atomstocharge_bound" \
    @cut 1.4 \
    @eps 66.6 \
    @RFex on \
    @energies 2 \
    > results_DGdir/OUT_ener_${NAME}_bound_sim.out

####################################
# BOUND STATE MACROSCOPIC CONDITIONS
####################################
${BIN} \
    @traj $coord_bound \
    @topo $top_bound \
    @pbc r cog \
    @atoms "$atomstocharge_bound" \
    @cut 10000 \
    @eps 0 \
    @RFex off \
    @energies 2 \
    > results_DGdir/OUT_ener_${NAME}_bound_macro.out

##########################################
# BOUND STATE SIMULATION CONDITIONS LIGAND
##########################################
${BIN} \
    @traj $coord_unbound \
    @topo $top_unbound_ligand \
    @pbc r cog \
    @atoms "$atomstocharge_unbound_ligand" \
    @cut 1.4 \
    @eps 66.6 \
    @RFex on \
    @energies 2 \
    > results_DGdir/OUT_ener_${NAME}_unbound_ligand_sim.out

###########################################
# BOUND STATE MACROSCOPIC CONDITIONS LIGAND
###########################################
${BIN} \
    @traj $coord_unbound \
    @topo $top_unbound_ligand \
    @pbc r cog \
    @atoms "$atomstocharge_unbound_ligand" \
    @cut 10000 \
    @eps 0 \
    @RFex off \
    @energies 2 \
    > results_DGdir/OUT_ener_${NAME}_unbound_ligand_macro.out

#########################################
# BOUND STATE SIMULATION CONDITIONS BUCKY
#########################################
${BIN} \
    @traj $coord_unbound \
    @topo $top_unbound_bucky \
    @pbc r cog \
    @atoms "$atomstocharge_unbound_bucky" \
    @cut 1.4 \
    @eps 66.6 \
    @RFex on \
    @energies 2 \
    > results_DGdir/OUT_ener_${NAME}_unbound_bucky_sim.out

##########################################
# BOUND STATE MACROSCOPIC CONDITIONS BUCKY
##########################################
${BIN} \
    @traj $coord_unbound \
    @topo $top_unbound_bucky \
    @pbc r cog \
    @atoms "$atomstocharge_unbound_bucky" \
    @cut 10000 \
    @eps 0 \
    @RFex off \
    @energies 2 \
    > results_DGdir/OUT_ener_${NAME}_unbound_bucky_macro.out


#---------------------------
#END END END END END END END
#---------------------------

