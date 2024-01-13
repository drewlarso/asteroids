extends CharacterBody2D
class_name Player

signal laser_shot(laser_position, laser_direction)

@export var max_speed: int = 400
@export var acceleration: float = 10.0
@export var shoot_delay: float = 0.5

@onready var spawn_position: Marker2D = $SpawnPosition
@onready var radius: int = $CollisionShape2D.shape.radius

var direction = Vector2(1, 0)
var shoot_timer: float = 0.0

func _physics_process(delta: float) -> void:
	shoot_timer = move_toward(shoot_timer, 0, delta)
	move()
	wrap_screen()
	shoot()

func move() -> void:
	if Input.is_action_pressed('up'):
		velocity += direction.rotated(rotation) * acceleration
	if Input.is_action_pressed('down'):
		velocity -= direction.rotated(rotation) * acceleration
	if Input.is_action_pressed('left'):
		rotate(-0.075)
	if Input.is_action_pressed('right'):
		rotate(0.075)
	velocity = velocity.limit_length(max_speed)
	velocity = velocity.move_toward(Vector2.ZERO, acceleration / 3)
	move_and_slide()

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

func shoot() -> void:
	if Input.is_action_pressed('shoot'):
		if shoot_timer > 0: return
		shoot_timer = shoot_delay
		laser_shot.emit(spawn_position.global_position, direction.rotated(rotation))
