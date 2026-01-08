extends Button

@export var scene_to_load: PackedScene   # Tu choisis la scène dans l’inspecteur

func _ready():
	connect("pressed", Callable(self, "_on_pressed"))

func _on_pressed():
	print("Bouton cliqué :", name)
	
	#get_tree().change_scene_to_file("res://Scenes/Basement_LVL.tscn")

	if scene_to_load:
		get_tree().change_scene_to_packed(scene_to_load)
	else:
		push_warning("Aucune scène assignée à 'scene_to_load'")
