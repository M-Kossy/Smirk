extends Node2D

@onready var area_2d: Area2D = $Area2D
@onready var collision_polygon_2d: CollisionPolygon2D = $Area2D/CollisionPolygon2D
@onready var point_light_2d: PointLight2D = $Area2D/PointLight2D

signal on_light

func _ready() -> void:
	area_2d.body_entered.connect(_on_body_entered)

func is_activated(b : bool):
	collision_polygon_2d.set_deferred("disabled", !b)

func _on_body_entered(body : Node2D):
	on_light.emit(body)
