class_name DamageModule extends Node
##A module that implements damage taking and dealing
##
##Allows to take damage and deal damage with a crit chance

##The [healthModule] on which the health is changed
@export var healthModule: HealthModule

#region Variables
@export_group("Damage")
##The base amount of damage dealt
@export var baseDamage: float = 50
@export_group("Critical attacks")
##If false, there won't be a chance to deal critical attacks
@export var useCriticalAttacks: bool = true
##The critical effect:[br]
##[br]
##[b]Multiply[/b]: multiplies the base damage by the set amount[br]
##[br]
##[b]Increment[/b]: increments the base damage by the sat amount
@export_enum("Multiply","Increment") var critEffect := 0
##If  [param critEffect]  is set to Multiply, in case of a critical attack 
##the base damage is multiplied by this amount
@export var critMultiplyValue: float = 1.5
##If  [param critEffect]  is set to Increment, in case of a critical attack 
##the base damage will be incremented by this amount
@export var critIncrementValue: float = 20
##Chance (%) to deal a crit attack
@export_range(0.0, 100.0, 0.1) var critChance: float = 20

##Variables that save the starting values
##Can be used to reset values after modifications (by powerups for example)
@onready var startingDamage := baseDamage
@onready var startingCritMult := critMultiplyValue
@onready var startingCritInc := critIncrementValue
@onready var startingCritChance := critChance
#endregion

func _ready() -> void:
	if healthModule == null:
		get_tree().quit(1)

##Decreases the [param health] parameter of the associated health module 
##by the given amount
func takeDamage(amount: float):
	healthModule.decreaseHealth(amount)

##Deals damage (calculated by the [method DamageModule.calculateDamage] method) to a health module 
##(decreasing it's [param health] parameter)
func dealDamageToHealthModule(otherHealthModule: HealthModule, damageIncreasers: Array[float] = [], damageMultiplyers: Array[float] = [], customBaseDamage: float = baseDamage):
	otherHealthModule.decreaseHealth(calculateDamage(damageIncreasers, damageMultiplyers, customBaseDamage))

##Deals damage (calculated by the [method DamageModule.calculateDamage] method) to a damage module 
##using the [method DamageModule.takeDamage] method
func dealDamageToDamageModule(otherDamageModule: DamageModule, damageIncreasers: Array[float] = [], damageMultiplyers: Array[float] = [], customBaseDamage: float = baseDamage):
	otherDamageModule.takeDamage(calculateDamage(damageIncreasers, damageMultiplyers, customBaseDamage))

##Calculates damage dealt based on the base amount of damage, modified by the modifiers (if passed)
##and the critical function (if enabled)
func calculateDamage(damageIncreasers: Array[float] = [], damageMultiplyers: Array[float] = [], customBaseDamage: float = baseDamage) -> float:
	# Add the increasers
	for i in damageIncreasers:
		customBaseDamage += i
	# Add the multiplyers
	for m in damageMultiplyers:
		customBaseDamage *= m
	
	# Try critical attack
	if useCriticalAttacks and doCrit():
		customBaseDamage = critDamage(customBaseDamage)
	
	return customBaseDamage

##Calculates the critical damage
func critDamage(damage: float) -> float:
	if critEffect == 0:
		return damage * critMultiplyValue
	elif critEffect == 1:
		return damage + critIncrementValue
	
	return damage

##Calculates crit chance
func doCrit() -> bool:
	return randf() > (critChance/100)

#region Setters
func setBaseDamage(amount: float):
	baseDamage = amount

func setCritMultiplyValue(amount: float):
	critMultiplyValue = amount

func setCritIncrementValue(amount: float):
	critIncrementValue = amount

func setCritChance(amount: float):
	critChance = amount
#endregion
