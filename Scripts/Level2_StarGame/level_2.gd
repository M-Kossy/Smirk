extends Action 
var held_object : CharacterBody2D = null
var disabled := true


@onready var door_lvl_2: Area2D = $DoorLvl2
@onready var node_keys: Node = $key_list

func start():
	node_keys.reset()
	door_lvl_2.reset()

func _ready() -> void:
	action_name = "Find_the_star"
	door_lvl_2.door_open.connect(_on_door_open)
	for node in node_keys.get_children():
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
	node_keys.enable()
	door_lvl_2.collision_shape_2d.set_deferred("disabled", false)
	
func disable():
	
	disabled = true
	node_keys.disable()
	door_lvl_2.collision_shape_2d.set_deferred("disabled", true)


func _on_door_open() -> void:
	remove_object()
	is_done()

func remove_object():
	if held_object:
		held_object.drop()
		held_object = null
