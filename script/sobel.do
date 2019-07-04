onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /img_sobel_tb/rstn
add wave -noupdate /img_sobel_tb/clk
add wave -noupdate /img_sobel_tb/valid
add wave -noupdate /img_sobel_tb/pix
add wave -noupdate /img_sobel_tb/valid_o
add wave -noupdate /img_sobel_tb/pix_o
add wave -noupdate -divider Gaussian
add wave -noupdate /img_sobel_tb/comp_sobel_top_i/gaussian_top_i/valid_o
add wave -noupdate -expand -subitemconfig {/img_sobel_tb/comp_sobel_top_i/gaussian_top_i/window_data_w(2) -expand /img_sobel_tb/comp_sobel_top_i/gaussian_top_i/window_data_w(1) -expand /img_sobel_tb/comp_sobel_top_i/gaussian_top_i/window_data_w(0) -expand} /img_sobel_tb/comp_sobel_top_i/gaussian_top_i/window_data_w
add wave -noupdate /img_sobel_tb/comp_sobel_top_i/gaussian_top_i/pix_o
add wave -noupdate -divider Sobel
add wave -noupdate /img_sobel_tb/comp_sobel_top_i/sobel_top_i/valid_o
add wave -noupdate -expand -subitemconfig {/img_sobel_tb/comp_sobel_top_i/sobel_top_i/window_data_w(2) -expand /img_sobel_tb/comp_sobel_top_i/sobel_top_i/window_data_w(1) -expand /img_sobel_tb/comp_sobel_top_i/sobel_top_i/window_data_w(0) -expand} /img_sobel_tb/comp_sobel_top_i/sobel_top_i/window_data_w
add wave -noupdate /img_sobel_tb/comp_sobel_top_i/sobel_top_i/y_pix_o
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {8880 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {8816 ps} {8944 ps}
