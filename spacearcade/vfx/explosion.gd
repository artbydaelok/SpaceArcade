extends Node2D

@onready var explosion_sound: AudioStreamPlayer = $ExplosionSound

func explode():
	for child in get_children():
		if child.is_class("CPUParticles2D"):
			child.emitting = true
			explosion_sound.pitch_scale = randf_range(0.96, 1.2)
			explosion_sound.play()


func _on_self_destroy_timer_timeout() -> void:
	queue_free()
