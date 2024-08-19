extends AudioStreamPlayer2D


func _ready() -> void:
	SignalBus.sfx_changed.connect(_on_sfx_changed)

func _on_sfx_changed(value):
	volume_db = linear_to_db(value / 100)