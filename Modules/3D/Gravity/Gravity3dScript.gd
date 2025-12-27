class_name Gravity3dModule extends Node3D
##A moudule that handles downward gravity for a [CharacterBody3D] node.
##
##Gravity modifiers are supported. A jump system is also implemented and supports 
##modifiers.

##The node on which the module's operations are applied
@export var controlledNode: CharacterBody3D
##[b]OPTIONAL[/b][br][br]
##The module used to apply the [method CharacterBody3D.move_and_slide] method.[br][br]
##Assign a [Velocity3dModule] to this parameter ONLY if you already have one in the scene tree
@export var velocity3dModule: Velocity3dModule

@export_group("Gravity variables")
##If false, gravity [b]won't[/b] be applied
@export var enableGravity := true
##The increment in downward [param velocity], measured in m/s
@export var downwardForce := 10.0
##The maximum downward [param velocity], measured in m/s
@export var maxDownwardVelocity := 50.0

@export_group("Jump variables")
##The [param velocity] applied when jumping, measured in m/s
@export var jumpStregth := 30.0
##The maximum amount of jumps that can be done before touching the ground
@export var maxJumps := 1

var jumpsDone := 0

func _ready() -> void:
	if controlledNode == null:
		get_tree().quit(1)

func _physics_process(_delta: float) -> void:
	if velocity3dModule == null:
		controlledNode.move_and_slide()

##Increments downward [param velocity] while the controlled node isn't touching the floor and hasn't reached the maximum 
##downward [param velocity]. When the controlled node touches the ground, downward [param velocity] is reset.
func applyGravity(gravityIncrementer: Array[float] = [], gravityMultiplier: Array[float] = [], customDownwardForce := downwardForce):
	if !enableGravity:
		return
	
	# Apply modifiers
	for i in gravityIncrementer:
		customDownwardForce += i
	for m in gravityMultiplier:
		customDownwardForce += m
	
	if !controlledNode.is_on_floor() and controlledNode.velocity.y > -maxDownwardVelocity: # if not on floor and not at max velocity
		if controlledNode.velocity.y - customDownwardForce > -maxDownwardVelocity: # if increment doesn't get over max velocity
			controlledNode.velocity.y -= customDownwardForce
		else:
			controlledNode.velocity.y = -maxDownwardVelocity
	
	if controlledNode.is_on_floor():
		controlledNode.velocity.y = 0

##If the controlled node hasn't reched the maximum amount of jumps, sets the [param velocity] to the jump strength.
func jump(jumpStrengthIncrementer: Array[float] = [], jumpStrengthMultiplier: Array[float] = [], customJumpStrength := jumpStregth):
	# Apply modifiers
	for i in jumpStrengthIncrementer:
		customJumpStrength += i
	for m in jumpStrengthMultiplier:
		customJumpStrength += m
	
	if controlledNode.is_on_floor():
		jumpsDone = 0
	
	if jumpsDone < maxJumps:
		controlledNode.velocity.y = customJumpStrength
		jumpsDone += 1

#region Setters
func setEnableGravity(value: bool):
	enableGravity = value

func setDownwardForce(amount: float):
	downwardForce = amount

func setMaxDownwardVelocity(amount: float):
	maxDownwardVelocity = amount

func setJumpStregth(amount: float):
	jumpStregth = amount

func setMaxJumps(amount: int):
	maxJumps = amount

func setJumpsDone(amount: int):
	jumpsDone = amount
#endregion
