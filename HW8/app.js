import express from "express";
import path from "path";
import * as util from "./util.js";
import { api } from "./backend/server.js";
import {fileURLToPath} from 'url';

const __filename = fileURLToPath(import.meta.url);
const app = express();
const port = process.env.PORT || 5555;
app.use(express.json())
app.use(express.static('public'))
app.use(express.static(path.join(process.cwd(), "/frontend/stock-app/dist/stock-app")));


app.get("/", (req, res) => {
  res.sendFile(path.join(process.cwd(), "/frontend/stock-app/dist/stock-app/index.html"));
});

const backend = new api(app, "/api");
app.listen(port);
console.log(`Start App at ${port}`);
