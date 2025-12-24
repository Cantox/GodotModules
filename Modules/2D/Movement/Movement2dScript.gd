class_name Movement2dModule extends Node
##A modules that reads an input (movement axis or position) and moves the 
##controlled [CharacterBody2D] node based on that input
##
##Uses a [Velocity2dModule] to modify the [param velocity] of the controlled node.[br]
##[br]
##Implemented inputs are: 2 axis, 1 axis (X / Y) and mouse position.

##The node on which the module's operations are applied
@export var controlledNode: CharacterBody2D
##The [Velocity2dModule] used to change the controlled node's [param velocity]
@export var velocityModule: Velocity2dModule

@export_group("Options")
##If true, accelleration is used to change the [param velocity] gradually
@export var useAccelleration: bool = false

func _ready() -> void:
	if controlledNode == null or velocityModule == null:
		get_tree().quit(1)

#region Directional keys
##Moves the controlled node based on a two axis input (X and Y)
func fourDirectionalMovement(keyUp: String, keyDown: String, keyLeft: String, keyRight: String, accellerate := useAccelleration):
	var dir = Input.get_vector(keyLeft, keyRight, keyUp, keyDown)
	
	if accellerate:
		velocityModule.accellerateInDirection(dir)
	else:
		velocityModule.moveInDirection(dir)

##Moves the controlled node based on a singular axis input (x axis)[br]
##Usually the negative action is left and the positive is right
func xAxisMovement(negativeAction: String, positiveAction: String, accellerate := useAccelleration):
	var axis = Input.get_axis(negativeAction,positiveAction)
	
	if accellerate:
		velocityModule.accellerateInDirection(Vector2(axis,0))
	else:
		velocityModule.moveInDirection(Vector2(axis,0))

##Moves the controlled node based on a singular axis input (y axis)[br]
##Usually the negative action is up and the positive is down
func yAxisMovement(negativeAction: String, positiveAction: String, accellerate := useAccelleration):
	var axis = Input.get_axis(negativeAction,positiveAction)
	
	if accellerate:
		velocityModule.accellerateInDirection(Vector2(0,axis))
	else:
		velocityModule.moveInDirection(Vector2(0,axis))
#endregion

##Moves the controlled node towards the mouse cursor
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
