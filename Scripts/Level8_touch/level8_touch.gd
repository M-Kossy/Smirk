extends Action

@onready var little_mouses: Node2D = $little_mouses

@onready var left: Area2D = $Bordure/Left
@onready var right: Area2D = $Bordure/Right
@onready var down: Area2D = $Bordure/Down
@onready var up: Area2D = $Bordure/Up


func _ready() -> void:
	little_mouses.end.connect(_on_end)
	
	left.area_entered.connect(_on_left)
	right.area_entered.connect(_on_right)
	up.area_entered.connect(_on_up)
	down.area_entered.connect(_on_down)


func start():
	little_mouses.reset()

func _on_right(body : Node2D):
	if body is Mouse:
		body.direction_x = -1

func _on_left(body : Node2D):
	if body is Mouse:
		body.direction_x = 1

func _on_up(body : Node2D):

	if body is Mouse:
		body.direction_y = 1

func _on_down(body : Node2D):
	if body is Mouse:
		body.direction_y = -1

func _on_end():
	is_done()
