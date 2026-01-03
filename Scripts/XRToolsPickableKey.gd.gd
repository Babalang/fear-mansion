@tool
class_name XRToolsPickableKey
extends XRToolsPickable

signal snapped(point: Node3D)

@export var snap_point: Node3D
@export var snap_radius: float = 1.0
@export var display : bool = true
var texte : MeshInstance3D = null
var _snap_mesh: MeshInstance3D = null
var _snap_highlighted: bool = false
var is_snapped: bool = false


func _ready():
	if display :
		texte = get_node_or_null("Texte")
	else : 
		$Texte.visible = false
	# Copier ce qui était dans _ready() du parent
	for child in get_children():
		var grab_point := child as XRToolsGrabPoint
		if grab_point:
			_grab_points.push_back(grab_point)

	# Code spécifique au snap
	if snap_point:
		_snap_mesh = snap_point.get_node_or_null("serrure")
		set_physics_process(true)
	picked_up.connect(_on_picked_up)

func let_go(by: Node3D, linear_velocity: Vector3, angular_velocity: Vector3) -> void:
	super.let_go(by, linear_velocity, angular_velocity)

	if is_snapped or not snap_point:
		return

	var dist := global_position.distance_to(snap_point.global_position)
	if dist <= snap_radius:
		snap_to_point(snap_point)
	else :
		if texte :
			texte.visible = true

func snap_to_point(point: Node3D):
	global_transform = point.global_transform
	is_snapped = true
	if self is RigidBody3D:
		freeze = true
		freeze_mode = RigidBody3D.FREEZE_MODE_KINEMATIC
		self.linear_velocity = Vector3.ZERO
		self.angular_velocity = Vector3.ZERO
	visible = false
	Global.emit_signal("key_snapped", point)

func _enable_snap_highlight():
	if _snap_highlighted:
		return
	_snap_highlighted = true
	var mat := StandardMaterial3D.new()
	mat.albedo_color = Global.color_snap
	mat.emission_enabled = true
	mat.emission = Global.color_snap
	mat.emission_energy = 1.5
	if _snap_mesh:
		_snap_mesh.set_surface_override_material(0, mat)

func _clear_snap_highlight():
	if not _snap_highlighted:
		return
	_snap_highlighted = false
	if _snap_mesh:
		_snap_mesh.set_surface_override_material(0, null)

func _process(_delta):
	if not is_picked_up():
		_clear_snap_highlight()
		return
	if not snap_point or not _snap_mesh:
		return
	var dist := global_position.distance_to(snap_point.global_position)
	if dist <= snap_radius:
		_enable_snap_highlight()
	else:
		_clear_snap_highlight()

func _on_picked_up(_pickable):
	if texte:
		texte.visible = false
