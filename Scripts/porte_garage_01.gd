extends Node3D

@onready var porte_gauche = $gauche
@onready var porte_droite = $droite
var is_open = false

func _ready() -> void:
	Global.connect("Open_Garage",open_the_door)
	
func open_the_door():
	if is_open == false and porte_droite and porte_gauche :
		var t := create_tween()
		t.tween_property(porte_gauche, "rotation", Vector3(0,deg_to_rad(100),0), 1.0)
		t.set_trans(Tween.TRANS_SINE)
		t.set_ease(Tween.EASE_IN_OUT)
		var t1 := create_tween()
		t1.tween_property(porte_droite, "rotation", Vector3(0,deg_to_rad(-100),0), 1.0)
		t1.set_trans(Tween.TRANS_SINE)
		t1.set_ease(Tween.EASE_IN_OUT)
		is_open = true
		await t1.finished
		Global.reset_stats() 
		get_tree().change_scene_to_file("res://Scenes/Menu_principal_3D.tscn")
