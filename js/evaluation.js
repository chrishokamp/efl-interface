/**
 * User: chris
 * Date: 3/29/13
 * Time: 4:44 PM
 **/
$(document).ready(function() {

    //This is a global object which stores data about the user's interactions with the interface
    //global control accross views
    var currentSeconds = new Date().getTime()/1000;
    //alert('current time is: ' + currentSeconds);
    //TODO: intialize currentTime properly
    var userData = {
    id: "",
    nativeLang: "",
    clickedWords: [],
    feedbackReading: 0,
    startTime: currentSeconds,
    totalTime: 0,
    answers: {},
setTime: function() {
    time = (new Date().getTime()/1000) - this.startTime;
    this.totalTime = time;
    },
addWord: function(word) {
    this.clickedWords.push(word);
    },
addAnswer: function(q, a) {
    //qIndex = 'q' + q;
    qIndex = q;
    //alert(qIndex);
    chosenAnswer = a;
    this.answers[qIndex.toString()] =  chosenAnswer;
    //this.answers.push({qIndex.toString(): chosenAnswer});
},
setRandomReading: function(min, max) {
    this.feedbackReading =  Math.floor(Math.random() * (max - min +1)) + min;
    },
test: function () {
    var wordString = this.clickedWords.toString();
    //alert("clicked words: " + wordString );
    //alert("time: " + this.getTime());
    //alert("id: " + this.id + " lang: " + this.nativeLang);
    alert("control reading: " + this.controlReading);
    }
};
//TESTING
//userData.addWord('test');
//userData.setRandomReading(1,2);
//userData.test();
//alert(userData.clickedWords.toString());

function displayEntry () {
    //var entry = $.post('pages/entry-elements.html');
    //alert(entry);
    //$('#view').html("<h1>Test View</h1>")
    //NOTE: WebStorm auto-load doesn't work with AJAX stuff (origin: null not allowed)
    $('#view').load('pages/entry-elements.html');
    $('.entry').show();
    }
function hideEntry () {
    $('.entry').slideUp("slow");
    }

//add function to take the reading as argument, and display feedback dynamically
//we only need to select the class for markup once per session
//displays the elements for reading
function displayReading (reading) {
    //$(readingId).slideDown("slow");
    $('.reading').slideDown('slow');
    $('#hd_infoColumn').css("display", "none");
    $('#' + reading).slideDown('slow');
    }

function hideReading (reading) {
    $('.reading').hide();
    //TODO: FIX THIS HACK AND DO A PROPER CLEAR
    $('#hd_infoColumn').find('*').text("");
    $('#' + reading).hide();
    }
//TEST
//displayReading();
//hideReading();
function displayQuiz (quiz) {
    //$('.quiz').show();
    $('#' + quiz).show();
    //$('#mainContent').css({"top": "0px"});
//$("html, body").animate({ scrollTop: 0 }, "fast");
$("html, body").scrollTop(0);
}

function hideQuiz (quiz) {
    //$('.quiz').hide();
    $('#' + quiz).hide();

    }

function displayThanks () {
    $("#mainContent").html('<h1>Thanks and have a great day!</h1>');
    }

//reset everything
hideEntry();
hideReading('reading-1');
hideQuiz('quiz-1');
hideReading('reading-2');
hideQuiz('quiz-2');



//User enters the interface, collect:
//Id
//nativeLanguage
displayEntry();

//the begin button on the entry page controls transition to the next state
//functions for entry mode
//NOTE: $(document).on("click" ... is necessary because this element is dynamically added to the DOM??
$(document).on("click", "input#continue_button", function(e) {
    e.preventDefault();
    var userId = $('#userid').val();
    var lang = $('#nativeLang').val();
    //Set the feedback/control readings for this user
    userData.setRandomReading(1, 2);
    var feedbackClass = userData.feedbackReading;
    var readingId = 'reading-' + feedbackClass;
    //TEST
    alert('reading feedback id = ' + readingId);
    //Now add .feedback to the red words in the selected class
    $('#' + readingId).find(".head").addClass('feedback');
    //Alert the user that THIS READING has/doesn't have feedback available
    $('#view').empty(); //remove entry from DOM (are any functions still bound?)

    //TODO: working here
    $('#view').append("<p>This page does/doesn't have feedback available</p>");

    //set these values on the user object
    //TODO: implement form checking!!
    userData.id = userId;
    userData.nativeLang = lang;
    //userData.test();

    //change the view
    hideEntry();

    //ENTRY POINT
    displayReading('reading-1');
    });
//Now we're in reading mode

//reading-1
$('#quiz-button-1').on('click', function(e) {
    e.preventDefault();
    //change the view
    hideReading('reading-1');
    displayQuiz('quiz-1');
    });
//Now we're in quiz mode
$('#next_reading').on('click', function(e) {
    e.preventDefault();
    //log the answers
    getAnswers('1');

    //change the view
    hideQuiz('quiz-1');
    displayReading('reading-2');
    });

//reading-2
$('#quiz-button-2').on('click', function(e) {
    e.preventDefault();
    //change the view
    hideReading('reading-2');
    displayQuiz('quiz-2');
    });

//Call the server and save
//also: display on the screen
function storeUserData (userObj) {
    //store the total time
    userObj.setTime();
    var userJSON = JSON.stringify(userObj);
    //alert ("user data" + userJSON);
    $.ajax({
    async: true,
    cache: false,
    type: 'post',
    data: { userData: userJSON},
url: 'cgi/userData.pl',
success: function(data) {
    console.log('Fired when the request is successful');
    //$('#test').load(data);
    //$('#test').html(data);
    //$('#mainContent').html(data);
    //$("html").removeClass();
    //alert(data);
    $('#mainContent').append('<div id="user-data">' + data + '</div>');
    //show the json on the page for now

    },
complete: function() {
    console.log('Fired when the request is complete');
    },
error: function(){
    alert('there was a problem with the request');
    }
});

}

//Now we're back in quiz mode
$('#submit_button').on('click', function(e) {
    e.preventDefault();
    //change the view
    //hideQuiz();
    getAnswers('2');
    storeUserData(userData);
    displayThanks();
    });

//TODO: this is called onSubmit
function getAnswers (quizNo) {
    //for every question
    var questions = $('.question');
    var answers = {};
for ( var i=0; i < questions.length; i++) {
    //alert(questions[i].toString());

    var buttons = $(questions[i]).find(':radio');

    for ( var j=0; j < buttons.length; j++)	{
    var value = buttons[j].value;
    var checked = $(buttons[j]).is(':checked');
    if (checked) {
    //alert("question: "+ i);
    //alert("val: " + value);
    //TODO: fix to fill the object per-quiz
    var key = 'quiz ' + quizNo + ' question ' + (i + 1);
    userData.addAnswer(key,value);
    //alert(buttons[j].toString());
    }
}

}
}

//This function handles user data storage - the call is only done once at the end of the session
//functions for reading mode
//10.12.12 - CHANGE span.head --> span.feedback

$(document).on("click", "span.feedback", function(e) {
	        e.preventDefault();
		//use (this).... to get the content for this word
			var txt = $(this).text();
			var synonyms = $(this).attr("data-synonyms");
			var example = $(this).attr("data-example");
			//store the word that was clicked
			userData.addWord(txt); //TESTED

			//alert(example +' was clicked');
			//$('#hd_synList').slideUp("slow");
			$('#hd_synList').hide();
			$('#hd_synList').html("");
                        $('#hd_example').hide();
			$('#hd_example').html("");

			$('#hd_synList').append('<div id="headword"><h3>Synonyms for ' + txt + ': </h3></div>');
			$('#hd_infoColumn').css("display", "inline");
        		$('#hd_infoColumn').animate({opacity: .80});
			displaySynonyms(synonyms);
			displayExample(example);
  });
  $(document).on("click", "div#hd_infoColumn", function(e) {
		e.preventDefault();
		$('#hd_infoColumn').animate({opacity: .00});

  });

  function displaySynonyms (synList) {
  	var syns = synList.split(",");
for (var i=0; i < syns.length; i++) {
        //alert(syns[i]);
        $('#hd_synList').append('<div class="synonym">' + syns[i] + '</div>');
        }
    //$('#hd_synList').slideDown('fast');
	$('#hd_synList').show();
	$('#hd_synList').animate({opacity: 1.0}, 2000);

  }

  function displayExample (exampleSen) {
 	$('#hd_example').append('<h4>Example Sentence:</h4>' + exampleSen);
    //$('#hd_example').slideDown("fast");
    $('#hd_example').show();
    $('#hd_example').animate({opacity: 1.0}, 2000);

    }

    //End functions for reading mode

    //Functions for quiz mode
    $('#submit_button').on('click', function(e) {
        e.preventDefault();
        var targetUrl = $('#upaddr').val(); //this is the value of the user-entered URL
        });


    });
