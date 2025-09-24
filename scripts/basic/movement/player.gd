extends CharacterBody2D

@export var speed: float
@export var dialogue_box: CanvasLayer
@export var popup_layer: CanvasLayer
@export var sprite: Sprite2D
@export var prompt_interact: AnimatedSprite2D
@export var inspect_prompt: AnimatedSprite2D
@export var talk_prompt: AnimatedSprite2D

var interactable: Node2D = null

signal interact_signal

const CODES = {
	"INTERACT": 69
}

const SIGNALS = {
	69: "interact_signal"
}

func _ready() -> void:
	if !(speed):
		speed = 100
	# change with body within maybe?
	$Detector.connect("body_entered", Callable(self, "interact_available"))
	$Detector.connect("body_exited", Callable(self, "interact_not_available"))
	return

func _process(delta: float) -> void:
	return

func _physics_process(delta: float) -> void:
	measure_movement_input()
	move()
	return

func measure_movement_input() -> void:
	velocity.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	velocity.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	#print(velocity)
	if (velocity.x < 0):
		sprite.flip_h = true
	elif (velocity.x > 0):
		sprite.flip_h = false
	# ^ done this way to ensure that no reseting on 0
	# check if there's a better way
	velocity = velocity * speed
	return

func move() -> void:
	# disallow movement when dialogue box is open
	if dialogue_box.visible or popup_layer.visible: return
	# do any extra animation control stuff here
	move_and_slide()

func interact_available(body) -> void:
	if !(body.is_in_group("interactable") or body.is_in_group("inspectable")):
		return
	if body.is_in_group("interactable"):
		talk_prompt.visible = true
		talk_prompt.play("default")
	else:
		inspect_prompt.visible = true
		inspect_prompt.play("default")
	#print("Press INTERACT button to interact!")
	prompt_interact.visible = true
	prompt_interact.play("default")
	interactable = body # saving the reference so that it can be disconnected when interacting
	connect(SIGNALS[CODES["INTERACT"]], Callable(body, "interact"))
	# this is better than flags
	# because this just creates a reference
	# and it doesn't have a big overhead 
	return

func interact_not_available(body) -> void:
	interactable = null # clearing the reference
	disconnect(SIGNALS[CODES["INTERACT"]], Callable(body, "interact"))
	if body.is_in_group("interactable"):
		talk_prompt.visible = false
		talk_prompt.stop()
	else:
		inspect_prompt.visible = false
		inspect_prompt.stop()
	prompt_interact.stop()
	prompt_interact.visible = false
	return
	
func _unhandled_input(event: InputEvent) -> void:
	if !(event is InputEventKey):
		return
	if !(event.keycode in SIGNALS):
		return
	emit_signal(SIGNALS[event.keycode])
	if interactable:
		# break the connection once FIRST interact signal has been emitted
		# this will prevent restart of interaction
		disconnect(SIGNALS[CODES["INTERACT"]], Callable(interactable, "interact"))
	return
