extends Node2D

@export var playerId: int


var arrowPresentationTimeSeconds: float = 0.0
var arrowOrigPos: Vector2

func _ready() -> void:
	var arrow: Sprite2D = get_node("Arrow")
	arrowPresentationTimeSeconds = Time.get_ticks_msec()
	arrowOrigPos = arrow.position
	pass
	
func _process(delta: float) -> void:
	var arrow: Sprite2D = get_node("Arrow")
	if Time.get_ticks_msec() - arrowPresentationTimeSeconds > 12 * 1000:
		arrow.hide()
	particles_handle()
		
	
	arrow.position.y = arrowOrigPos.y + 80.0 * cos(
		(Time.get_ticks_msec() - arrowPresentationTimeSeconds) / 200 + PI)

func _on_area_2d_body_entered(body: Node2D) -> void:	
	if not GameplayGlobal.can_goal:
		return

	var player := body as CharacterBody2D
	if not player: 
		return 
		
	if player.velocity.y > 0:
		var arrow: Sprite2D = get_node("Arrow")
		GameplayGlobal.goal.emit(player.playerId)	
		arrow.hide()
	
	
func particles_handle():
	var particles = get_node("GPUParticles2D").process_material

	# Modify color using color_ramp
	particles.scale  = Vector2 (0.3, 0.3)
	particles.set("color" , Color(Color.YELLOW, 0.7))


	
