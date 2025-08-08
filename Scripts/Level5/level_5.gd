extends Action

var held_object : CharacterBody2D = null
var disabled := true
var index = Array([], TYPE_INT, "Node", null)
var pos_locks : Array[Vector2]
var order: int = 0
var enum_index_level
var call_done := 0


func start():
	var i := 0
	pos_locks.shuffle()
	for node in get_children():
		if node.is_in_group("Lock"):
			node.reset()
			node.global_position = pos_locks[i]
			i += 1
		if node.is_in_group("Pickable"): 
			node.reset()
			enum_index_level = node.enum_index
	call_done = 0


func _ready() -> void:
	action_name = "Pair"
	order = 0
	for node in get_children():
		if node.is_in_group("Pickable"):
			node.clicked.connect(_on_pickable_object)
			index.append(node.enum_index)
	
	for node in get_children():
		if node.is_in_group("Lock"):
			pos_locks.append(node.global_position)
			node.unlock.connect(_on_random_lock_door_open)
			node.get_level_index(order)
			order += 1
			node.unlock.connect(_on_random_lock_door_open)


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
	for node in get_children():
		if node.is_in_group("Lock"):
			node.collision_shape_2d.set_deferred("disabled", false)
	
	for node in get_children():
		if node.is_in_group("Pickable"):
			node.set_deferred("disable", false)


func disable():
	disabled = true
	for node in get_children():
		if node.is_in_group("Lock"):
			node.collision_shape_2d.set_deferred("disabled", true)
			
	for node in get_children():
		if node.is_in_group("Pickable"):
			node.collision_shape_2d.set_deferred("disabled", true)


func remove_object():
	if held_object:
		held_object.drop()
		held_object = null


func _on_random_lock_door_open() -> void:
	SfxManager.create_audio(SoundEffectSettings.SOUND_EFFECT_TYPE.KEY_OPEN)
	remove_object()
	call_done += 1
	if call_done >= order:
		for node in get_children():
			if node.is_in_group("Pickable"): 
				node.reset_pos()
		is_done()
