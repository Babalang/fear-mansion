extends TextureRect

func _process(delta):
	material.set("shader_param/time", Time.get_ticks_msec() / 1000.0)
