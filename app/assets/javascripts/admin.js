$(document).ready(function(){
    var location=window.location.hash;
    var parsed=/#(\D*)\d*/.exec(location)[1];
    
    console.log(parsed);
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
});
