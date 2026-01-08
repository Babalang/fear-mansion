extends Node

signal key_snapped(snap_point_name : String)

signal in_ray(door_name:String)

signal display_txt(text : String)

signal toggle_light()

signal Open_first_floor()
signal Open_Garage()

signal digicode_changed(new_value)
signal digicode2_changed(new_value)

var color_snap = Color(0, 1, 0)

var code_first_floor = "2048"
var digicode: String = "":
	set(value):
		digicode = value
		emit_signal("digicode_changed", digicode)

var code_garage = "1983"
var digicode2 : String = "":
	set(value):
		digicode2 = value
		emit_signal("digicode2_changed", digicode2)

const DEFAULT_OPEN_SOUND = preload("res://Audio/opening-door.mp3")
const DEFAULT_CLOSE_SOUND = preload("res://Audio/close-door.mp3")
const DEFAULT_KEY_SOUND = preload("res://Audio/lock-the-door.mp3")
const DEFAULT_BEEP_SOUND = preload("res://Audio/beep.mp3")
const DEFAULT_CORRECT_SOUND = preload("res://Audio/correct.mp3")
const DEFAULT_WRONG_SOUND = preload("res://Audio/wrong.mp3")

var joueur
var porteSousSol
var init=false
var mort
