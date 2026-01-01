extends Node3D

@onready var Door_left := $porte_22
@onready var Door_right := $porte_23

func _ready() -> void:
	Global.connect("Open_first_floor", open)

func open():
	var t := create_tween()
	var left_target  = Vector3(0, deg_to_rad(85), 0)
	var right_target = Vector3(0, deg_to_rad(-85), 0)
	t.tween_property(Door_left, "rotation", left_target, 1.0)
	t.tween_property(Door_right, "rotation", right_target, 1.0)
	t.set_trans(Tween.TRANS_SINE)
	t.set_ease(Tween.EASE_IN_OUT)
