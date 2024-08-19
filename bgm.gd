extends AudioStreamPlayer2D


func _ready() -> void:
	volume_db = linear_to_db(.5)
	SignalBus.bgm_changed.connect(_on_bgm_changed)

func _on_bgm_changed(value):
	volume_db = linear_to_db(value / 100)