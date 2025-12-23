class_name Velocity2dModule extends Node2D
##A module that handles the variation of a CharacterBody2D node's velocity
##
##A curve is implemented to customize the accelleration of the node [br][br]
##
##Use the "accellerate" / "decellerate" functions to chancge the velocity using the accelleration / friction. 
##Use the "move" function to change the velocity without using the accelleration / decelleration


##The node on which the module's operations are applied
@export var controlledNode: CharacterBody2D

@export_group("Variables")
##The maximum velocity value measured in m/s
@export var maxSpeed: float = 50
##The increment in velocity measured in m/s
@export var accelleration: float = 5
##The decrement in velocity measured in m/s
@export var friction: float = 5

##Conversion of accelleration and friction to use the curve
@onready var accellCurveStep: float = accelleration / maxSpeed
@onready var frictionCurveStep: float = friction / maxSpeed

@export_group("Accelleration curve")
##The curve that dictates the variation of velocity from 0 to max
##and viceversa
@export var accellerationCurve: Curve

##The current x position on the accelleration curve
var curveOffset: float = 0

func _ready() -> void:
	if controlledNode == null or accellerationCurve == null:
		get_tree().quit(1)
	
	accellCurveStep = clampf(accellCurveStep,0,1)
	frictionCurveStep = clampf(frictionCurveStep,0,1)

func _physics_process(_delta: float) -> void:
	controlledNode.move_and_slide()

#region Accelleration functions
##Changes gradually the velocity of the controlled node (using accelleration and curve) 
##to make it move to the given position
func accellerateToPos(pos: Vector2):
	accellerateInDirection(controlledNode.global_position.direction_to(pos))

##Changes gradually the velocity of the controlled node (using friction and curve) 
##to make it decellerate and stop at the given position
func decellerateToPos(pos: Vector2):
	decellerateInDirection(controlledNode.global_position.direction_to(pos))

##Changes gradually the velocity of the controlled node (using accelleration and curve) 
##to make it move in the given direction
var lastDir := Vector2(0,0)
func accellerateInDirection(dir: Vector2):
	dir = dir.normalized()
	
	# Interpolate between 0 and maxSpeed based on the accelleration curve. Multiply the value with the dir. Modify the curveOffset by the accell/friction to move along the curve
	if dir != Vector2(0,0):
		controlledNode.velocity = interpolate(0.0,maxSpeed,accellerationCurve.sample(curveOffset)) * dir
		curveOffset += accellCurveStep
		lastDir = dir
	else:
		decellerateInDirection(lastDir)
	
	curveOffset = clampf(curveOffset,0,1)

##Changes gradually the velocity of the controlled node (using friction and curve) 
##to make it slow down while moving in the given direction
func decellerateInDirection(dir: Vector2):
	controlledNode.velocity = interpolate(0.0,maxSpeed,accellerationCurve.sample(curveOffset)) * dir
	curveOffset -= frictionCurveStep
	
	curveOffset = clampf(curveOffset,0,1)

##Interpolation formula that returns a fraction (based on t) of the distance between points a and b
func interpolate(a,b,t):
	return a + (b - a) * t # Initial pos (a) + a fraction (t) of the distance between initial and final pos (a,b)
#endregion

#region Move functions (no accelleration)
##Changes the velocity of the controlled node
##to make it move to the given position
func moveToPos(pos: Vector2):
	moveInDirection(controlledNode.global_position.direction_to(pos))

##Changes the velocity of the controlled node
##to make it move in the given direction
func moveInDirection(dir: Vector2):
	dir = dir.normalized()
	controlledNode.velocity = maxSpeed * dir
#endregion

#region Apply velocity functions
##Applies the given velocity
func applyVelocity(vel: Vector2):
	controlledNode.velocity = vel

##Applies the given vertical velocity
func applyVerticalVelocity(vel: float):
	controlledNode.velocity.y = vel

##Applies the given horizontal velocity
func applyHorizontalVelocity(vel: float):
	controlledNode.velocity.x = vel
#endregion

#region Setters
func setMaxSpeed(amount: float):
	maxSpeed = amount

func setAccelleration(amount: float):
	accelleration = amount

func setFriction(amount: float):
	friction = amount
#endregion
