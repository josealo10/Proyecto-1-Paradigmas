function login(){
    let username = document.getElementById("username").value
    let password = document.getElementById("password").value

    let messageObject = { 
        username: username,
        password: password
    } 
    
    $.ajax({ 
        type: "POST", 
        contentType: "application/json", 
        data: JSON.stringify(messageObject), 
        url: "http://localhost:9001/login" ,
        success: function(data, status, xhttp)
        {     
            if ( data )
            {
                routes(data.user)
            }
        }
 
    })
    
}

function respuesta(res){
    alert("funciono")
    alert(res.reponse)
}

function routes(user){
    if(user == "admin"){
        location.href='http://localhost:9001/admin/admin.html'
    }
    if(user == "chat"){
        location.href='http://localhost:9001/chat/chat.html'
    }

}