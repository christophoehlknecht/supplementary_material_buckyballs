#!/bin/bash
trap "kill 0" EXIT

#This program calculates the corrections DGpol

#>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
#>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# path to GROMOS++ dGslv_pbsolv
BIN=/home/ajk88/software/gromos_180917/gromosPlsPls/gromos++/BUILD16_PBSOLV_UPDATE3/programs/dGslv_pbsolv

# system information
SYSTEM="cneg"
LIGAND="ace"
NAME=${LIGAND}_in_${SYSTEM}_open

#path to files
top_neutral="./topo/${LIGAND}_in_${SYSTEM}_open_zero_both.top"
top_charged="./topo/${LIGAND}_in_${SYSTEM}_open.top"
coord_bound=./coord/${LIGAND}_in_${SYSTEM}_open_bound.cnf
coord_unbound=./coord/${LIGAND}_in_${SYSTEM}_open_unbound.cnf

#settings for dGslv_pbsolv
gridspacing="0.4"
atomstocharge_bound="1:a;2:56-58"
atomstocharge_unbound_bucky="2:56-58"
atomstocharge_unbound_ligand="1:a"
atomsincluded_bound="1-2:a"
atomsincluded_unbound_ligand="1:a"
atomsincluded_unbound_bucky="2:a"

[[ -d ./results_DGpol ]] || mkdir results_DGpol


###############
# CHARGED BOUND STATE
###############
${BIN} \
    @topo $top_charged \
    @pbc r cog \
    @atoms $atomsincluded_bound \
    @atomsTOcharge $atomstocharge_bound \
    @coord ${coord_bound} \
    @schemeELEC RF \
    @rcut 1.4 \
    @epsSOLV 66.6 \
    @epsRF 66.6 \
    @gridspacing $gridspacing \
    @probeIAC 5 \
    > ./results_DGpol/OUT_pBsolv_${NAME}_bound_charged

#################
# UNCHARGED BOUND STATE
#################
${BIN} \
    @topo $top_neutral \
    @pbc r cog \
    @atoms $atomsincluded_bound \
    @atomsTOcharge "$atomstocharge_bound" \
    @coord ${coord_bound} \
    @schemeELEC RF \
    @rcut 1.4 \
    @epsSOLV 66.6 \
    @epsRF 66.6 \
    @gridspacing $gridspacing \
    @probeIAC 5 \
    > ./results_DGpol/OUT_pBsolv_${NAME}_bound_neutral

#################
# CHARGED UNBOUND STATE LIGAND
#################
${BIN} \
    @topo $top_charged \
    @pbc r cog \
    @atoms $atomsincluded_unbound_ligand \
    @atomsTOcharge "$atomstocharge_unbound_ligand" \
    @coord ${coord_unbound} \
    @schemeELEC RF \
    @rcut 1.4 \
    @epsSOLV 66.6 \
    @epsRF 66.6 \
    @gridspacing $gridspacing \
    @probeIAC 5 \
    > ./results_DGpol/OUT_pBsolv_${NAME}_unbound_charged_ligand

#################
# CHARGED UNBOUND STATE BUCKY
#################
${BIN} \
    @topo $top_charged \
    @pbc r cog \
    @atoms $atomsincluded_unbound_bucky \
    @atomsTOcharge "$atomstocharge_unbound_bucky" \
    @coord ${coord_unbound} \
    @schemeELEC RF \
    @rcut 1.4 \
    @epsSOLV 66.6 \
    @epsRF 66.6 \
    @gridspacing $gridspacing \
    @probeIAC 5 \
    > ./results_DGpol/OUT_pBsolv_${NAME}_unbound_charged_bucky

#################
# UNCHARGED UNBOUND STATE LIGAND
#################
${BIN} \
    @topo $top_neutral \
    @pbc r cog \
    @atoms $atomsincluded_unbound_ligand \
    @atomsTOcharge "$atomstocharge_unbound_ligand" \
    @coord ${coord_unbound} \
    @schemeELEC RF \
    @rcut 1.4 \
    @epsSOLV 66.6 \
    @epsRF 66.6 \
    @gridspacing $gridspacing \
    @probeIAC 5 \
    > ./results_DGpol/OUT_pBsolv_${NAME}_unbound_neutral_ligand

#################
# UNCHARGED UNBOUND STATE BUCKY
#################
${BIN} \
    @topo $top_neutral \
    @pbc r cog \
    @atoms $atomsincluded_unbound_bucky \
    @atomsTOcharge "$atomstocharge_unbound_bucky" \
    @coord ${coord_unbound} \
    @schemeELEC RF \
    @rcut 1.4 \
    @epsSOLV 66.6 \
    @epsRF 66.6 \
    @gridspacing $gridspacing \
    @probeIAC 5 \
    > ./results_DGpol/OUT_pBsolv_${NAME}_unbound_neutral_bucky


#---------------------------
#END END END END END END END
#---------------------------
