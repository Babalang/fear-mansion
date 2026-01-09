extends Node

signal focus_lost
signal focus_gained
signal pose_recentered

@export var maximum_refresh_rate: int = 90

var xr_interface: OpenXRInterface
var xr_is_focussed = false
var initialized := false

func _ready():
	if initialized:
		return
	initialized = true

	xr_interface = XRServer.find_interface("OpenXR")
	if not xr_interface or not xr_interface.is_initialized():
		push_error("OpenXR not available")
		return

	var vp: Viewport = get_viewport()
	vp.use_xr = true
	DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)

	if RenderingServer.get_rendering_device():
		vp.vrs_mode = Viewport.VRS_XR

	# Connect the OpenXR events
	xr_interface.session_begun.connect(_on_openxr_session_begun)
	xr_interface.session_visible.connect(_on_openxr_visible_state)
	xr_interface.session_focussed.connect(_on_openxr_focused_state)
	xr_interface.session_stopping.connect(_on_openxr_stopping)
	xr_interface.pose_recentered.connect(_on_openxr_pose_recentered)

	print("OpenXR initialized once")

func _on_openxr_session_begun() -> void:
	var current_refresh_rate = xr_interface.get_display_refresh_rate()
	print("OpenXR: Refresh rate reported as ", current_refresh_rate)
	# Optionnel : changer refresh rate
	var new_rate = current_refresh_rate
	for rate in xr_interface.get_available_display_refresh_rates():
		if rate > new_rate and rate <= maximum_refresh_rate:
			new_rate = rate
	if new_rate != current_refresh_rate:
		xr_interface.set_display_refresh_rate(new_rate)
		print("OpenXR: Setting refresh rate to ", new_rate)

func _on_openxr_visible_state() -> void:
	if xr_is_focussed:
		print("OpenXR lost focus")
		xr_is_focussed = false
		emit_signal("focus_lost")

func _on_openxr_focused_state() -> void:
	print("OpenXR gained focus")
	xr_is_focussed = true
	emit_signal("focus_gained")

func _on_openxr_stopping() -> void:
	print("OpenXR is stopping")

func _on_openxr_pose_recentered() -> void:
	emit_signal("pose_recentered")

func _process(_delta: float) -> void:
	if Engine.get_frames_drawn() % 60 == 0:
		print("FPS:", Engine.get_frames_per_second())
