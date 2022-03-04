const express = require("express");
const path = require("path");

const app = express();
const port = process.env.PORT || 5555;

app.get('/', (req, res) => {
  res.sendFile(path.join(__dirname, "/frontend/index.html"));
});



app.listen(port);
console.log(`Start App at ${port}`);
