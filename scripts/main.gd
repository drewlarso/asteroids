extends Node2D

@onready var laser_storage: Node = $Lasers

var player_scene: PackedScene = preload('res://scenes/player.tscn')
var laser_scene: PackedScene = preload('res://scenes/laser.tscn')

func _ready() -> void:
	var player: Player = player_scene.instantiate()
	player.global_position = get_viewport_rect().size / 2
	player.laser_shot.connect(spawn_laser)
	add_child(player)

func spawn_laser(pos: Vector2, dir: Vector2) -> void:
	var new_laser: Laser = laser_scene.instantiate()
	new_laser.global_position = pos
	new_laser.direction = dir
	laser_storage.add_child(new_laser)
