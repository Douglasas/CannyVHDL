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

rm -rf ../../dat/dataset-results/*
rm -rf ../../intel/sim-*
#rm -rf ../../dat/dataset/*

# Write images to dat files
#python3 write_images.py $1 $2

source setup_env.sh

#simEntities=("img_laplacian_tb" "img_roberts_tb" "img_prewitt_tb" "img_sobel_tb") # "img_canny_tb"
#instNames=("laplacian_filter_top_i" "roberts_filter_top_i" "prewitt_filter_top_i" "comp_sobel_top_i") # "canny_top_i"
simEntities=("img_roberts_tb")
instNames=("roberts_filter_top_i")

for index in ${!array[*]}; do 
  echo "${array[$index]} is in ${array2[$index]}"
done

for i in ${!simEntities[*]}; do
    mkdir ../../dat/dataset-results/${simEntities[i]}
    mkdir ../../intel/sim-${simEntities[i]}
    export SIM_ENTITY=${simEntities[i]}
    export INST_NAME=${instNames[i]}
    echo $SIM_ENTITY $INST_NAME
    vsim -c -do simulate.tcl # &> /dev/null &
#    env WINEPREFIX="/home/douglas/.wine" wine-development C:\\\\windows\\\\command\\\\start.exe /Unix /home/douglas/.wine/dosdevices/c:/Modeltech_pe_edu_10.4a/win32pe_edu/modelsim.exe -c -do simulate.tcl
done

wait
