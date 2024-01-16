extends Node2D

@export var polygon: Polygon2D
@export var color: Color = Color.WHITE
@export var width: int = 2

func _ready() -> void:
	polygon.color.a = 0

func _draw() -> void:
	if not polygon: return
	var points: PackedVector2Array = polygon.polygon
	for i in range(points.size() - 1):
		draw_line(points[i], points[i + 1], color, width)
	draw_line(points[0], points[points.size() - 1], color, width)
