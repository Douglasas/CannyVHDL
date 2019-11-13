
cd ../../
set rootDir [pwd]

set simFolder $rootDir/sim/dataset
set hdlFolders [list $rootDir/hdl $rootDir/hdl/slogic $rootDir/hdl/canny $rootDir/hdl/complete_sobel $rootDir/hdl/cordic $rootDir/hdl/fifo $rootDir/hdl/gaussian $rootDir/hdl/gradient $rootDir/hdl/hysteresis $rootDir/hdl/laplacian $rootDir/hdl/laplacian_filter $rootDir/hdl/non_max_supress $rootDir/hdl/normalization $rootDir/hdl/prewitt $rootDir/hdl/prewitt_filter $rootDir/hdl/roberts $rootDir/hdl/roberts_filter $rootDir/hdl/slidingwindow $rootDir/hdl/sobel $rootDir/hdl/theta $rootDir/hdl/threshold]
# Get data from environment variables
set simEntity $env(SIM_ENTITY)
set instName $env(INST_NAME)

cd $rootDir/intel/sim-$simEntity

# Compile VHDL sources
vlib work
# compile just bodies, configurations and packages
foreach hdlFolder $hdlFolders {
    vcom -suppress -2002 -just bcp $hdlFolder/*.vhd
}
# compile just entities and architectures
foreach hdlFolder $hdlFolders {
  vcom -suppress -novopt -2002 -just ae $hdlFolder/*.vhd
}
# compile testbenches
vcom -suppress -novopt -2002 $simFolder/*.vhd

vsim -suppress 151 $simEntity
# Suppress all warnings
set NumericStdNoWarnings 1
set StdArithNoWarnings 1
set StdNumNoWarnings 1
restart -force

#vcd file dump.vcd
#vcd add -r /$instName/*

run 100 ms
#run 210 ms

# Quit Modelsim
quit -f
