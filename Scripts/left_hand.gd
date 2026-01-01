extends XRController3D

@onready var raycast = $RayCast3D
var feedback_label: Label = null

func _ready() -> void:
	connect("button_pressed", Callable(self, "_on_button_pressed"))

func _physics_process(delta: float) -> void:
	var door_name := ""
	if raycast.is_colliding():
		var collider = raycast.get_collider()
		var door = collider.get_parent()
		if door:
			if door.get_parent().name != "Clavier":
				door_name = door.get_parent().name
			else :
				door_name = door.name
			
			if door.has_method("get_hint_text"):
				Global.emit_signal("display_txt", door.get_hint_text())
	else:
		Global.emit_signal("display_txt", "")
	Global.emit_signal("in_ray", door_name)


func _on_button_pressed(button_name: String) -> void:
	if button_name != "ax_button":
		return
	if not raycast.is_colliding():
		return
	var collider = raycast.get_collider()
	var door = collider.get_parent()
	print(door.name)
	if door and door.has_method("process_interaction"):
		door.process_interaction()
	
