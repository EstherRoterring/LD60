
extends Resource
class_name Track

const NOTES = ["c", "c#", "d", "d#", "e", "f", "f#", "g", "g#", "a", "a#", "b"]

var data
var instruments: Dictionary[String, Dictionary] = {}
var length: int = 0

func get_notes_for_instrument(value: String, time: int) -> Array:
	return instruments.get(value, {}).get(time, [])

#returns instrument (monster name) and pitch
func get_instrument_pitch_pairs_at_ime(time: int) -> Array :
	var result: Array = []
	for i in instruments:
		if instruments[i].has(time):
			for pitch in instruments[i][time]:
				result.append({
					"monster": i,
					"pitch": pitch
				})
	return result

func add_note(instrument: String, time: int, pitch: int):
	instruments.get_or_add(instrument, {}).get_or_add(time, []).append(pitch)
	if (time >= length):
		length = time + 1

func delete_note(instrument: String, time: int, pitch: int):
	if not instruments.has(instrument): return
	if not instruments[instrument].has(time): return
	if not instruments[instrument][time].has(pitch): return

	instruments[instrument][time].remove_at(instruments[instrument][time].find(pitch))

static func deserialize(p_data: String) -> Track:
	var track = Track.new()
	track.data = JSON.parse_string(p_data)

	track.length = track.data.get("length", 0)

	for instrument in track.data["voices"].keys():
		var note_map: Dictionary[int, Array] = {}
		for note in track.data["voices"][instrument]:
			var parsed = Track.deserialize_note(note)
			var time = parsed[0]
			var pitch = parsed[1]
			note_map.get_or_add(time, []).append(pitch)
			if time >= track.length:
				track.length = time + 1
		track.instruments.set(instrument, note_map)

	return track

static func deserialize_note(value: String) -> Array[int]:
	var results = RegEx.create_from_string("^(?<time>\\d+):(?<note>[a-gA-G]\\#?)(?<octave>\\d+)").search(value)
	var time = int(results.get_string("time"))
	var note = results.get_string("note")
	var octave = results.get_string("octave")
	var note_offset = NOTES.find(note.to_lower())
	var octave_offset = int(octave) * 12 + 12
	return [time, octave_offset + note_offset]

static func serialize(track: Track) -> String:
	var output = {
		"version": 1,
		"voices": {},
		"length": track.length
	}

	for instrument in track.instruments:
		for time in track.instruments[instrument]:
			for pitch in track.instruments[instrument][time]:
				output.voices.get_or_add(instrument, []).append(serialize_note(pitch, time))

	return JSON.stringify(output)


static func serialize_note(pitch: int, time: int) -> String:
	var note: String = NOTES[pitch % 12]
	@warning_ignore("integer_division")
	return str(time) + ":" + note + str(pitch / 12 - 1)
