extends Node2D

@export var max_asteroid_count: int = 10

@onready var ui: Control = $CanvasLayer/UI
@onready var laser_storage: Node = $Lasers
@onready var asteroid_storage: Node = $Asteroids

var asteroid_scene: PackedScene = preload('res://scenes/asteroids/asteroid.tscn')
var player_scene: PackedScene = preload('res://scenes/player.tscn')
var laser_scene: PackedScene = preload('res://scenes/laser.tscn')

var asteroids: Array[Asteroid] = []
var asteroid_spawn_delay: float = 0.5
var game_over: bool = false
var points: int = 0:
	set(val):
		points = val
		ui.set_points_text(str(points))

func _ready() -> void:
	get_tree().paused = false
	var player: Player = player_scene.instantiate()
	player.global_position = get_viewport_rect().size / 2
	player.laser_shot.connect(spawn_laser)
	player.died.connect(trigger_game_over)
	add_child(player)

func _physics_process(delta: float) -> void:
	asteroid_spawn_delay -= delta
	if not asteroid_spawn_delay <= 0.0: return
	
	if asteroids.size() < max_asteroid_count:
		asteroid_spawn_delay = randf_range(0.5, 1.5)
		spawn_asteroid()

func spawn_laser(pos: Vector2, dir: Vector2) -> void:
	var new_laser: Laser = laser_scene.instantiate()
	new_laser.global_position = pos
	new_laser.direction = dir
	laser_storage.add_child(new_laser)

func spawn_asteroid(my_position: Vector2 = Vector2.ZERO, size: Asteroid.Size = Asteroid.Size.BIG) -> void:
	var screen_size: Vector2 = get_viewport_rect().size
	var new_asteroid: Asteroid = asteroid_scene.instantiate()
	if my_position == Vector2.ZERO:
		var random_choice: float = randf()
		if random_choice <= 0.5:
			var random_x: float = randf_range(0, screen_size.x)
			new_asteroid.position = Vector2(random_x, 0 - new_asteroid.radius)
		else:
			var random_y: float = randf_range(0, screen_size.y)
			new_asteroid.position = Vector2(0 - new_asteroid.radius, random_y)
	else:
		new_asteroid.position = my_position
	new_asteroid.my_size = size
	new_asteroid.split.connect(split_asteroid)
	asteroids.append(new_asteroid)
	asteroid_storage.call_deferred('add_child', new_asteroid)

func split_asteroid(asteroid: Asteroid) -> void:
	match asteroid.my_size:
		Asteroid.Size.SMALL:
			points += 150
		Asteroid.Size.MEDIUM:
			points += 100
			spawn_asteroid(asteroid.position, Asteroid.Size.SMALL)
			spawn_asteroid(asteroid.position, Asteroid.Size.SMALL)
		Asteroid.Size.BIG:
			points += 50
			spawn_asteroid(asteroid.position, Asteroid.Size.MEDIUM)
			spawn_asteroid(asteroid.position, Asteroid.Size.MEDIUM)
	asteroids.erase(asteroid)
	asteroid.queue_free()

func trigger_game_over() -> void:
	game_over = true
	ui.reset_button.visible = true
	get_tree().paused = true

func _on_ui_reset_button_clicked() -> void:
	get_tree().reload_current_scene()
