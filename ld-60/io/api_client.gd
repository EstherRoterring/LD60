extends Node

signal track_data_result(data)
signal track_id_result(data)

const BASE_URL = "http://home.liegmanns.de/ld60/api"

func fetch_track_data(track_id: String):
	var http = HTTPRequest.new()
	add_child(http)

	http.request_completed.connect(
		func(result, status, _headers, body):
			if result == HTTPRequest.RESULT_SUCCESS and status == 200:
				track_data_result.emit(body.get_string_from_utf8())
			else:
				push_error("Failed to fetch track")

			http.queue_free()
	)

	if http.request(BASE_URL + "/tracks/" + track_id) != OK:
		push_error("Could not start HTTP request")
		http.queue_free()

func save_track_data(track: String):
	var http = HTTPRequest.new()
	add_child(http)

	http.request_completed.connect(
		func(result, status, _headers, body):
			if result == HTTPRequest.RESULT_SUCCESS and status == 202:
				track_id_result.emit(JSON.parse_string(body.get_string_from_utf8()).id)
			else:
				push_error("Failed to fetch track")

			http.queue_free()
	)

	if http.request(BASE_URL + "/tracks", PackedStringArray(["Content-Type: text/plain"]), HTTPClient.METHOD_POST, track) != OK:
		push_error("Could not start HTTP request")
		http.queue_free()
