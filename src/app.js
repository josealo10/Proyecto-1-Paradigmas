const express = require("express"),
    path = require("path"),
    bodyParser = require("body-parser"),
    RiveScript = require("rivescript")

const app = express()

// importing routes

// settings
app.set("port", process.env.PORT || 3000)
app.set("views", path.join(__dirname, "views"))
app.set("view engine", "ejs")

// middlewaress
app.use(bodyParser.urlencoded({ extended: false }))
app.use(bodyParser.json())

// routes
app.use('/',require('./routes/index'))

// rivescript
const bot = new RiveScript()
const RIVE_FILE = "./src/rivescript/chat_room.rive"
const username = "local-user"

bot.loadFile([RIVE_FILE])
    .then(loading_done)
    .catch(loading_error)

function loading_done() {
    console.log("Bot has finished loading!")
}

function loading_error(error, filename, lineno) {
    console.log("Error when loading files: " + error)
}

function reply(msg, cb) {
    if (!bot || msg.err) {
        cb(msg.msg)
        return
    }

    bot.sortReplies();
    bot.reply(username, msg.msg).then((resp) => {
        console.log("The bot says: " + resp)
        cb(resp)
    });
}

// static files
app.use(express.static(path.join(__dirname)))

// starting the server
app.listen(app.get("port"), () => {
    console.log(`Server on port ${app.get("port")}`)
});