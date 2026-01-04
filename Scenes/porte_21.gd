extends MeshInstance3D
var open_rotation := Vector3(0, deg_to_rad(-160), 0)
var txt : MeshInstance3D = null
@export var play_sounds := true
@export var open_sound: AudioStream
var open_player: AudioStreamPlayer3D
# Dans le script de la porte
func _ready():
	Global.connect("key_snapped", Callable(self, "_on_key_snapped"))
	txt = get_node_or_null("SnapPoint/Texte")
func _on_key_snapped(snap_point_name):
	if txt :
		txt.visible = false
	open_door()
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
		
func open_door():
	if play_sounds and open_sound:
		open_player.play()
	var t := create_tween()
	t.tween_property(self, "rotation", open_rotation, 1.0)
	t.set_trans(Tween.TRANS_SINE)
	t.set_ease(Tween.EASE_IN_OUT)
