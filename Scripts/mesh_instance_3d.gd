extends MeshInstance3D

# Scene 2D à afficher
@export var menu_2d_scene: PackedScene = preload("res://Scenes/Menu_Principal.tscn")
@export var subviewport_size: Vector2 = Vector2(1024, 1024)

var subviewport: SubViewport
var menu_instance: Control

func _ready():
	subviewport = SubViewport.new()
	subviewport.size = subviewport_size
	subviewport.render_target_update_mode = SubViewport.UPDATE_ALWAYS
	subviewport.render_target_clear_mode = SubViewport.CLEAR_MODE_ALWAYS
	subviewport.disable_3d = true
	subviewport.transparent_bg = true
	add_child(subviewport)
	menu_instance = menu_2d_scene.instantiate()
	subviewport.add_child(menu_instance)
	var mat = StandardMaterial3D.new()
	mat.albedo_texture = subviewport.get_texture()
	mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	self.set_surface_override_material(0, mat)
	var plane_scale = self.scale
	plane_scale.x = subviewport_size.x / subviewport_size.y
	self.scale = plane_scale
