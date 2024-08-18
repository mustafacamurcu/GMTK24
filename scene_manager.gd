extends Node2D

const MENU = preload("res://menu_screen.tscn")
const GAME = preload("res://game.tscn")
@onready var audio_stream_player = $AudioStreamPlayer

var menu
var game

# Called when the node enters the scene tree for the first time.
func _ready():
	menu = MENU.instantiate()
	add_child(menu)

	audio_stream_player.play()
	audio_stream_player.volume_db = linear_to_db(0)

	SignalBus.start_pressed.connect(_on_start_pressed)
	SignalBus.restart_pressed.connect(_on_start_pressed)
	SignalBus.quit_pressed.connect(_on_quit_pressed)
	SignalBus.options_pressed.connect(_on_options_pressed)
	SignalBus.escape_pressed.connect(_on_escape_pressed)
	
	SignalBus.bgm_changed.connect(_on_bgm_changed)
	SignalBus.sfx_changed.connect(_on_sfx_changed)

func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed('escape'):
		_on_escape_pressed()

func _on_bgm_changed(value):
	audio_stream_player.volume_db = linear_to_db(value / 100)

func _on_sfx_changed(on):
	audio_stream_player.stream_paused = not on

func _on_start_pressed():
	menu.hide()
	if is_instance_valid(game):
		game.queue_free()
	game = GAME.instantiate()
	add_child(game)
	game.setup(Cs.LEVEL1)

func _on_host_online_multiplayer_pressed():
	menu.hide()
	if is_instance_valid(game):
		game.queue_free()
	game = GAME.instantiate()
	add_child(game)

func _on_quit_pressed():
	get_tree().quit()

func _on_options_pressed():
	pass

func _on_escape_pressed():
	if is_instance_valid(game):
		game.queue_free()
	menu.show()
