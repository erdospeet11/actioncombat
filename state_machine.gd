class_name StateMachine
extends Node

"""
1. Scene Structure
Since your Enemy is likely a CharacterBody3D (physics object) and the StateMachine extends Node, you cannot attach the state machine script directly to the Enemy root.

Add a Node as a child of your Enemy.
Name it EnemyBrain or StateMachine.
Attach a new script to this child node (e.g., enemy_ai.gd).
2. Script Setup (enemy_ai.gd)
In your new script, you need to extend the StateMachine class instead of Node.

Extend: extends StateMachine
Reference the Enemy: Create an @export or @onready variable to hold a reference to the parent Enemy node (the CharacterBody3D). You will need this to move the enemy or play animations.
Define States: Create an enum called States with values like Idle, Patrol, Chase, Attack.
Initialize: In _ready(), call set_state_enum(States) and start the machine with set_state(States.Idle).
3. Implement State Logic
Define the behavior for each state using the naming convention _state_name_method.

Idle: Define _idle_enter() to play an idle animation. Define _idle_update(delta) to check if the player is close; if so, call set_state(States.Chase).
Chase: Define _chase_fixed_update(delta) to move the parent Enemy towards the player using move_and_slide().
Attack: Define _attack_enter() to deal damage and play an animation.
"""


@export var update: bool = true ## Wether or not to update the StateMachine

var state: int ## Integer to the state_id in the state_enum
var state_id: String ## String ID to the integer state in the state_enum
var state_enum: Dictionary ## Keys and Values for Integer and String based IDS

var input_ref: Callable ## Reduces Method lookup upon InputEvent
var update_ref: Callable ## Reduces Method lookup every frame
var fixed_update_ref: Callable ## Reduces Method lookup every physics frame

func _input(event: InputEvent):
	if update and input_ref.is_valid():
		input_ref.call(event)

func _physics_process(delta: float) -> void:
	if update and fixed_update_ref.is_valid():
		fixed_update_ref.call(delta)

func _process(delta: float) -> void:
	# Update Current State
	if update and update_ref.is_valid():
		update_ref.call(delta)

## Stores the enum for ID lookup
func set_state_enum(state_enum: Dictionary):
	self.state_enum = state_enum

## Sets the current state, calling proper Exit/Enter states
func set_state(new_state):
	if state_enum == null:
		return
	
	# Exit State
	_call_check("_" + state_id + "_exit")
	
	# Load new_state
	state = new_state
	state_id = state_enum.keys()[state].to_lower()
	_call_check("_" + state_id + "_enter")
	
	# Method Retrieving
	update_ref = Callable(self, "_" + state_id + "_update")
	fixed_update_ref = Callable(self, "_" + state_id + "_fixed_update")
	input_ref = Callable(self, "_" + state_id + "_input")

# Does null checking
func _call_check(method: String):
	# Null Check
	if not has_method(method) or state_id == null:
		return false
	call(method)
