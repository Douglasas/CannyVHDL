onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /slidingwindow_tb/rstn
add wave -noupdate /slidingwindow_tb/clk
add wave -noupdate /slidingwindow_tb/valid
add wave -noupdate /slidingwindow_tb/pix
add wave -noupdate -expand -subitemconfig {/slidingwindow_tb/window_1_o(2) -expand /slidingwindow_tb/window_1_o(1) -expand /slidingwindow_tb/window_1_o(0) -expand} /slidingwindow_tb/window_1_o
add wave -noupdate /slidingwindow_tb/valid_1_o
add wave -noupdate /slidingwindow_tb/valid_2_o
add wave -noupdate -expand -subitemconfig {/slidingwindow_tb/window_2_o(2) -expand /slidingwindow_tb/window_2_o(1) -expand /slidingwindow_tb/window_2_o(0) -expand} /slidingwindow_tb/window_2_o
add wave -noupdate /slidingwindow_tb/slidingwindow_top_2_i/slidingwindow_ctrl_i/current_st
add wave -noupdate /slidingwindow_tb/slidingwindow_top_2_i/slidingwindow_dp_i/col_r
add wave -noupdate /slidingwindow_tb/slidingwindow_top_2_i/slidingwindow_dp_i/lin_r
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {294 ps} 0}
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
WaveRestoreZoom {247 ps} {511 ps}
