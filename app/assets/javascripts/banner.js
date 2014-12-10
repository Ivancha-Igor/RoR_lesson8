$(document).ready(function(){
    open();
    $( "#close" ).click(function( event ) {
        close();
    });
});
function open(){
    event.preventDefault();
    $("#banner").show();
}
function close(){
    event.preventDefault();
    $("#banner").hide();
}