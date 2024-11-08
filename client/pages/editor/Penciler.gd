extends Node2D

const LAYER = preload("res://layers/Layer.tscn")

@onready var layers: Node2D = get_node("../Layers")
@onready var bg: Node2D = get_node("../BG")
@onready var editor_events: Node2D = get_node("../EditorEvents")


func _ready():
	editor_events.connect("level_event", _on_level_event)


func _on_level_event(event: Dictionary) -> void:
	if event.type == EditorEvents.SET_TILE:
		var tilemap: TileMap = layers.get_node(event.layer_name + "/TileMap")
		tilemap.set_cell(0, event.coords, 0, Helpers.to_atlas_coords(event.block_id))
	if event.type == EditorEvents.ADD_LINE:
		var lines: Node2D = layers.get_node(event.layer_name + "/Lines")
		var line = Line2D.new()
		lines.add_child(line)
		line.end_cap_mode = Line2D.LINE_CAP_ROUND
		line.begin_cap_mode = Line2D.LINE_CAP_ROUND
		line.position = event.position
		line.points = event.points
	if event.type == EditorEvents.ADD_LAYER:
		var layer = LAYER.instantiate()
		layer.name = event.name
		layer.layer = 10
		layers.add_child(layer)
		layer.init(get_parent().tiles)
	if event.type == EditorEvents.DELETE_LAYER:
		var layer = layers.get_node(event.name)
		if layer:
			layers.remove_child(layer)
			layer.queue_free()
	if event.type == EditorEvents.ADD_USERTEXT:
		var usertextboxes: Node2D = layers.get_node(event.layer_name + "/UserTextboxes")
		var usertextbox_scene: PackedScene = preload("res://pages/editor/menu/UserTextbox.tscn")
		var usertextbox = usertextbox_scene.instantiate()
		usertextbox.set_usertext_properties(event.usertext, event.font, event.font_size)
		usertextboxes.add_child(usertextbox)
		usertextbox.position = event.position
	if event.type == EditorEvents.ROTATE_LAYER:
		var layer = layers.get_node(event.layer_name)
		layer.get_node("TileMap").rotation_degrees = event.rotation
	if event.type == EditorEvents.LAYER_DEPTH:
		var layer = layers.get_node(event.layer_name)
		layer.set_depth(event.depth)
	if event.type == EditorEvents.SET_BACKGROUND:
		bg.set_bg(event.bg)
