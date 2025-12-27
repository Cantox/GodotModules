class_name Velocity3dModule extends Node3D
##A module that handles the variation of a [CharacterBody3D]'s [param velocity]
##
##A curve is implemented to customize the accelleration of the node [br][br]
##
##Use the "accellerate" / "decellerate" functions to change the [param velocity] using the accelleration / friction. 
##Use the "move" function to change the [paran velocity] without using the accelleration / decelleration

##The node on which the module's operations are applied
@export var controlledNode: CharacterBody3D

@export_group("Variables")
##The maximum [param velocity] value, measured in m/s
@export var maxSpeed: float = 50
##The increment in [param velocity], measured in m/s
@export var accelleration: float = 5
##The decrement in [param velocity], measured in m/s
@export var friction: float = 5

##Conversion of accelleration and friction to use the curve
@onready var accellCurveStep: float = accelleration / maxSpeed
@onready var frictionCurveStep: float = friction / maxSpeed

@export_group("Accelleration curve")
##The curve that dictates the variation of [param velocity] from 0 to [param maxSpeed]
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
##Changes gradually the [param velocity] of the controlled node (using accelleration and curve) 
##to make it move to the given position
func accellerateToPos(pos: Vector3):
	accellerateInDirection(controlledNode.global_position.direction_to(pos))

##Changes gradually the [param velocity] of the controlled node (using friction and curve) 
##to make it decellerate and stop at the given position
func decellerateToPos(pos: Vector3):
	decellerateInDirection(controlledNode.global_position.direction_to(pos))

##Changes gradually the [param velocity] of the controlled node (using accelleration and curve) 
##to make it move in the given direction
var lastDir := Vector3(0,0,0)
func accellerateInDirection(dir: Vector3):
	dir = dir.normalized()
	
	# Interpolate between 0 and maxSpeed based on the accelleration curve. Multiply the value with the dir. Modify the curveOffset by the accell/friction to move along the curve
	if dir != Vector3(0,0,0):
		controlledNode.velocity = interpolate(0.0,maxSpeed,accellerationCurve.sample(curveOffset)) * dir
		curveOffset += accellCurveStep
		lastDir = dir
	else:
		decellerateInDirection(lastDir)
	
	curveOffset = clampf(curveOffset,0,1)

##Changes gradually the [param velocity] of the controlled node (using friction and curve) 
##to make it slow down while moving in the given direction
func decellerateInDirection(dir: Vector3):
	controlledNode.velocity = interpolate(0.0,maxSpeed,accellerationCurve.sample(curveOffset)) * dir
	curveOffset -= frictionCurveStep
	
	curveOffset = clampf(curveOffset,0,1)

##Changes gradually the [param velocity] of the controlled node (using accelleration and curve) 
##to make it move in the given direction
var lastDirHoriz := Vector2(0,0)
func accellerateInDirectionHorizontally(dir: Vector2):
	dir = dir.normalized()
	
	# Interpolate between 0 and maxSpeed based on the accelleration curve. Multiply the value with the dir. Modify the curveOffset by the accell/friction to move along the curve
	if dir != Vector2(0,0):
		controlledNode.velocity.x = interpolate(0.0,maxSpeed,accellerationCurve.sample(curveOffset)) * dir.x
		controlledNode.velocity.z = interpolate(0.0,maxSpeed,accellerationCurve.sample(curveOffset)) * dir.y
		curveOffset += accellCurveStep
		lastDirHoriz = dir
	else:
		decellerateInDirectionHorizontally(lastDirHoriz)
	
	curveOffset = clampf(curveOffset,0,1)

##Changes gradually the [param velocity] of the controlled node (using friction and curve) 
##to make it slow down while moving in the given direction
func decellerateInDirectionHorizontally(dir: Vector2):
	controlledNode.velocity.x = interpolate(0.0,maxSpeed,accellerationCurve.sample(curveOffset)) * dir.x
	controlledNode.velocity.z = interpolate(0.0,maxSpeed,accellerationCurve.sample(curveOffset)) * dir.y
	curveOffset -= frictionCurveStep
	
	curveOffset = clampf(curveOffset,0,1)

##Interpolation formula that returns a fraction (based on t) of the distance between points a and b
func interpolate(a,b,t):
	return a + (b - a) * t # Initial pos (a) + a fraction (t) of the distance between initial and final pos (a,b)
#endregion

#region Move functions (no accelleration)
##Changes the [param velocity] of the controlled node
##to make it move to the given position
func moveToPos(pos: Vector3):
	moveInDirection(controlledNode.global_position.direction_to(pos))

##Changes the [param velocity] of the controlled node
##to make it move in the given direction
func moveInDirection(dir: Vector3):
	dir = dir.normalized()
	controlledNode.velocity = maxSpeed * dir
#endregion

#region Apply velocity functions
##Applies the given [param velocity]
func applyVelocity(vel: Vector3):
	controlledNode.velocity = vel

##Applies the given Y [param velocity]
func applyVelocityY(vel: float):
	controlledNode.velocity.y = vel

##Applies the given X [param velocity]
func applyVelocityX(vel: float):
	controlledNode.velocity.x = vel

##Applies the given Z [param velocity]
func applyVelocityZ(vel: float):
	controlledNode.velocity.z = vel
#endregion

#region Setters
func setMaxSpeed(amount: float):
	maxSpeed = amount

func setAccelleration(amount: float):
	accelleration = amount

func setFriction(amount: float):
	friction = amount
#endregion
