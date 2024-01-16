extends CharacterBody2D
class_name Asteroid

signal split(asteroid: Asteroid)

enum Size {SMALL, MEDIUM, BIG}

@export var my_size: Size = Size.BIG

@onready var collision_shape: CollisionShape2D = $CollisionShape2D

var collider_small: CircleShape2D = preload('res://resources/collider_asteroid_small.tres')
var collider_medium: CircleShape2D = preload('res://resources/collider_asteroid_medium.tres')
var collider_big: CircleShape2D = preload('res://resources/collider_asteroid_big.tres')
var polygon_small: PackedScene = preload('res://scenes/asteroids/polygon_asteroid_small.tscn')
var polygon_medium: PackedScene = preload('res://scenes/asteroids/polygon_asteroid_medium.tscn')
var polygon_big: PackedScene = preload('res://scenes/asteroids/polygon_asteroid_big.tscn')

var direction: Vector2 = Vector2.from_angle(randf_range(0, 2 * PI))
var speed: int = 100
var rotation_speed: float = randf_range(-0.01, 0.01)
var radius: float = 64

func _ready() -> void:
	var polygon: Polygon2D
	match my_size:
		Size.SMALL:
			collision_shape.shape = collider_small
			polygon = polygon_small.instantiate()
			speed = randi_range(250, 300)
		Size.MEDIUM:
			collision_shape.shape = collider_medium
			polygon = polygon_medium.instantiate()
			speed = randi_range(200, 250)
		Size.BIG:
			collision_shape.shape = collider_big
			polygon = polygon_big.instantiate()
			speed = randi_range(150, 200)
	radius = collision_shape.shape.radius
	add_child(polygon)

func _physics_process(_delta: float) -> void:
	velocity = direction * speed
	move_and_slide()
	rotate(rotation_speed)
	wrap_screen()

func wrap_screen() -> void:
	var screen_size: Vector2 = get_viewport_rect().size
	if position.x < -radius:
		position.x = screen_size.x + radius
	if position.x > screen_size.x + radius:
		position.x = -radius
	if position.y < -radius:
		position.y = screen_size.y + radius
	if position.y > screen_size.y + radius:
		position.y = -radius

func destroy() -> void:
	split.emit(self)
