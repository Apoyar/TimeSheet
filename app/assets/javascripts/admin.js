$(document).ready(function(){
    var location=window.location.hash;
    console.log(location);
    $(location+' > .well > .collapse').attr('class', 'in');
});
