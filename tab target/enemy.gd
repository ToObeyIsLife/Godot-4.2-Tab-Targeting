extends CharacterBody2D
@onready var highlightNode = $highlight


func is_enemy() -> bool:
	return true
