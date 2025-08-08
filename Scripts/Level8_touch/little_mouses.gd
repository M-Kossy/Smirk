extends Node2D

@export var number_of_objects: int = 10
@export var object_scene := preload("res://Scenes/Level8_touch/mouse.tscn") 
@export var spawn_area: Rect2 = Rect2(Vector2(0,0), Vector2(500, 300))  # zone de génération

@export var speed_min := 250
@export var speed_max := 400

signal end

var count := 0

func _ready():
	generate_objects()
	for mouse in get_children():
		mouse.clicked.connect(_on_click)

func generate_objects():
	for i in range(number_of_objects):
		var instance := object_scene.instantiate()
		randomize()
		var random_pos = Vector2(
			randf_range(spawn_area.position.x, spawn_area.position.x + spawn_area.size.x),
			randf_range(spawn_area.position.y, spawn_area.position.y + spawn_area.size.y)
		)
		instance.position = random_pos
		
		randomize()
		instance.speed_x = randi_range(speed_min, speed_max)
		if randi() % 2 == 0:
			instance.direction_x = 1
		else:
			instance.direction_x = -1
		
		randomize()
		instance.speed_y = randi_range(speed_min, speed_max)
		if randi() % 2 == 0:
			instance.direction_y = 1
		else:
			instance.direction_y = -1
		
		add_child(instance)

func reset():
	for mouse in get_children():
		mouse.reset()
		randomize()
		var random_pos = Vector2(
			randf_range(spawn_area.position.x, spawn_area.position.x + spawn_area.size.x),
			randf_range(spawn_area.position.y, spawn_area.position.y + spawn_area.size.y)
		)
		mouse.position = random_pos
		
		randomize()
		mouse.speed_x = randi_range(speed_min, speed_max)
		if randi() % 2 == 0:
			mouse.direction_x = 1
		else:
			mouse.direction_x = -1
		
		randomize()
		mouse.speed_y = randi_range(speed_min, speed_max)
		if randi() % 2 == 0:
			mouse.direction_y = 1
		else:
			mouse.direction_y = -1
	count = 0
func disable():
	for mouse in get_children():
		mouse.collision_shape_2d.set_deferred("disabled", true)
		mouse.set_physics_process(false)

func enable():
	for mouse in get_children():
		mouse.collision_shape_2d.set_deferred("disabled", false)
		if !mouse.disable:
			mouse.set_physics_process(true)


func _on_click(body : Node2D):
	count += 1
	body.disable = true
	
	if count >= get_child_count():
		end.emit()
	
