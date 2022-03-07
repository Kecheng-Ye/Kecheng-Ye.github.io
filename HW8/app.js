import express from "express";
import path from "path";
import * as util from "./util.js";
import { api } from "./backend/server.js";

const app = express();
const port = process.env.PORT || 5555;

app.get('/', (req, res) => {
  res.sendFile(path.join(__dirname, "/frontend/index.html"));
});

const backend = new api(app, "/api");
app.listen(port);
console.log(`Start App at ${port}`);

