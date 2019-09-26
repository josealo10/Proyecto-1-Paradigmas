/*
var W3CWebSocket = require('websocket').w3cwebsocket;
 
var client = new W3CWebSocket('ws://localhost:4000/echo','echo');

client.onerror = function() {
    console.log('Connection Error');
};
 
client.onopen = function() {
    console.log('WebSocket Client Connected');
 
    function sendNumber() {
        if (client.readyState === client.OPEN) {
            var number = Math.round(Math.random() * 0xFFFFFF);
            client.send(number.toString());
            setTimeout(sendNumber, 1000);
        }
    }
};
 
client.onclose = function() {
    console.log('echo-protocol Client Closed');
};
 
client.onmessage = function(e) {
    if (typeof e.data === 'string') {
        console.log("Received: '" + e.data + "'");
    }
};
*/
document.onkeyup = function(event) {
    if (event.keyCode == 13) {
        sendMessage()
    }
}

function sendMessage() {
    let message = document.getElementById("write_msg")
    let msg_history = document.getElementById("msg_history")
    let last_message = document.getElementById("last_message")

    if (message.value != "") {
        let outgoin_msg = document.createElement("div")
        let sent_msg = document.createElement("div")
        let p = document.createElement("p")
        let span = document.createElement("span")
        let time = new Date()

        outgoin_msg.className += "outgoin_msg"
        sent_msg.className += "sent_msg"
        span.className = "time_date"

        span.textContent = time.getHours() + ":" + time.getMinutes()
        p.textContent = message.value

        sent_msg.appendChild(p)
        sent_msg.appendChild(span)
        outgoin_msg.appendChild(sent_msg)
        msg_history.appendChild(outgoin_msg)

        //last_message.innerText = message.value

        reciveMessage()
    }
}

function reciveMessage() {
    let userMessage = document.getElementById("write_msg").value
    let messageObject = {
        msg: userMessage
    }

    $.ajax({
        type: "POST",
        contentType: "application/json",
        data: JSON.stringify(messageObject),
        url: "/send"

    }).done((bot_resp) => {
        let message = bot_resp
        let msg_history = document.getElementById("msg_history")
        let last_message = document.getElementById("last_message")

        let incoming_msg = document.createElement("div")
        let incoming_msg_img = document.createElement("div")
        let received_msg = document.createElement("div")
        let received_withd_msg = document.createElement("div")
        let p = document.createElement("p")
        let span = document.createElement("span")
        let time = new Date()

        incoming_msg.className += "incoming_msg"
        incoming_msg_img.className += "incoming_msg_img"
        received_msg.className += "received_msg"
        received_withd_msg.className += "received_withd_msg"
        span.className += "time_date"

        span.textContent = time.getHours() + ":" + time.getMinutes()
        p.textContent = message

        received_withd_msg.appendChild(p)
        received_withd_msg.appendChild(span)
        received_msg.appendChild(received_withd_msg)
        incoming_msg.appendChild(incoming_msg_img)
        incoming_msg.appendChild(received_msg)
        msg_history.appendChild(incoming_msg)
        msg_history.scrollTo(0,msg_history.scrollHeight)
        //last_message.textContent = message

        document.getElementById("write_msg").value = ""
    })



}