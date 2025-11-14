class_name Movement2dModule extends Node
@export var controlledNode: Node2D
@export var velocityModule: Velocity2dModule

@export_group("Options")
@export var useAccelleration: bool = false

func _physics_process(_delta: float) -> void:
	#fourDirectionalMovement("ui_up","ui_down","ui_left","ui_right")
	#horizontalMovement_keyInput("ui_left","ui_right")
	toMousePosition()

#region Directional keys
func fourDirectionalMovement(keyUp: String, keyDown: String, keyLeft: String, keyRight: String, accellerate := useAccelleration):
	var dir = Input.get_vector(keyLeft, keyRight, keyUp, keyDown)
	
	if accellerate:
		velocityModule.accellerateInDirection(dir)
	else:
		velocityModule.moveInDirection(dir)

func horizontalMovement(keyLeft: String, keyRight: String, accellerate := useAccelleration):
	var axis = Input.get_axis(keyLeft,keyRight)
	
	if accellerate:
		velocityModule.accellerateInDirection(Vector2(axis,0))
	else:
		velocityModule.moveInDirection(Vector2(axis,0))

func verticalMovement(keyUp: String, keyDown: String, accellerate := useAccelleration):
	var axis = Input.get_axis(keyUp,keyDown)
	
	if accellerate:
		velocityModule.accellerateInDirection(Vector2(0,axis))
	else:
		velocityModule.moveInDirection(Vector2(0,axis))
#endregion

func toMousePosition(accellerate := useAccelleration):
	var mousePos = controlledNode.get_global_mouse_position()
	
	if accellerate:
		# Check if there is enough distance to slow down
		if controlledNode.global_position.distance_to(mousePos) > 50: # ADD CALCULATION OF DISTANCE NEEDED TO SLOW DOWN
			velocityModule.accellerateToPos(mousePos)
		elif controlledNode.global_position == mousePos:
			velocityModule.applyVelocity(Vector2(0,0))
		else:
			velocityModule.decellerateToPos(mousePos)
	else:
		velocityModule.moveToPos(mousePos)
