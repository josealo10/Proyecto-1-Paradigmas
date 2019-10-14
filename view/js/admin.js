
function seleccionarRuta(){
    let archivoInput = document.getElementById('archivo').files[0]    
    alert(archivoInput.name)

    $.ajax({ 
        type: "POST", 
        contentType: "multipart/form-data", 
        data: archivoInput,
        url: "http://localhost:9001/admin" 
    })
}

function respuesta(res){
    aler(res)
}