$(document).ready(function () {
    function loading () {
        var spinner = '<div id="loading"><img id="spinner" src="img/ajax-loader.gif" alt="Loading..."></div>';
        $('body').append(spinner);
    }      
    function stopLoading () {
        removeElement($('#loading'));
    }
    function removeElement ($element) {
        $element.remove();
    }
    function loadWordData () {
        loading();
        $.getJSON('data/words.json', function(data) {
            var dict = data;
            $('#loading').animate({opacity: 0.0}, 1500, function() {
                stopLoading();
            });
            //var ex = dict["gingerly"]["example"];
            //alert ("Gingerly ex: " + ex);
        });
    }

    //TESTS
    //loading();
    //$(document).on('click', 'div#loading', function(e) {
    //    stopLoading();    
    //});
    //END TESTS
    
});
