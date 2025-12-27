class_name FirstPersonControllerModule extends Node3D


@onready var cameraHolder: Node3D = %CameraHolder
@onready var camera: Camera3D = %Camera

##The node on which the module's operations are applied
@export var controlledNode: CharacterBody3D
##The [Velocity3dModule] used to change the velocity of the controlled module
@export var velocity3dModule: Velocity3dModule

@export_group("Inputs")
##The name of the key used to walk forward
@export var walkForwardKey: String
##The name of the key used to walk backwards
@export var walkBackwardsKey: String
##The name of the key used to walk left
@export var walkLeftKey: String
##The name of the key used to walk right
@export var walkRightKey: String
##The name of the key used to jump
@export var jumpKey: String

@export_group("Gravity settings")
##If false, gravity [b]won't[/b] be applied
@export var enableGravity := true
##The increment in downward [param velocity], measured in m/s
@export var downwardForce := 10.0
##The maximum downward [param velocity], measured in m/s
@export var maxDownwardVelocity := 50.0
##If false, jumping [b]won't[/b] be available
@export var enableJump := true
##The [param velocity] applied when jumping, measured in m/s
@export var jumpStregth := 100.0
##The maximum amount of jumps that can be done before touching the ground
@export var maxJumps := 1
var jumpsDone := 0

@export_group("Visual settings")
@export var FOV := 75.0
var mouseSensitivity := 0.005

@onready var fKey := walkForwardKey
@onready var bKey := walkBackwardsKey
@onready var lKey := walkLeftKey
@onready var rKey := walkRightKey
@onready var jKey := jumpKey

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(_delta: float) -> void:
	applyGravity()
	
	handleHorizontalMovement()
	handleJump()
	
	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

##Handles the camera movement
func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		controlledNode.rotate_y(-event.relative.x * mouseSensitivity)
		cameraHolder.rotate_x(-event.relative.y * mouseSensitivity)
		
		cameraHolder.rotation.x = clampf(cameraHolder.rotation.x,-PI/2, PI/2)

##Handles the horizontal movement
func handleHorizontalMovement():
	var inputVector := Input.get_vector(lKey,rKey,fKey,bKey)
	var dir := (controlledNode.transform.basis * Vector3(inputVector.x,0,inputVector.y)).normalized()
	velocity3dModule.accellerateInDirectionHorizontally(Vector2(dir.x,dir.z))

##If the controlled node hasn't reched the maximum amount of jumps, sets the [param velocity] to the jump strength.
func handleJump():
	if !enableJump:
		return
	
	if controlledNode.is_on_floor():
		jumpsDone = 0
	
	if Input.is_action_just_pressed(jKey):
		if jumpsDone < maxJumps:
			velocity3dModule.applyVelocityY(jumpStregth)
			jumpsDone += 1

##Increments downward [param velocity] while the controlled node isn't touching the floor and hasn't reached the maximum 
##downward [param velocity]. When the controlled node touches the ground, downward [param velocity] is reset.
func applyGravity():
	if !enableGravity:
		return
	
	if !controlledNode.is_on_floor() and controlledNode.velocity.y > -maxDownwardVelocity:
		if controlledNode.velocity.y - downwardForce > -maxDownwardVelocity:
			velocity3dModule.applyVelocityY(controlledNode.velocity.y - downwardForce)
		else:
			velocity3dModule.applyVelocityY(-maxDownwardVelocity)
	
	if controlledNode.is_on_floor():
		velocity3dModule.applyVelocityY(0)
