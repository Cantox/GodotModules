class_name HealthModule extends Node
##A modules that handles a [param health] attribute
##
##Allows to increment and decrement [param health]. Emits the signal [signal HealthModule.healthIs0] 
##when [param health] gets to 0

##The maximum amount of health
@export var MaxHealth: float = 100
##If true, when the health reaches 0.0 the object implementing 
##the module gets deleted
@export var DeleteObjectOnDeath := false

##Current health value
@onready var health := MaxHealth

##Signal emitted when health gets to 0
signal healthIs0

func _ready() -> void:
	healthIs0.connect(deathSignalEmitted)

#region Edit health value
##Decreases health by the given amount (ensuring it doesn't get below 0). 
##If health gets to 0 emits "heathIs0" signal
func decreaseHealth(amount: float):
	if health - amount < 0:
		health = 0
		healthIs0.emit()
	else:
		health -= amount

##Increases health by the given amount (ensuring it doesn't get above the max)
func increaseHealth(amount: float):
	if health + amount > MaxHealth:
		health = MaxHealth
	else:
		health += amount

##Sets health to 0 and emits "healthIs0" signal
func kill():
	health = 0
	healthIs0.emit()
#endregion

##Function connected to the "healthIs0" signal
func deathSignalEmitted():
	if DeleteObjectOnDeath:
		get_tree().queue_free()

func setMaxHealth(amount: float):
	MaxHealth = amount
