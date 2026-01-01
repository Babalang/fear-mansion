extends MeshInstance3D
var open_rotation := Vector3(0, deg_to_rad(-160), 0)
var txt : MeshInstance3D = null
# Dans le script de la porte
func _ready():
	Global.connect("key_snapped", Callable(self, "_on_key_snapped"))
	txt = get_node_or_null("SnapPoint/Texte")
func _on_key_snapped(snap_point_name):
	if txt :
		txt.visible = false
	open_door()

func open_door():
	var t := create_tween()
	t.tween_property(self, "rotation", open_rotation, 1.0)
	t.set_trans(Tween.TRANS_SINE)
	t.set_ease(Tween.EASE_IN_OUT)
