extends MeshInstance3D

@export var Key1 :XRToolsPickableKey = null
@export var Key2 :XRToolsPickableKey = null
@export var Key3 :XRToolsPickableKey = null
@export var Key4 :XRToolsPickableKey = null
@export var play_sounds := true
@export var open_sound: AudioStream
var open_player: AudioStreamPlayer3D
@export var key_sound : AudioStream
var key_layer : AudioStreamPlayer3D
var open_rotation := Vector3(0, deg_to_rad(-90), 0)
var txt : MeshInstance3D = null
var ouverte=false

func _ready():
	Global.connect("key_snapped", Callable(self, "_on_key_snapped"))
	txt = get_node_or_null("SnapPoint/Texte")
	_setup_audio()

func _on_key_snapped(snap_point_name):
	open_door()

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
	if key_sound == null:
		key_sound = Global.DEFAULT_KEY_SOUND
	if key_sound:
		key_layer = AudioStreamPlayer3D.new()
		key_layer.stream = key_sound
		key_layer.unit_size = 1.0
		key_layer.max_distance = 10.0
		key_layer.attenuation_filter_cutoff_hz = 8000
		key_layer.bus = "SFX"
		add_child(key_layer)
func open_door():
	if Key1 and Key2 and Key3 and Key4 :
		if Key1.is_snapped and Key2.is_snapped and Key3.is_snapped and Key4.is_snapped :
			ouverte=true
			if play_sounds and open_sound:
				open_player.play()
			var t := create_tween()
			t.tween_property(self, "rotation", open_rotation, 1.0)
			t.set_trans(Tween.TRANS_SINE)
			t.set_ease(Tween.EASE_IN_OUT)
		else :
			if key_sound and play_sounds:
				key_layer.play()
