extends Node3D

@export var speed = 14

@export var fall_acceleration = 75

var target_velocity = Vector3.ZERO
var rot_x = 0
var rot_y = 0
var mouse_sensitivity = 0.002

func _ready() -> void:
	Global.joueur=$"."
	Global.mort=$"XROrigin3D/XRCamera3D/AnimationPlayer"
	#Input.mouse_mode=Input.MOUSE_MODE_CAPTURED
	
#func _input(event):
	#if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		#rotate_y(-event.relative.x * mouse_sensitivity)
		#$Camera3D.rotate_x(-event.relative.y * mouse_sensitivity)
		#$Camera3D.rotation.x = clampf($Camera3D.rotation.x, -deg_to_rad(70), deg_to_rad(70))
#
#func _physics_process(delta):
	#var input = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	#var movement_dir = transform.basis * Vector3(input.x, 0, input.y)
	#target_velocity.x = movement_dir.x * speed
	#target_velocity.z = movement_dir.z * speed
#
	#if not is_on_floor():
		#target_velocity.y = target_velocity.y - (fall_acceleration * delta)
	#velocity = target_velocity
	#move_and_slide()
