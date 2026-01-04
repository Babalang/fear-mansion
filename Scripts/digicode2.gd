extends Node3D

var button : MeshInstance3D = null
var label : Label = null
var original_mat : Material = null
@export var play_sounds := true
@export var beep_sound: AudioStream
var beep_player: AudioStreamPlayer3D
@export var correct_sound : AudioStream
var correct_player : AudioStreamPlayer3D
@export var wrong_sound : AudioStream
var wrong_player : AudioStreamPlayer3D

func _ready():
	button = get_node_or_null("Bouton")
	label = get_node_or_null("Bouton/SubViewport/Label")
	label.text = self.name
	original_mat = button.get_active_material(0)
	Global.connect("in_ray", interact)
	_setup_audio()

func _setup_audio():
	if not play_sounds:
		return
	if beep_sound == null:
		beep_sound = Global.DEFAULT_BEEP_SOUND
	if beep_sound:
		beep_player = AudioStreamPlayer3D.new()
		beep_player.stream = beep_sound
		beep_player.unit_size = 1.0
		beep_player.max_distance = 10.0
		beep_player.attenuation_filter_cutoff_hz = 8000
		beep_player.bus = "SFX"
		add_child(beep_player)
	if correct_sound == null:
		correct_sound = Global.DEFAULT_CORRECT_SOUND
	if correct_sound:
		correct_player = AudioStreamPlayer3D.new()
		correct_player.stream = correct_sound
		correct_player.unit_size = 1.0
		correct_player.max_distance = 10.0
		correct_player.attenuation_filter_cutoff_hz = 8000
		correct_player.bus = "SFX"
		add_child(correct_player)
	if wrong_sound == null:
		wrong_sound = Global.DEFAULT_WRONG_SOUND
	if wrong_sound:
		wrong_player = AudioStreamPlayer3D.new()
		wrong_player.stream = wrong_sound
		wrong_player.unit_size = 1.0
		wrong_player.max_distance = 10.0
		wrong_player.attenuation_filter_cutoff_hz = 8000
		wrong_player.bus = "SFX"
		add_child(wrong_player)

func interact(name1: String):
	if name1 == self.name:
		highlight_mat()
	else:
		clear_highlight()


func highlight_mat():
	if original_mat:
		original_mat.emission_enabled = true
		original_mat.emission = Global.color_snap
		original_mat.emission_energy = 1.5


func clear_highlight():
	if original_mat:
		original_mat.emission_enabled = false


func process_interaction():
	if play_sounds and beep_sound :
		beep_player.play()
	Global.digicode2 += self.name
	if Global.digicode2 == Global.code_garage:
		if play_sounds and correct_sound:
			correct_player.play()
		Global.emit_signal("Open_Garage")
	else :
		if Global.digicode2.length() >= 4:
			Global.digicode2 = ""
			if play_sounds and wrong_sound:
				wrong_player.play()
