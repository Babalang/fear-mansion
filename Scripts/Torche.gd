extends Node3D

# === BATTERIE ===
@export var max_battery := 15.0
@export var cooldown_time := 5.0
var cooldown_elapsed := 0.0
var pulse_tween: Tween = null

# === CLIGNOTEMENT ===
@export var flicker_start_ratio := 0.35   # commence à 35% batterie
@export var flicker_max_strength := 0.6   # violence max du flicker
@export var flicker_speed := 5.0         # vitesse du bruit


var battery := max_battery
var is_on := false
var is_in_cooldown := false
var bat_25 : ColorRect = null
var bat_50 : ColorRect = null
var bat_75 : ColorRect = null
var bat_100 : ColorRect = null
var bat : TextureRect = null
var light : SpotLight3D = null
var percent : Label = null

const COLOR_FULL    := Color(0.2, 1.0, 0.2)   # vert maladif
const COLOR_75      := Color(0.9, 0.9, 0.2)   # jaune sale
const COLOR_50      := Color(1.0, 0.5, 0.1)   # orange
const COLOR_25      := Color(1.0, 0.1, 0.1)   # rouge
const COLOR_EMPTY   := Color(0.6, 0.0, 0.0)   # rouge sombre


func _ready():
	bat_25 = get_node_or_null("UI/SubViewport/battery_25")
	bat_50 = get_node_or_null("UI/SubViewport/battery_50")
	bat_75 = get_node_or_null("UI/SubViewport/battery_75")
	bat_100 = get_node_or_null("UI/SubViewport/battery_100")
	bat = get_node_or_null("UI/SubViewport/TextureRect")
	light = get_node_or_null("Light")
	if light != null : light.visible = false
	percent = get_node_or_null("UI/SubViewport/percent")
	Global.connect("toggle_light", Callable(self, "toggle"))


func update_battery_ui():
	var c := get_battery_color()
	if bat:
		bat.modulate = c
	if percent:
		percent.modulate = c
	if bat_100:
		bat_100.visible = battery > max_battery * 0.75
		bat_100.color = COLOR_FULL
	if bat_75:
		bat_75.visible = battery > max_battery * 0.5
		bat_75.color = COLOR_75
	if bat_50:
		bat_50.visible = battery > max_battery * 0.25
		bat_50.color = COLOR_50
	if bat_25:
		bat_25.visible = battery > 0
		bat_25.color = COLOR_25
	if battery <= max_battery * 0.25 and is_on:
		pulse_icon()
	else:
		stop_pulse()
	percent.text = "Battery: %.1f%%" % ((battery / max_battery) * 100.0)


func _process(delta):
	if is_on:
		battery -= delta
		if battery <= 0.0:
			battery = 0.0
			turn_off()
			start_cooldown()
	else:
		if is_in_cooldown:
			cooldown_elapsed += delta
			battery = lerp(0.0, max_battery, cooldown_elapsed / cooldown_time)

			if cooldown_elapsed >= cooldown_time:
				battery = max_battery
				is_in_cooldown = false
		else:
			battery = min(battery + delta * 0.5, max_battery)
	update_battery_ui()
	apply_flicker(delta)



func toggle():
	if is_in_cooldown:
		return

	if is_on:
		turn_off()
	else:
		if battery > 0:
			turn_on()

func turn_on():
	is_on = true
	light.visible = true

func turn_off():
	is_on = false
	light.visible = false

func start_cooldown():
	if is_in_cooldown:
		return
	is_in_cooldown = true
	cooldown_elapsed = 0.0
	print("Batterie vide, recharge en cours…")

func pulse_icon():
	if not bat or not percent or pulse_tween:
		return
	pulse_tween = create_tween()
	pulse_tween.set_loops()
	pulse_tween.tween_property(bat, "modulate:a", 0.2, 0.4)
	pulse_tween.tween_property(bat, "modulate:a", 1.0, 0.4)
	pulse_tween.tween_property(percent, "modulate:a", 0.2, 0.4)
	pulse_tween.tween_property(percent, "modulate:a", 1.0, 0.4)

func stop_pulse():
	if pulse_tween:
		pulse_tween.kill()
		pulse_tween = null
	if bat:
		bat.modulate.a = 1.0
	if percent:
		percent.modulate.a = 1.0


func get_battery_color() -> Color:
	var ratio := battery / max_battery
	if ratio > 0.75:
		return COLOR_FULL
	elif ratio > 0.5:
		return COLOR_75
	elif ratio > 0.25:
		return COLOR_50
	elif ratio > 0.0:
		return COLOR_25
	else:
		return COLOR_EMPTY

func apply_flicker(delta: float) -> void:
	if not is_on or not light:
		return

	var ratio: float = battery / max_battery

	if ratio > flicker_start_ratio:
		light.light_energy = 1.0
		light.visible = true
		return

	var danger: float = 1.0 - (ratio / flicker_start_ratio)

	var time: float = Time.get_ticks_msec() * 0.001
	var noise: float = sin(time * flicker_speed)

	var flicker: float = lerp(1.0, noise, danger * flicker_max_strength)

	light.light_energy = clamp(flicker, 0.2, 1.0)

	if danger > 0.6 and randi() % 40 == 0:
		light.visible = false
	else:
		light.visible = true
