extends Node3D

@export var invert_rotation : bool = false
@export var rotation_angle : float = 120
var Door: MeshInstance3D = null
var label: Label = null
var UI_Pivot : MeshInstance3D = null
var serrure : MeshInstance3D = null
var serrure2 : MeshInstance3D = null
var is_open := false

var closed_rotation: Vector3
var open_rotation: Vector3
var is_animating := false

@export var play_sounds := true

@export var open_sound: AudioStream
@export var close_sound: AudioStream

var open_player: AudioStreamPlayer3D
var close_player: AudioStreamPlayer3D


func _ready():
	hide_hint()
	Door = get_parent() as MeshInstance3D
	closed_rotation = Door.rotation
	var angle := deg_to_rad(rotation_angle)
	if invert_rotation == false:
		open_rotation = closed_rotation + Vector3(0, -angle, 0)
	else:
		open_rotation = closed_rotation + Vector3(0, angle, 0)
	label = get_node_or_null("UI_Pivot/SubViewport/Label")
	serrure = get_node_or_null("serrure")
	serrure2 = get_node_or_null("serrure2")
	_setup_audio()
	Global.connect("in_ray",interact)
	
	
func _setup_audio():
	if not play_sounds:
		return
	if open_sound == null:
		open_sound = Global.DEFAULT_OPEN_SOUND
	if close_sound == null:
		close_sound = Global.DEFAULT_CLOSE_SOUND
	if open_sound:
		open_player = AudioStreamPlayer3D.new()
		open_player.stream = open_sound
		open_player.unit_size = 1.0
		open_player.max_distance = 10.0
		open_player.attenuation_filter_cutoff_hz = 8000
		open_player.bus = "SFX"
		add_child(open_player)

	if close_sound:
		close_player = AudioStreamPlayer3D.new()
		close_player.stream = close_sound
		close_player.unit_size = 1.0
		close_player.max_distance = 10.0
		close_player.attenuation_filter_cutoff_hz = 8000
		close_player.bus = "SFX"
		add_child(close_player)

func interact(name:String):
	if name == Door.name:
		show_hint()
	else :
		hide_hint()
func show_hint():
	if label != null:
		label.text = "Appuyez sur X pour fermer la porte" if is_open else "Appuyez sur X pour ouvrir la porte"
		highlight_mat()
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
	if serrure != null:
		var mat := StandardMaterial3D.new()
		mat.albedo_color = Global.color_snap
		mat.emission_enabled = true
		mat.emission = Global.color_snap
		mat.emission_energy = 1.5

		serrure.set_surface_override_material(0, mat)
		serrure2.set_surface_override_material(0, mat)

func clear_highlight():
	if serrure != null :
		serrure.set_surface_override_material(0, null)
	if serrure2 != null :
		serrure2.set_surface_override_material(0, null)

func open_the_door():
	if play_sounds and open_player:
		open_player.play()
	var t := create_tween()
	t.tween_property(Door, "rotation", open_rotation, 1.0)
	t.set_trans(Tween.TRANS_SINE)
	t.set_ease(Tween.EASE_IN_OUT)
	t.finished.connect(func():
		is_animating = false
		is_open = true
	)

func close_the_door():
	var t := create_tween()
	t.tween_property(Door, "rotation", closed_rotation, 1.0)
	t.set_trans(Tween.TRANS_SINE)
	t.set_ease(Tween.EASE_IN_OUT)

	t.finished.connect(func():
		if play_sounds and close_player:
			close_player.play()
		is_animating = false
		is_open = false
	)

func get_hint_text() -> String:
	return "Appuyez sur X pour fermer la porte" if is_open else "Appuyez sur X pour ouvrir la porte"
