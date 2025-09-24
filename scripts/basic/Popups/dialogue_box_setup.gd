extends Control

@export var dead_body_pop_up: CanvasLayer
@export var glasses_pop_up: CanvasLayer

var POP_UPS: Dictionary[String, CanvasLayer] = {}

@export var dialogue_box: CanvasLayer
@export var panel: Panel
@onready var name_label: RichTextLabel = panel.get_node("Name")
@onready var text_label: RichTextLabel = panel.get_node("Dialogue")
var dialogue_lines = []
var current_index = 0

const COLORS = {
	"PLAYER": Color.DARK_GOLDENROD,
	"POLICE": Color.CORNFLOWER_BLUE,
	"WITNESS": Color.FOREST_GREEN,
	"NPC": Color.CADET_BLUE,
	"EVIDENCE": Color.DARK_GRAY,
	"OBJECT": Color.DARK_GRAY,
	"SUSPECT": Color.CRIMSON
}

func _ready() -> void:
	POP_UPS = {
		"dead body": dead_body_pop_up,
		"glasses": glasses_pop_up
	}
	return

func setup_dialogue_box() -> void:	
	var viewport = Vector2(get_viewport().size.x, get_viewport().size.y)
	panel.size = viewport
	panel.size.x -= 20
	panel.size.y = (get_viewport().size.y * 0.4) as int
	panel.position = Vector2(10, viewport.y - panel.size.y - 10)
	name_label.add_theme_font_size_override("normal_font_size", 42)
	text_label.add_theme_font_size_override("normal_font_size", 36)
	return

func start_dialogue(lines):
	if !dialogue_box.visible:
		setup_dialogue_box()
	dialogue_lines = lines
	current_index = 0
	dialogue_box.show()
	display_line()

func end_dialogue():
	dialogue_box.hide()

func display_line():
	var entry = dialogue_lines[current_index]
	if current_index == 0 or entry["name"] != dialogue_lines[current_index - 1]["name"]:
		name_label.show_text(entry["name"])
		name_label.add_theme_color_override("default_color", COLORS[entry["speaker_type"]])
	text_label.show_text(entry["text"])
	# also display small icons for speaking, more, and finish

func _input(event):
	if event.is_action_pressed("ui_accept") or event.is_action_pressed("interact"):
		var active_pop_up = POP_UPS.values().filter(func(n): return n.visible)
		# change this to check if any item in popup is open
		if (dialogue_box.visible):
			current_index += 1
			if current_index < dialogue_lines.size():
				display_line()
			else:
				dialogue_box.hide()
		elif (active_pop_up):
			active_pop_up[0].hide()
			pass
