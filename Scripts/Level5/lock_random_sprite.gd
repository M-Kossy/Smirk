extends Sprite2D

@onready var random_lock: Area2D = $".."

var frames = texture.get_width() / region_rect.size.x
var frame_index: int

func choose_sprite():
	frame_index = random_lock.enum_index
	region_rect.position.x = frame_index * region_rect.size.x
