extends MeshInstance3D

@export var Key1 :XRToolsPickableKey = null
@export var Key2 :XRToolsPickableKey = null
@export var Key3 :XRToolsPickableKey = null
@export var Key4 :XRToolsPickableKey = null

var open_rotation := Vector3(0, deg_to_rad(-90), 0)
var txt : MeshInstance3D = null

func _ready():
	Global.connect("key_snapped", Callable(self, "_on_key_snapped"))
	txt = get_node_or_null("SnapPoint/Texte")
func _on_key_snapped(snap_point_name):
	open_door()

func open_door():
	if Key1 and Key2 and Key3 and Key4 :
		if Key1.is_snapped and Key2.is_snapped and Key3.is_snapped and Key4.is_snapped :
			var t := create_tween()
			t.tween_property(self, "rotation", open_rotation, 1.0)
			t.set_trans(Tween.TRANS_SINE)
			t.set_ease(Tween.EASE_IN_OUT)
