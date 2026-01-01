extends Label

func _ready():
	Global.connect("digicode_changed", _on_digicode_changed)
	_on_digicode_changed(Global.digicode)



func _on_digicode_changed(value: String):
	text = value
