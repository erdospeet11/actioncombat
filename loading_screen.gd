extends Control

@onready var model = $PreviewPanel/SubViewportContainer/SubViewport/Model
@onready var preview_panel = $PreviewPanel
@onready var sub_viewport_container = $PreviewPanel/SubViewportContainer

var is_dragging = false
var sensitivity = 0.01

func _ready():
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	preview_panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	sub_viewport_container.mouse_filter = Control.MOUSE_FILTER_IGNORE

func _on_start_button_pressed():
	get_tree().change_scene_to_file("res://main.tscn")

func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			is_dragging = event.pressed
	elif event is InputEventMouseMotion and is_dragging:
		model.rotate_y(event.relative.x * sensitivity)
