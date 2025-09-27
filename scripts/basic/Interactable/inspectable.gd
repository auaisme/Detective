extends RigidBody2D

@export var popup_layer: CanvasLayer
@export var display_me: CanvasLayer
@export var panel: Panel

#func interact() -> void:
	#print("ITEM INSPECTED")
	## instantiate popup scene in popup layer
	#var popup = load("res://scenes/popup.tscn").instantiate()
	#popup_layer.add_child(popup)
	#popup_layer.show()
	## ^ this is going to load and unload a lot, so maybe load all at start?
	#return

func interact() -> void:
	if (!display_me.visible):
		panel.position = Vector2(get_viewport().size.x / 2, get_viewport().size.y / 2)
		panel.size = Vector2(0, 0)
		display_me.visible = true
		Dialogic.VAR["has_seen_glasses"] = true
	return
