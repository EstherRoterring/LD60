import { Router, type Request, type Response } from "express";
import { readFile } from "fs/promises";

const DATA_DIRECTORY = "/home/moritz/LD60/data";

const router = Router();

function isTrackIdValid(value: string) {
	return /^[a-zA-Z_0-9\-]+$/.test(value);
}

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

router.get("/health", (_req: Request, res: Response) => {
	res.status(200).json({
		status: "ok",
		timestamp: new Date().toISOString(),
	});
});

export default router;
