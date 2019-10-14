
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
                },
            error: function(){alert("Algo salio mal")}
            
            
        })
        
    }
    
}


/*
function evaluar(){

//  grab the content of the form field and place it into a variable
    var textToWrite = document.getElementById("itextarea").value;
//  create a new Blob (html5 magic) that conatins the data from your form feild
    var textFileAsBlob = new Blob([textToWrite], {type:'text/plain'});
// Specify the name of the file to be saved
    var fileNameToSaveAs = "myNewFile.txt";
    
// Optionally allow the user to choose a file name by providing 
// an imput field in the HTML and using the collected data here
// var fileNameToSaveAs = txtFileName.text;
 
// create a link for our script to 'click'
    var downloadLink = document.createElement("a");
//  supply the name of the file (from the var above).
// you could create the name here but using a var
// allows more flexability later.
    downloadLink.download = fileNameToSaveAs;
// provide text for the link. This will be hidden so you
// can actually use anything you want.
    downloadLink.innerHTML = "My Hidden Link";
    
// allow our code to work in webkit & Gecko based browsers
// without the need for a if / else block.
    window.URL = window.URL || window.webkitURL;
          
// Create the link Object.
    downloadLink.href = window.URL.createObjectURL(textFileAsBlob);
// when link is clicked call a function to remove it from
// the DOM in case user wants to save a second file.
    downloadLink.onclick = destroyClickedElement;
// make sure the link is hidden.
    downloadLink.style.display = "none";
// add the link to the DOM
    document.body.appendChild(downloadLink);
    
// click the new link
    downloadLink.click();
}

*/