
let flag = false

function seleccionarRuta(){
    let file = document.getElementById('archivo').files[0]    
    let lable = document.getElementById("lable")
    lable.textContent = file.name
    flag = true
}

function respuesta(res) {
    alert(res)
}

function enviar(){
    if(flag){
        let file = document.getElementById('archivo').files[0]
        var formData = new FormData()
        formData.append("rive",file)


        $.ajax({
            url: "http://localhost:9001/admin",
            type: "post",
            dataType: "html",
            data: formData,
            cache: false,
            contentType: false,
            processData: false,
            success: function(data, status, xhttp)
                {  
                    if ( data )
                    {
                        alert(JSON.stringify(data))
                    }
                }
        })
    }
    
}