onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix hexadecimal /img_canny_tb/rstn
add wave -noupdate -radix hexadecimal /img_canny_tb/clk
add wave -noupdate -radix hexadecimal /img_canny_tb/valid
add wave -noupdate -radix hexadecimal /img_canny_tb/pix
add wave -noupdate -radix hexadecimal /img_canny_tb/valid_o
add wave -noupdate -radix hexadecimal /img_canny_tb/pix_o
add wave -noupdate -radix hexadecimal /img_canny_tb/period
add wave -noupdate -divider Gaussian
add wave -noupdate /gaussian_pkg/IMAGE_X
add wave -noupdate /gaussian_pkg/IMAGE_Y
add wave -noupdate -radix hexadecimal /img_canny_tb/canny_top_i/gauss_valid_w
add wave -noupdate -radix hexadecimal /img_canny_tb/canny_top_i/gauss_pix_w
add wave -noupdate -divider Sobel
add wave -noupdate /sobel_pkg/IMAGE_X
add wave -noupdate /sobel_pkg/IMAGE_Y
add wave -noupdate -radix hexadecimal /img_canny_tb/canny_top_i/sobel_valid_w
add wave -noupdate -radix hexadecimal /img_canny_tb/canny_top_i/sobel_x_pix_w
add wave -noupdate -radix hexadecimal /img_canny_tb/canny_top_i/sobel_y_pix_w
add wave -noupdate -divider Gradient
add wave -noupdate /gradient_pkg/IMAGE_X
add wave -noupdate /gradient_pkg/IMAGE_Y
add wave -noupdate -radix hexadecimal /img_canny_tb/canny_top_i/gradient_valid_w
add wave -noupdate -radix hexadecimal /img_canny_tb/canny_top_i/gradient_pix_w
add wave -noupdate -divider Normalization
add wave -noupdate /normalization_pkg/IMAGE_X
add wave -noupdate /normalization_pkg/IMAGE_Y
add wave -noupdate /img_canny_tb/canny_top_i/normalization_top_i/normalization_dp_i/u3_fifo/size_r
add wave -noupdate /img_canny_tb/canny_top_i/normalization_top_i/dc_full_w
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {479800 ps} 0}
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
WaveRestoreZoom {479681 ps} {479931 ps}
