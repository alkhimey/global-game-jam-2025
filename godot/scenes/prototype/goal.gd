extends Node2D

@export var playerId: int
@export var arrow: Sprite2D

var arrowPresentationTimeSeconds: float = 5.0
var arrowOrigPos: Vector2

func _ready() -> void:
	arrowPresentationTimeSeconds = Time.get_ticks_msec()
	arrowOrigPos = arrow.position
	pass
	
func _process(delta: float) -> void:
	if Time.get_ticks_msec() - arrowPresentationTimeSeconds > 5 * 1000:
		arrow.hide()
		
	
	arrow.position.y = arrowOrigPos.y + 80.0 * cos(
		(Time.get_ticks_msec() - arrowPresentationTimeSeconds) / 200 + PI)

func _on_area_2d_body_entered(body: Node2D) -> void:	
	if not GameplayGlobal.can_goal:
		return

	var player := body as CharacterBody2D
	if not player: 
		return 
		
	if player.velocity.y > 0:
		GameplayGlobal.goal.emit(player.playerId)	
		arrow.hide()
	
