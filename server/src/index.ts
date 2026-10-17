import express, { type Express } from "express";

const app: Express = express();

app.use(express.json());
app.use(express.urlencoded({ extended: true }));

app.get("/", (request, response) => {
  response.send("Hello World!");
});

const server = app.listen(3000, () => {
  console.info("Server listening on http://localhost:3000/");
});

function shutdown(signal: string) {
  console.log(`Received ${signal}. Shutting down...`);

  server.close((error) => {
    if (error) {
      console.error("Error closing server:", error);
      process.exit(1);
    }

    console.log("Server closed successfully");
    process.exit(0);
  });
}

process.on("SIGINT", () => shutdown("SIGINT"));
process.on("SIGTERM", () => shutdown("SIGTERM"));
