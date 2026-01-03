extends Node3D

@export var feuille : bool = true
@onready var f := $Sketchfab_model/db5c903aa2f4459c8f46a0b1bebd84f4_fbx/Object_2/RootNode/Secretary/Drawer/Drawer_Drawer2_0/Paper
func _ready() -> void:
	if feuille == false:
		f.visible = false
	
	
