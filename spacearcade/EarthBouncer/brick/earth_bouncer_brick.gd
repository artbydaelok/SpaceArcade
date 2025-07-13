extends StaticBody2D

@export_range(0.0, 1.0) var dropchance : float

var powerups_node : Node2D
@export var powerup : PackedScene 

@export var asteroid_sprites : Array[Texture2D]
@export var asteroid_normals : Array[Texture2D]

@onready var brick_image: Sprite2D = $"Brick Image"

const EXPLOSION = preload("res://vfx/explosion.tscn")

var ball : Node2D

func _ready() -> void:
	ball = get_tree().get_first_node_in_group("planet_ball")
	powerups_node = get_tree().get_first_node_in_group("powerups_node")
	var rand_sprite_index = randi() % asteroid_sprites.size() # Chooses a random sprite index
	brick_image.texture = asteroid_sprites[rand_sprite_index] # Using the random index, we set the diffuse texture.
	var _n = asteroid_normals[rand_sprite_index] # And create a variable for the normal texture.
	brick_image.material.set_shader_parameter("normal_map", _n) # Sets the normal texture on the shader to the variable we created.
	brick_image.material.set_shader_parameter("viewport_size", get_viewport_rect().size) # Passes the viewport size.

func _physics_process(delta: float) -> void:
	if ball != null:
		brick_image.material.set_shader_parameter("light_pos", ball.global_position) # Moves the position of the light with the ball.

func break_brick():
	var random_chance = randf_range(0.0, 1.0)

	if random_chance < dropchance:
		var powerup_instance = powerup.instantiate()
		powerup_instance.global_position = global_position
		powerups_node.add_child.call_deferred(powerup_instance)
	
	var explosion = EXPLOSION.instantiate()
	get_parent().add_child(explosion)
	explosion.global_position = global_position
	explosion.explode()
	
	queue_free.call_deferred()
