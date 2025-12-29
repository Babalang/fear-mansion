extends MeshInstance3D
var text_lbl : Label = null
# Dans le script de la porte
func _ready():
	text_lbl= get_node_or_null("SubViewport/texte_label")
	Global.connect("display_txt", Callable(self, "_on_displayer"))

func _on_displayer(texte):
	if text_lbl:
		text_lbl.text = texte
