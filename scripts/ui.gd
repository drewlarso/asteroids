extends Control

signal reset_button_clicked

@onready var points_label: Label = $PointsLabel
@onready var reset_button: Button = $ResetButton

func _ready() -> void:
	reset_button.visible = false

func set_points_text(value: String) -> void:
	points_label.text = value

func _on_reset_button_pressed() -> void:
	reset_button_clicked.emit()
