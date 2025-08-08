extends Node2D

@export var number_of_objects: int = 10
@export var object_scene := preload("res://Scenes/Level2_StarGame/Key_lvl2.tscn")
@export var spawn_area: Rect2 = Rect2(Vector2(0,0), Vector2(500, 300))  # zone de génération

func _ready():
	generate_objects()

func generate_objects():
	for i in range(number_of_objects):
		var instance = object_scene.instantiate()
		var random_pos = Vector2(
			randf_range(spawn_area.position.x, spawn_area.position.x + spawn_area.size.x),
			randf_range(spawn_area.position.y, spawn_area.position.y + spawn_area.size.y)
		)
		instance.position = random_pos
		add_child(instance)

func reset():
	for key in get_children():
		key.reset()
		randomize()
		var random_pos = Vector2(
			randf_range(spawn_area.position.x, spawn_area.position.x + spawn_area.size.x),
			randf_range(spawn_area.position.y, spawn_area.position.y + spawn_area.size.y)
		)
		key.position = random_pos
		if key is Key_lvl2:
			
			randomize()
			var value := randi_range(0, EColor.ENUM_COLOR.size() - 1 )
			key.set_sprite(value)
			
			randomize()
			value = randi_range(0, 360)
			key.set_key_rotation(value)
		else:
			randomize()
			var value := randi_range(0, get_child_count())
			move_child(key, value)

func disable():
	for key in get_children():
		key.collision_shape_2d.set_deferred("disabled", true)

func enable():
	for key in get_children():
		key.collision_shape_2d.set_deferred("disabled", false)
