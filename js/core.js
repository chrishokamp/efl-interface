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


    //TODO: 
    // READING EXERCISES
    // 1) make an object representing the data that the user can interact with
    // TEST EXERCISES 
    // 1) make sure that the buffer word list realigns when a word comes back
    // WORKAROUND FOR ABSOLUTELY POSITIONED OBJECTS INSIDE parent divs:
    //  IDEA: do it with classes
    //  CLASS maintains state on the objects
    //  pageUpdate() is called every time anything changes
    //      - get the current dimensions of
    // force page to have a static size -- resize should do nothing and user should be forced to scroll if they want the window to be smaller  
    
    // END TODO

    //TESTS
    //loading();
    //$(document).on('click', 'div#loading', function(e) {
    //    stopLoading();    
    //});
    //END TESTS
    
});
