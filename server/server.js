const http = require('http');
const RiveScript = require('./js/rivescript')

//////////////////////////////////////////////////////////////////////
const hostname = '127.0.0.1';
const port = 6000;
///////////////////////////////////////////////////////////////////////
const server = http.createServer((req, res) => {
  let data = []
  req.on('data', chunk => {
    data.push(chunk)
  })
  req.on('end', () => {
    let msg = parse_data(data) // JSON.parse(data)
    console.log(msg.msg)
    reply(msg, (bot_resp) => {
        res.statusCode = 200;
        res.setHeader('Content-Type', 'text/plain');
        res.end(bot_resp);
    })
  })
   
});

function parse_data(data){
    try{
        return JSON.parse(data)
    } catch (e){
        console.log(`Invalid Message: ${e.message}`)
        return {msg:`"*** ${e.message} ***"`, err:true}
    }
}
///////////////////////////////// BOT ////////////////////////////////
const bot = new RiveScript();
const RIVE_FILE = "./rivescripts/chat_room.rive";
const username = "local-user";
bot.loadFile([RIVE_FILE])
            .then(loading_done)
            .catch(loading_error);
function loading_done() {
  console.log("Bot has finished loading!");
}
function loading_error(error, filename, lineno) {
  console.log("Error when loading files: " + error);
}

function reply(msg, cb){
    if(!bot || msg.err ){
        cb(msg.msg)
        return
    }
    bot.sortReplies();
    bot.reply(username, msg.msg).then((resp) => {
         console.log("The bot says: " + resp);
         cb(resp)
    });
}



///////////////////////////////////////////////////////////////////////
server.listen(port, hostname, () => {
  console.log(`Server running at http://${hostname}:${port}/`);
});