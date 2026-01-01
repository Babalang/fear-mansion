extends Node

signal key_snapped(snap_point_name : String)

signal in_ray(door_name:String)

signal display_txt(text : String)

signal toggle_light()

signal Open_first_floor()

signal digicode_changed(new_value)

var color_snap = Color(0, 1, 0)
var code_first_floor = "2048"
var digicode: String = "":
	set(value):
		digicode = value
		emit_signal("digicode_changed", digicode)
