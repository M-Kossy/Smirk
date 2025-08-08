extends Action

var held_object : CharacterBody2D = null
var disabled := true
var rand_maze :int


@onready var maze_2: Area2D = $Maze2
@onready var maze: Area2D = $Maze
@onready var litte_star: CharacterBody2D = $LitteStar
@onready var little_star_pos: Vector2


func _ready() -> void:
	action_name = "Touch_the_wall"
	maze.touched.connect(maze_touched)
	maze.finished.connect(maze_end)
	maze_2.touched.connect(maze_touched)
	maze_2.finished.connect(maze_end)
	litte_star.clicked.connect(_on_pickable_object)


func start():
	randomize()
	rand_maze = randi_range(0, 1)
	litte_star.reset()
	if rand_maze == 0:
		little_star_pos = Vector2(-417.0,4.0)
		litte_star.global_position = little_star_pos
		maze.mask()
		maze_2.demask()
	if rand_maze == 1:
		little_star_pos = Vector2(-183.0,15.0)
		litte_star.global_position = little_star_pos
		maze.demask()
		maze_2.mask()


func maze_touched(body : CharacterBody2D):
	if body == litte_star:
		SfxManager.create_audio(SoundEffectSettings.SOUND_EFFECT_TYPE.WALL_FAIL)
		litte_star.touched_wall(little_star_pos)


func maze_end(body : CharacterBody2D):
	if body == litte_star:
		is_done()


func _on_pickable_object(object : CharacterBody2D):
	if disabled:
		remove_object()
		return
	
	if !held_object:
		object.pickup()
		held_object = object


func _unhandled_input(event: InputEvent) -> void:
	if disabled:
		remove_object()
		return
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if held_object and !event.pressed:
			held_object.drop()
			held_object = null


func enable():
	disabled = false


func disable():
	disabled = true
	remove_object()


func remove_object():
	if held_object:
		held_object.drop()
		held_object = null
