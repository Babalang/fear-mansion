extends Node3D

@onready var Door_left := $porte_22
@onready var Door_right := $porte_23
@export var play_sounds := true
@export var open_sound: AudioStream
var open_player: AudioStreamPlayer3D
func _ready() -> void:
	Global.connect("Open_first_floor", open)
	_setup_audio()

func _setup_audio():
	if not play_sounds:
		return
	if open_sound == null:
		open_sound = Global.DEFAULT_OPEN_SOUND
	if open_sound:
		open_player = AudioStreamPlayer3D.new()
		open_player.stream = open_sound
		open_player.unit_size = 1.0
		open_player.max_distance = 10.0
		open_player.attenuation_filter_cutoff_hz = 8000
		open_player.bus = "SFX"
		add_child(open_player)
		
func open():
	if play_sounds and open_sound:
		open_player.play()
	var t := create_tween()
	var left_target  = Vector3(0, deg_to_rad(85), 0)
	var right_target = Vector3(0, deg_to_rad(-85), 0)
	t.tween_property(Door_left, "rotation", left_target, 1.0)
	t.tween_property(Door_right, "rotation", right_target, 1.0)
	t.set_trans(Tween.TRANS_SINE)
	t.set_ease(Tween.EASE_IN_OUT)
