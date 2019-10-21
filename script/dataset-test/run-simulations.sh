#!/bin/bash

interruptHandler() {
    pkill -P $$
}
trap interruptHandler SIGINT;
trap interruptHandler SIGTERM;
trap interruptHandler SIGKILL;
trap interruptHandler SIGQUIT;

if [ "$#" -lt 2 ] || [ "$#" -gt 2 ]; then
    echo "Usage: ./run-simulations.sh [integer bits] [decimal bits]"
    exit
fi

let intbits $1
let decbits $2

#rm -rf ../../dat/dataset/*

# Write images to dat files
#python3 write_images.py $1 $2

source setup_env.sh

simEntities=("img_laplacian_tb" "img_roberts_tb" "img_prewitt_tb" "img_sobel_tb" "img_canny_tb")
instNames=("laplacian_filter_top_i" "roberts_filter_top_i" "prewitt_filter_top_i" "comp_sobel_top_i" "canny_top_i")

for i in ${!simEntities[*]}; do
  echo $i")" ${simEntities[i]}
done

read -p "Pick a simulation: " num

rm -rf ../../dat/dataset-results/${simEntities[$num]}
rm -rf ../../intel/sim-${simEntities[$num]}

mkdir ../../dat/dataset-results/${simEntities[$num]}
mkdir ../../intel/sim-${simEntities[$num]}
export SIM_ENTITY=${simEntities[$num]}
export INST_NAME=${instNames[$num]}
echo $SIM_ENTITY $INST_NAME
vsim -c -do simulate.tcl # &> /dev/null &

wait
