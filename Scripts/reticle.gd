extends MeshInstance3D

@export var base_distance := 2.0
@export var pulse_speed := 1.5
@export var pulse_strength := 0.2

var base_scale := Vector3.ONE * 0.01

func _process(delta):
	# Pulsation glauque
	var pulse = 1.0 + sin(Time.get_ticks_msec() / 1000.0 * pulse_speed) * pulse_strength
	scale = base_scale * pulse
