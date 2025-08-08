extends Action 
var held_object : CharacterBody2D = null
var disabled := true


@onready var door: Door = $Door
@onready var key: Key = $Key
@onready var random_key: CharacterBody2D = $Random_key


func start():
	key.reset()
	door.reset()

func _ready() -> void:
	action_name = "Key_is_lava"
	for node in get_children():
		if node.is_in_group("Pickable"):
			node.clicked.connect(_on_pickable_object)

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
	door.collision_shape_2d.set_deferred("disabled", false)
	key.set_deferred("disable", false)
func disable():
	disabled = true
	# door.collision_shape_2d.disabled = true
	door.collision_shape_2d.set_deferred("disabled", true)
	key.collision_shape_2d.set_deferred("disabled", true)
		# key.collision_shape_2d.disabled = true

func _on_door_open() -> void:
	remove_object()
	is_done()

func remove_object():
	if held_object:
		held_object.drop()
		held_object = null
