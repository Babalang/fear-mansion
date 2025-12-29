@tool
extends XRToolsPickable
class_name XRToolsPickablePaper

var initial_transform: Transform3D

@export_multiline var paper_text : String = ""

@onready var rich_txt_label : RichTextLabel = \
	$MeshInstance3D/SubViewport/RichTextLabel


func _ready():
	super._ready()
	initial_transform = global_transform

	if rich_txt_label:
		rich_txt_label.text = paper_text


func _process(_delta: float) -> void:
	if is_picked_up():
		var cam := get_viewport().get_camera_3d()
		if cam:
			face_camera(cam)


func _physics_process(_delta: float) -> void:
	if not is_picked_up() and global_transform != initial_transform:
		global_transform = initial_transform


func face_camera(cam: Camera3D):
	var dir := (cam.global_position - global_position).normalized()
	var basis := Basis()
	basis.y = dir
	basis.x = Vector3.UP.cross(basis.y).normalized()
	basis.z = basis.x.cross(basis.y).normalized()
	global_transform.basis = basis
