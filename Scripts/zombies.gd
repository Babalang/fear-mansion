extends Node3D
@onready var anim := $AnimationPlayer

func _ready():
	anim.play("Object_0")
	anim.animation_finished.connect(_on_anim_finished)

func _on_anim_finished(name: String):
	if name == "Object_0":
		anim.play("Object_0")
