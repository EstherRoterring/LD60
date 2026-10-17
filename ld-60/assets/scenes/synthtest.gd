extends Node2D


@export var sound:SynthConfiguration
var synth
func initialize_synth() -> void:
	synth = AudioSynthPlayer.new()
	synth.configuration = sound
	
func _on_button_pressed() -> void:
	