extends Sprite2D

var frames = texture.get_width() / region_rect.size.x
@export var enum_color: EColor.ENUM_COLOR


func _ready() -> void:
	randomize()
	var random_index = randi_range(0, frames -1)
	
	match random_index:
		0:
			enum_color = EColor.ENUM_COLOR.DIAMOND
		1:
			enum_color = EColor.ENUM_COLOR.CLUB
		2:
			enum_color = EColor.ENUM_COLOR.HEART
		3:
			enum_color = EColor.ENUM_COLOR.SPADE
	
	region_rect.position.x = random_index * region_rect.size.x
