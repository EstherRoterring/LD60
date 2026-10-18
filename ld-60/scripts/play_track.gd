extends Node

const STEP_DURATION = 0.3

@export var sound: VASynthConfiguration

var track: Track = null

var synth: AudioSynthPlayer

var play_time: float = 0
var last_played_step: int = -1


func _ready() -> void:
	API.fetch_track_data("sample01")
	API.track_data_result.connect(parse_track)
	
	synth = AudioSynthPlayer.new()
	synth.configuration = sound
	add_child(synth)

func _process(delta: float) -> void:
	if track == null:
		return

	play_time += delta

	var step = int(play_time / STEP_DURATION) % track.length
	if step == last_played_step:
		return

	last_played_step = step
	for pitch in track.get_notes_for_instrument("piano", step):
		play_note(pitch, STEP_DURATION)


func play_note(pitch: int, duration: float):
	var context = synth.get_context()
	
	context.note_on(pitch, 6)
	await  get_tree().create_timer(duration).timeout
	context.note_off(context.absolute_time)

func parse_track(data: String):
	track = Track.deserialize(data)
