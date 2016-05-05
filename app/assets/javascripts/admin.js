$(document).ready(function(){
    var location=window.location.hash;
    if (location){
        var parsed=/#(\D*)\d*/.exec(location)[1];
    
        if (parsed=='project'){
            $(location+' > .well > .collapse').attr('class', 'in');
        }
        else if (parsed=='activity'){
            $(location).parent().parent().attr('class', 'in');
            $(location+' > .well > .collapse').attr('class', 'in');
        }
        else if (parsed=='ass'){
            $(location).parent().parent().parent().parent().parent().parent().attr('class', 'in');
            $(location).parent().parent().attr('class', 'in');
        }
    
        $(document).scrollTop( $(location).offset().top ); 
    }
    
    
    
    $('#inputEmail').first().keyup(function(){
        if ($(this).val()==''){
            $('#user_new > div > div > div.modal-body > div.row > div.col-xs-4 > label > input[type="checkbox"]').first().attr('disabled', true);
            $('#user_new > div > div > div.modal-body > div.row > div.col-xs-4 > label').first().attr('class', 'checkbox disabled');
        }
        else{
            $('#user_new > div > div > div.modal-body > div.row > div.col-xs-4 > label > input[type="checkbox"]').first().attr('disabled', false);
            $('#user_new > div > div > div.modal-body > div.row > div.col-xs-4 > label').first().attr('class', 'checkbox');
        }
    });
});
