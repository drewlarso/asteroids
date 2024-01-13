extends Area2D
class_name Laser

@onready var radius = $CollisionShape2D.shape.radius

var direction: Vector2 = Vector2(1, 0)
var speed: int = 500
var wrap_count: int = 0

func _ready() -> void:
	rotation = direction.angle()

func _physics_process(delta: float) -> void:
	global_position += direction * speed * delta
	wrap_screen()

func wrap_screen() -> void:
	if wrap_count > 1: queue_free()
	var screen_size: Vector2 = get_viewport_rect().size
	if position.x < -radius:
		position.x = screen_size.x + radius
		wrap_count += 1
	if position.x > screen_size.x + radius:
		position.x = -radius
		wrap_count += 1
	if position.y < -radius:
		position.y = screen_size.y + radius
		wrap_count += 1
	if position.y > screen_size.y + radius:
		position.y = -radius
		wrap_count += 1
