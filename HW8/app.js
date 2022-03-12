import express from "express";
import path from "path";
import * as util from "./util.js";
import { api } from "./backend/server.js";
import {fileURLToPath} from 'url';

const app = express();
app.use(express.json())
const port = process.env.PORT || 5555;

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);
app.get("/", (req, res) => {
  res.sendFile(path.join(__dirname, "/frontend/index.html"));
});

const backend = new api(app, "/api");
app.listen(port);
console.log(`Start App at ${port}`);
