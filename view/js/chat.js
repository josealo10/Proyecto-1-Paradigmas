

// web ruta del web socket en el puerto 3000
let websocket_path = 'ws://localhost:3000/echo'


// carga del websocket al iniciar pagina
function init_websocket(){
    websocket = new WebSocket(websocket_path);

// accion cuando llegue un mensaje
    websocket.onmessage = function(evt) { onMessage(evt)};

}

// envia mensajes si doy enter
document.onkeyup = function(event) {
    if (event.keyCode == 13) {
        sendMessage()
    }
}

// inicio del socket al cargar pagina
window.addEventListener("load", init_websocket, false);

// envio de mensaje
function sendMessage() {
    let message = document.getElementById("write_msg")
    var mens=message.value
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
        p.textContent = mens

        sent_msg.appendChild(p)
        sent_msg.appendChild(span)
        outgoin_msg.appendChild(sent_msg)
        msg_history.appendChild(outgoin_msg)
        console.log(mens)
        
        message.value=""
        this.envio(mens)
        
       
    }
}

// revisa el estado del websocket
function envio(mens){
    if(websocket.readystate != WebSocket.CLOSED){
        this.send(mens);
    }
}

function send(message){
    websocket.send(message);
}

// cuando llega mensaje
function onMessage(evt){
    console.log(evt.data);
    let message = evt.data
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
    p.textContent = evt.data

    received_withd_msg.appendChild(p)
    received_withd_msg.appendChild(span)
    received_msg.appendChild(received_withd_msg)
    incoming_msg.appendChild(incoming_msg_img)
    incoming_msg.appendChild(received_msg)
    msg_history.appendChild(incoming_msg)
    msg_history.scrollTo(0,msg_history.scrollHeight)
    document.getElementById("write_msg").value = ""
}

//Actualiza la hora
(function(){
    var actualizarHora = function(){
        let fecha = new Date()
        let hora = fecha.getHours()
        let minutos = fecha.getMinutes()
        let segundos = fecha.getSeconds()
        
        let pHora = document.getElementById("hora")
        let pMinutos = document.getElementById("minutos")
        let pSegundos = document.getElementById("segundos")

        pHora.textContent = hora
        pMinutos.textContent = minutos
        pSegundos.textContent = segundos
    }

    actualizarHora
    var intervalo = setInterval(actualizarHora,1000)
}())



