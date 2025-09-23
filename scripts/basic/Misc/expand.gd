extends Control

func _ready() -> void:
	# Make sure it expands to full screen
	anchor_left = 0
	anchor_top = 0
	anchor_right = 1
	anchor_bottom = 1

	offset_left = 0
	offset_top = 0
	offset_right = 0
	offset_bottom = 0

	size = get_viewport().size
