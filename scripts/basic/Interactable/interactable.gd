extends RigidBody2D

@export var dialogue_box: CanvasLayer
@export var scene_base: Control

@export var dialogue_script_path: String

@export var dialogic_timeline: String

@export var camera: Camera2D

var _dialgoue: Array = [
		{
			"name": "Change Me Later LORUM IPSUM SANTICS STATUM",
			"text": "Here's the text",
			"speaker_type": "NPC"
		},
		{
			"name": "Player",
			"text": "Here's more text",
			"speaker_type": "PLAYER"
		},
		{
			"name": "Player",
			"text": "Here's even more text",
			"speaker_type": "PLAYER"
		}
	]

func _ready() -> void:
	if not dialogic_timeline:
		var temp = load_json()
		#print(temp)
		if temp.size() > 0:
			_dialgoue = temp
	return

func _process(delta: float) -> void:
	return
	
func interact() -> void:
	#print("ITEM ITERACTED")
	if dialogic_timeline:
		var dialogue = Dialogic.start(dialogic_timeline)
		camera.add_child(dialogue)
	else:
		scene_base.start_dialogue(_dialgoue)
	return

func load_json() -> Array:
	#print("Loading file")
	var file = FileAccess.open(dialogue_script_path, FileAccess.READ)
	if file == null:
		push_error("Failed to open file: %s" % dialogue_script_path)
		return []

	var content = file.get_as_text()
	file.close()

	#print("Content: %s" % content)

	var json = JSON.new()
	var error = json.parse(content)

	#print("JSON:")
	#print(json)

	if error != OK:
		push_error("Failed to parse JSON: %s" % json.get_error_message())
		return []

	return json.get_data()
