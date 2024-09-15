onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_tea_2/clk
add wave -noupdate /tb_tea_2/rst_n
add wave -noupdate /tb_tea_2/ctxt
add wave -noupdate /tb_tea_2/ctxt_ready
add wave -noupdate /tb_tea_2/ptxt
add wave -noupdate /tb_tea_2/ptxt_valid
add wave -noupdate /tb_tea_2/key
add wave -noupdate /tb_tea_2/key_valid
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {82 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 142
configure wave -valuecolwidth 128
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
WaveRestoreZoom {0 ps} {50 ps}
