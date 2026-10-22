
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
		var newpitch = note["pitch"] - 24 + 69 # make the lowest monster a 440 "C"
		play_note(newpitch, STEP_DURATION)


func play_note(pitch: int, duration: float) -> void:
	print(pitch," ",  duration)
	# MIDI: 69 = A4 = 440 Hz
	var frequency := 440.0 * pow(2.0, (pitch - 69) / 12.0)

	var sample_rate := 44100
	var sample_count := int(duration * sample_rate)

	var data := PackedByteArray()
	data.resize(sample_count * 2)

	for i in sample_count:
		var t := float(i) / sample_rate
		# sine
		var sample := sin(TAU * frequency * t)
		# fade in/out
		var envelope := 1.0
		var fade_time := 0.01 # 10 ms

		if t < fade_time:
			envelope = t / fade_time
		elif t > duration - fade_time:
			envelope = max(0.0, (duration - t) / fade_time)
		sample *= envelope * 0.25
		# [-1, 1] -> signed 16-bit
		data.encode_s16(i * 2, int(sample * 32767.0))

	var stream := AudioStreamWAV.new()
	stream.format = AudioStreamWAV.FORMAT_16_BITS
	stream.mix_rate = sample_rate
	stream.stereo = false
	stream.data = data

	var player := AudioStreamPlayer.new()
	add_child(player)

	player.stream = stream
	player.finished.connect(player.queue_free)
	player.play()