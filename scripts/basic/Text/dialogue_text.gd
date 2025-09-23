extends RichTextLabel

@export var typing_speed: float  # seconds per letter
var full_text := ""
var char_index := 0

@export var timer: Timer
# figure out a way to wait until this is completed
@export var wait_on_me: Timer

func show_text(param_text: String) -> void:
	full_text = param_text
	char_index = 0
	text = ""
	_start_typing()

func _start_typing() -> void:
	# Using a timer to reveal characters
	timer.wait_time = typing_speed
	timer.one_shot = false
	timer.connect("timeout", Callable(self, "_on_type"))
	timer.start()

func _on_type() -> void:
	if char_index >= full_text.length():
		timer.one_shot = true # stop restart
		timer.stop()
		# stop typing
		return
	text += full_text[char_index]
	char_index += 1
