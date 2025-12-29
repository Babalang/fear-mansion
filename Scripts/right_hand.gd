extends XRController3D

func _ready() -> void:
	connect("button_pressed", Callable(self, "_on_button_pressed"))

func _on_button_pressed(button_name: String) -> void:
	if button_name == "ax_button":
		Global.emit_signal("toggle_light")
