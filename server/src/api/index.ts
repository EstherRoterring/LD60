import { Router } from "express";
import { exists, readdir, readFile, writeFile } from "fs/promises";

const DATA_DIRECTORY = "/home/moritz/LD60/data";

const router = Router();

function isTrackIdValid(value: string) {
	return /^[a-zA-Z_0-9\-]+$/.test(value);
}

const VOICES_COUNT_MAX = 100;
const NOTES_COUNT_MAX = 1000;
const NOTE_REGEX = /^\d+:[a-g]#?\d$/;
function isSerializedTrack(value: string) {
	try {
		const data = JSON.parse(value);
		if (typeof data !== "object") return false;

		if (!("voices" in data)) return false;
		if (typeof data.voices !== "object") return false;
		if (Object.keys(data.voices).length > VOICES_COUNT_MAX) return false;
		for (const voice in data.voices) {
			if (typeof data.voices[voice] !== "object") return false;
			if (!Array.isArray(data.voices[voice])) return false;
			if (data.voices[voice].length > NOTES_COUNT_MAX) return false;
			for (const note of data.voices[voice]) {
				if (typeof note !== "string") return false;
				if (!NOTE_REGEX.test(note)) return false;
			}
		}

		if (!("length" in data)) return false;
		if (typeof data.length !== "number") return false;

		if (!("version" in data)) return false;
		if (typeof data.version !== "number") return false;

		return true;
	} catch {
		return false;
	}
}

router.get("/tracks", async (request, response) => {
	const { limit = "100", offset = "0" } = request.query;
	if (
		typeof limit !== "string" ||
		!/^\d+$/.test(limit) ||
		!Number.isSafeInteger(Number(limit)) ||
		Number(limit) < 1 ||
		typeof offset !== "string" ||
		!/^\d+$/.test(offset) ||
		!Number.isSafeInteger(Number(offset))
	) {
		response.status(400).send("Invalid pagination parameters.");
		return;
	}

	try {
		const entries = await readdir(DATA_DIRECTORY, { withFileTypes: true });
		const ids = entries
			.filter((entry) => entry.isFile() && entry.name.endsWith(".json"))
			.map((entry) => entry.name.slice(0, -5))
			.filter(isTrackIdValid)
			.sort();

		response.json({
			ids: ids.slice(Number(offset), Number(offset) + Number(limit)),
			total: ids.length,
		});
	} catch {
		response.status(500).send("Internal server error");
	}
});

router.get("/tracks/:track_id", (request, response) => {
	const trackId = request.params.track_id;
	if (!isTrackIdValid(trackId)) {
		response.status(400).send(`Invalid track id ${trackId}.`);
		return;
	}

	readFile(`${DATA_DIRECTORY}/${trackId}.json`, "utf-8").then(
		(fileContents) => {
			response.json(JSON.parse(fileContents));
		},
		(error) => {
			if ((error as NodeJS.ErrnoException).code === "ENOENT") {
				response.status(404).send(`Track ${trackId} not found.`);
				return;
			}

			response.status(500).send("Internal server error");
		},
	);
});

router.post("/tracks/:track_id", async (request, response) => {
	const trackId = request.params.track_id;
	if (!isTrackIdValid(trackId)) {
		response.status(400).send(`Invalid track id ${trackId}.`);
		return;
	}

	const body = request.body;
	if (typeof body !== "string" || !isSerializedTrack(body)) {
		response.status(400).send("Invalid track data.");
		return;
	}

	if (await exists(`${DATA_DIRECTORY}/${trackId}.json`)) {
		response.status(400).send(`Track with id ${trackId} already exists.`);
		return;
	}

	writeFile(`${DATA_DIRECTORY}/${trackId}.json`, body, "utf-8").then(
		() => {
			response.status(202).send("Track created.");
		},
		() => {
			response.status(500).send("Internal server error");
		},
	);
});

export default router;
