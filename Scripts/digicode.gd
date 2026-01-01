extends Node3D

var button : MeshInstance3D = null
var label : Label = null
var original_mat : Material = null

func _ready():
	button = get_node_or_null("Bouton")
	label = get_node_or_null("Bouton/SubViewport/Label")
	label.text = self.name
	original_mat = button.get_active_material(0)
	Global.connect("in_ray", interact)


func interact(name1: String):
	if name1 == self.name:
		highlight_mat()
	else:
		clear_highlight()


func highlight_mat():
	if original_mat:
		original_mat.emission_enabled = true
		original_mat.emission = Global.color_snap
		original_mat.emission_energy = 1.5


func clear_highlight():
	if original_mat:
		original_mat.emission_enabled = false


func process_interaction():
	if Global.digicode.length() >= 4:
		Global.digicode = ""
	Global.digicode += self.name
	if Global.digicode == Global.code_first_floor:
		Global.emit_signal("Open_first_floor")
