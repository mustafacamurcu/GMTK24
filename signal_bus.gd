extends Node


# Game Events
signal piece_picked_up(piece: Piece)
signal piece_put_down(piece: Piece)

# UI Events
signal start_pressed
signal restart_pressed

signal quit_pressed
signal options_pressed
signal escape_pressed

# Audio
signal bgm_changed(value)
signal sfx_changed(value)
