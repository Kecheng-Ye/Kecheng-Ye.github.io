import express from "express";
import path from "path";
import * as util from "./util.js";
import { api } from "./backend/server.js";

const app = express();
const port = process.env.PORT || 5555;
app.use(express.json());
app.use(express.static("public"));
app.use(
  express.static(path.join(process.cwd(), "/frontend/stock-app/dist/stock-app"))
);

// intialize backend API
const backend = new api(app, "/api");

// initialize frontend page
app.all("/*", (req, res) => {
  res.sendFile(
    path.join(process.cwd(), "/frontend/stock-app/dist/stock-app/index.html")
  );
});

app.listen(port);
console.log(`Start App at ${port}`);
