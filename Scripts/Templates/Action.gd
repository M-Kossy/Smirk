extends Node2D
class_name Action

signal done

var action_name: String

func start():
	pass

func enable():
	pass
	
func disable():
	pass

func update(delta : float):
	pass

func is_done():
	done.emit()
