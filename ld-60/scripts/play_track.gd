
extends Node

signal track_ready
signal step_changed(step: int)

const STEP_DURATION := 0.3

@export var sound: VASynthConfiguration
@export var track: Track = null

var synth: AudioSynthPlayer
var play_time: float = 0.0
var last_played_step: int = -1
var is_playing: bool = false


func _ready() -> void:
	track = TrackLibrary.activeTrack
	print("Track geladen: ", track.instruments.keys())
	track_ready.emit()
	
	synth = AudioSynthPlayer.new()
	synth.configuration = sound
	add_child(synth)


func start_playback() -> void:
	if track == null or track.length <= 0:
		return

	play_time = 0.0
	last_played_step = -1
	is_playing = true


func _process(delta: float) -> void:
	if track == null or not is_playing or track.length <= 0:
		return

	play_time += delta

	var step := int(play_time / STEP_DURATION)

	if step >= track.length:
		is_playing = false
		return

	if step == last_played_step:
		return

	last_played_step = step
	step_changed.emit(step)

	var notes := track.get_instrument_pitch_pairs_at_ime(step)

	for note in notes:
		play_note(note["pitch"], STEP_DURATION)


func play_note(pitch: int, duration: float) -> void:
	var context = synth.get_context()

	context.note_on(pitch, 6)
	await get_tree().create_timer(duration).timeout
	context.note_off(context.absolute_time)
