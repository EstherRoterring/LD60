class_name Track

var data
var instruments: Dictionary[String, Dictionary]
var length: int = 0

func _init(p_data: String):
	data = JSON.parse_string(p_data)
	
	length = data.get("length", 0)

	instruments = {}
	for instrument in data["voices"].keys():
		var note_map: Dictionary[int, Array] = {}
		for note in data["voices"][instrument]:
			var parsed = Track.parse_note(note)
			var time = parsed[0]
			var pitch = parsed[1]
			note_map.get_or_add(time, []).append(pitch)
			if time >= length:
				length = time + 1
		instruments.set(instrument, note_map)

func get_notes_for_instrument(value: String, time: int) -> Array:
	return instruments.get(value, {}).get(time, [])

static func parse_note(value: String):
	var results = RegEx.create_from_string("^(?<time>\\d+):(?<note>[a-gA-G]\\#?)(?<octave>\\d+)").search(value)
	var time = int(results.get_string("time"))
	var note = results.get_string("note")
	var octave = results.get_string("octave")
	var note_offset = {
		"c": 0,
		"c#": 1,
		"d": 2,
		"d#": 3,
		"e": 4,
		"f": 5,
		"f#": 6,
		"g": 7,
		"g#": 8,
		"a": 9,
		"a#": 10,
		"b": 11,
	}[note.to_lower()]
	var octave_offset = int(octave) * 12 + 12
	return [time, octave_offset + note_offset]
