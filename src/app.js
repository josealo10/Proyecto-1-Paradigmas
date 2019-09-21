const express = require("express"),
    path = require("path"),
    bodyParser = require("body-parser");

const app = express();

// importing routes

// settings
app.set("port", process.env.PORT || 3000);
app.set("views", path.join(__dirname, "views"));
app.set("view engine", "ejs");

// middlewaress
app.use(bodyParser.urlencoded({ extended: false }));
app.use(bodyParser.json());

// routes

// static files
app.use(express.static(path.join(__dirname)));

// starting the server
app.listen(app.get("port"), () => {
    console.log(`Server on port ${app.get("port")}`);
});