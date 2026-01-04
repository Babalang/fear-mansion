extends Label

func _ready():
	Global.connect("digicode2_changed", _on_digicode_changed)
	_on_digicode_changed(Global.digicode2)



func _on_digicode_changed(value: String):
	text = value
