extends Area2D
class_name Laser

@onready var radius = $CollisionShape2D.shape.radius

var direction: Vector2 = Vector2(1, 0)
var speed: int = 800
var wrap_count: int = 0

func _ready() -> void:
	rotation = direction.angle()

func _physics_process(delta: float) -> void:
	global_position += direction * speed * delta

func _on_body_entered(body: Node2D) -> void:
	if body is Asteroid:
		body.destroy()
		queue_free()

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
