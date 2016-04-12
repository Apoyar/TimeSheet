$(document).ready(function(){
    var projects;
    var activities;
    var placeholder1='<option value="" disabled selected>Select the project...</option>';
    var placeholder2='<option value="" disabled selected>Select the activity...</option>';
    function disable_p_and_a(){
        $('#project').prop('disabled', true);
        $('#activity').prop('disabled', true);
        $('#project').html(placeholder1);
        $('#activity').html(placeholder2);
    }
    $('#client').change(function(){
        disable_p_and_a();
        var client_id=$('#client').val(); 
        $.post("ajax/get_projects", {task: {'client_id': client_id}})
            .done(function(data){
                projects=data;
                console.log(projects);
                html=placeholder1;
                for(i=0; i<projects.length; i++){
                    html+='<option value="'+projects[i].project_id+'">'+projects[i].name+'</option>';
                }
                $('#project').html(html);
                $('#project').prop('disabled', false);
        });
    });
    $('#project').change(function(){
        $('#activity').prop('disabled', true);
        $('#activity').html(placeholder2);
        var project_id=$('#project').val(); 
        $.post("ajax/get_activities", {task: {'project_id': project_id}})
            .done(function(data){
                activities=data
                console.log(activities);
                html=placeholder2;
                for(i=0; i<activities.length; i++){
                    html+='<option value="'+activities[i].activity_id+'">'+activities[i].name+'</option>';
                }
                $('#activity').html(html);
                $('#activity').prop('disabled', false);
        });
    });
});



