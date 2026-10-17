extends Node

signal data_received(data)

const BASE_URL = "http://localhost:3000/api"

func fetch_track_data(track_id: String):
	var http = HTTPRequest.new()
	add_child(http)

	http.request_completed.connect(
		func(result, status, headers, body):
			if result == HTTPRequest.RESULT_SUCCESS and status == 200:
				data_received.emit(body.get_string_from_utf8())
			else:
				push_error("Failed to fetch track")

			http.queue_free()
	)

	if http.request(BASE_URL + "/tracks/" + track_id) != OK:
		push_error("Could not start HTTP request")
		http.queue_free()
