extends Node3D

var drawer: MeshInstance3D = null
var label: Label = null
var is_open := false

@export var open_offset_local := Vector3(0, 0, 20)

var closed_position: Vector3
var open_position: Vector3
var is_animating := false

func _ready():
	drawer = get_node_or_null("Drawer_Drawer2_0")
	label = get_node_or_null("UI_Pivot/SubViewport/Label")
	Global.connect("in_ray", interact)
	hide_hint()

	closed_position = position
	open_position = closed_position + open_offset_local

	
func interact(name1:String):
	if name1 == get_parent().name:
		show_hint()
	else :
		hide_hint()
		
func show_hint():
	if label != null:
		label.text = "Appuyez sur X pour fermer la porte" if is_open else "Appuyez sur X pour ouvrir la porte"
		if is_open == false:
			highlight_mat()
		else :
			clear_highlight()
		
func hide_hint():
	if label != null:
		label.text = ""
		clear_highlight()
	
func process_interaction():
	if is_animating:
		return
	is_animating = true
	if is_open:
		close_the_door()
	else:
		open_the_door()

func highlight_mat():
	if drawer != null:
		var mat := StandardMaterial3D.new()
		mat.albedo_color = Global.color_snap
		mat.emission_enabled = true
		mat.emission = Global.color_snap
		mat.emission_energy = 1.5
		drawer.set_surface_override_material(0, mat)

func clear_highlight():
	if drawer != null :
		drawer.set_surface_override_material(0, null)

func open_the_door():
	var t := create_tween()
	t.tween_property(self, "position", open_position, 1.0)
	t.set_trans(Tween.TRANS_SINE)
	t.set_ease(Tween.EASE_IN_OUT)
	t.finished.connect(func():
		is_open = true
		is_animating = false
	)

func close_the_door():
	var t := create_tween()
	t.tween_property(self, "position", closed_position, 1.0)
	t.set_trans(Tween.TRANS_SINE)
	t.set_ease(Tween.EASE_IN_OUT)
	t.finished.connect(func():
		is_open = false
		is_animating = false
	)

func get_hint_text() -> String:
	return "Appuyez sur X pour fermer" if is_open else "Appuyez sur X pour ouvrir"
