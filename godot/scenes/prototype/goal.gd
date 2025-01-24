extends Area2D

@export var playerId: int

func _ready() -> void:
	body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node2D):
	if not GameplayGlobal.can_goal:
		return

	var player := body as CharacterBody2D
	
	if not player: 
		return 
		
	if playerId != player.playerId: 
		GameplayGlobal.goal.emit(player.playerId)
