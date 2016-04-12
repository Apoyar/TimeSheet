$(document).ready(function(){
    $('#client').change(function(){
        var client_id=$('#client').val(); 
        $.post("ajax/get_projects", {task: {'client_id': client_id}})
            .done(function(data){
                console.log(data)
        });
        
        
        
    });
});



