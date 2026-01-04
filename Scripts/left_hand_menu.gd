extends XRController3D

@onready var raycast: RayCast3D = $RayCast3D

@export var ui_plane: MeshInstance3D
@export var subviewport: SubViewport

var last_hover_pos: Vector2 = Vector2.ZERO

func _ready() -> void:
	connect("button_pressed", Callable(self, "_on_button_pressed"))

func _physics_process(_delta):
	if not raycast.is_colliding():
		return

	var collider = raycast.get_collider()
	var plan = collider.get_parent()
	if plan != ui_plane:
		return

	var collision_point = raycast.get_collision_point()
	var local_point = ui_plane.to_local(collision_point)

	# PlaneMesh = 2x2 unités
	var uv = Vector2(
		(local_point.x / (ui_plane.scale.x * 2.0)) + 0.5,
		1.0 - ((local_point.y / (ui_plane.scale.y * 2.0)) + 0.5)
	)

	var sub_pos = uv * Vector2(subviewport.size.x, subviewport.size.y)

	var relative = sub_pos - last_hover_pos
	last_hover_pos = sub_pos

	var motion = InputEventMouseMotion.new()
	motion.position = sub_pos
	motion.global_position = sub_pos
	motion.relative = relative
	motion.velocity = relative / _delta
	subviewport.push_input(motion)


func _on_button_pressed(button_name: String):
	if button_name != "ax_button":
		return
	if not raycast.is_colliding():
		return

	var collider = raycast.get_collider()
	var plan = collider.get_parent()
	print(plan.name)
	if plan != ui_plane:
		return

	var collision_point = raycast.get_collision_point()
	var local_point = ui_plane.to_local(collision_point)

	var uv = Vector2(
		(local_point.x / (ui_plane.scale.x * 2.0)) + 0.5,
		1.0 - ((local_point.y / (ui_plane.scale.y * 2.0)) + 0.5)
	)
	print("UV:", uv)

	var sub_pos = uv * Vector2(subviewport.size.x, subviewport.size.y)

	var click = InputEventMouseButton.new()
	click.button_index = MOUSE_BUTTON_LEFT
	click.pressed = true
	click.position = sub_pos
	subviewport.push_input(click)

	var release = InputEventMouseButton.new()
	release.button_index = MOUSE_BUTTON_LEFT
	release.pressed = false
	release.position = sub_pos
	subviewport.push_input(release)
