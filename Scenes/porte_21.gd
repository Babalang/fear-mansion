extends MeshInstance3D

# Dans le script de la porte
func _ready():
	Global.connect("key_snapped", Callable(self, "_on_key_snapped"))

func _on_key_snapped(snap_point_name):
		open_door()

func open_door():
	print("hello")
	rotate(Vector3(0,1,0), -160)
