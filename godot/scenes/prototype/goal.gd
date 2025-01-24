extends Node2D

@export var playerId: int

func _ready() -> void:
	pass

func _on_area_2d_body_entered(body: Node2D) -> void:	
	if not GameplayGlobal.can_goal:
		return

	var player := body as CharacterBody2D
	if not player: 
		return 
		
	if player.velocity.y > 0:
		GameplayGlobal.goal.emit(player.playerId)
