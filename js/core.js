//THIS FILE IS JUST FUNCTIONS

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
/* TODO: add this via a backbone or ember template!?!
function loadQuestionData () {
    loading();
    //TODO: format -- two objects, questions and answers
    $.getJSON('data/questions.json', function(data) {
        var dict = data;
        $('#loading').animate({opacity: 0.0}, 1500, function() {
            stopLoading();
        });
        //var ex = dict["gingerly"]["example"];
        //alert ("Gingerly ex: " + ex);
                    
        
    });
}
*/

//TODO: this function breaks the async nature of ajax calls!!!
function checkAnswers (quizData) {
//we want the correspondence between blankID and answerID
    $.getJSON('data/answers.json', function(data) {
        var userAnswers = {};
        //var answerDict = data;
        //var ex = answerDict["1"]["A"];
        //alert ("answer to question 1: " + ex);
        answerMap = data;
        console.log("checking answers");
        $(".inBlank").each( function() {
            var $e = $(this);
            var answerId = $e.attr('id');
            var chosenBlank = $e.attr('current');
            var qNumber = chosenBlank.charAt(chosenBlank.length - 1);
            console.log("Answer for question " + qNumber + " is: " + answerId);
            if(answerMap[qNumber]['A'] === answerId) {
                //TODO: add to userAnswers object
                userAnswers[chosenBlank] = ["correct", answerMap[qNumber]['A'], answerId];
                console.log("you are correct");
                var eX = $('#' + chosenBlank).parent();
                $(eX).css("background", "#000"); 
                $(eX).animate({backgroundColor: "#228B22"}, 1500);
            } else {
                userAnswers[chosenBlank] = ["wrong", answerMap[qNumber]['A'], answerId];
                console.log("chosenBlank: " + chosenBlank);
                console.log("userAnswers.chosenBlank: " + userAnswers[chosenBlank]);
                console.log("you are not correct");
                var eY = $('#' + chosenBlank).parent();
                $(eY).css("backgroundColor", "#000"); 
                $(eY).animate({backgroundColor: "#DC143C"}, 1500);
            }
        });
        //use the callback
        quizData(userAnswers);
    });
    //Async problems with this way! -- deferred object?
    //return userAnswers;
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
//loadWordData(); 
//END TESTS
