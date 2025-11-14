class_name Velocity2dModule extends Node2D
@export var controlledNode: CharacterBody2D

@export_group("Variables")
@export var maxSpeed: float = 50
@export var accelleration: float = 5
@export var friction: float = 5

@onready var accellCurveStep: float = accelleration / maxSpeed
@onready var frictionCurveStep: float = friction / maxSpeed

@export_group("Accelleration curve")
@export var accellerationCurve: Curve

var curveOffset: float = 0

func _ready() -> void:
	if controlledNode == null or accellerationCurve == null:
		get_tree().quit(1)
	
	accellCurveStep = clampf(accellCurveStep,0,1)
	frictionCurveStep = clampf(frictionCurveStep,0,1)

func _physics_process(_delta: float) -> void:
	controlledNode.move_and_slide()

#region Accelleration functions
func accellerateToPos(pos: Vector2):
	accellerateInDirection(controlledNode.global_position.direction_to(pos))

func decellerateToPos(pos: Vector2):
	decellerateInDirection(controlledNode.global_position.direction_to(pos))

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

func decellerateInDirection(dir: Vector2):
	controlledNode.velocity = interpolate(0.0,maxSpeed,accellerationCurve.sample(curveOffset)) * dir
	curveOffset -= frictionCurveStep
	
	curveOffset = clampf(curveOffset,0,1)

func interpolate(a,b,t):
	return a + (b - a) * t # Initial pos (a) + a fraction (t) of the distance between initial and final pos (a,b)
#endregion

#region Move functions (no accelleration)
func moveToPos(pos: Vector2):
	moveInDirection(controlledNode.global_position.direction_to(pos))

func moveInDirection(dir: Vector2):
	dir = dir.normalized()
	controlledNode.velocity = maxSpeed * dir
#endregion

#region Apply velocity functions
func applyVelocity(vel: Vector2):
	controlledNode.velocity = vel

func applyVerticalVelocity(vel: float):
	controlledNode.velocity.y = vel

func applyHorizontalVelocity(vel: float):
	controlledNode.velocity.x = vel
#endregion
