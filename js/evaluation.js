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
        eflLevel: "",
        clickedWords: [],
        feedbackReading: 0,
        firstReading: 0,
        startTime: currentSeconds,
        currentReading: 0,         
        finishedReadings: {
                reading1 : "no",
                reading2 : "no"
        },
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
        setFinishedReading: function(reading) {
            this.finishedReadings.reading = "yes";   
        },
        setRandomReading: function(min, max) {
            this.feedbackReading =  Math.floor(Math.random() * (max - min +1)) + min;
            this.firstReading =  Math.floor(Math.random() * (max - min +1)) + min;
        },
        remainingReadings: function() {
            //this.remaining = [];
            $.each(this.finishedReadings, function(index, value) {
                //alert("finishedReadings -> " + index + ":" + value);
                var remaining = [];
                if (value === "no") {
                    remaining.push(index);
                }
            });

       },
        test: function () {
            var wordString = this.clickedWords.toString();
            //alert("clicked words: " + wordString );
            //alert("time: " + this.getTime());
            //alert("id: " + this.id + " lang: " + this.nativeLang);
            //alert("control reading: " + this.controlReading);
            $.each(this.finishedReadings, function(index, value) {
                //alert("finishedReadings -> " + index + ":" + value);
            });
        }
    };
//TESTING
//userData.addWord('test');
//userData.setRandomReading(1,2);
//userData.test();
//alert(userData.clickedWords.toString());

//DISPLAY FUNCTIONS
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
    //var feedbackTest = userData.feedbackReading;
    //alert ("feedback" + feedbackTest);
    clearView();
}

//add function to take the reading as argument, and display feedback dynamically
//we only need to select the class for markup once per session
//displays the elements for reading
function displayReading (readingId, showFeedback) {
    var readingFileName = 'pages/reading' + readingId + '.html'; 
    userData.currentReading = readingId;
    //alert ("current reading was set to " + userData.currentReading);
    //alert("inside display reading");
			//$('#hd_synList').slideUp("slow");
    $('#reading-elements').load(readingFileName, function() {
        //alert("show feedback is " + showFeedback + "!");
        if (showFeedback == 1) {
            $("#reading-elements").prepend('<h3 style="color:blue;">You can click the <span style="color:red;">red</span> words to receive help!</h3>');
           //alert("show feedback is 1");
           var testClass = '#reading-' + readingId;
           //alert("Test class" + testClass);
           $('#reading-' + readingId).find(".head").addClass('feedback');
           $('.feedback').hover(function() {
               $('.feedback').addClass('hover-pointer');
               },               
               function() {
                $('.feedback').removeClass('hover-pointer');
               }
           );
           alert("In this reading, CLICK on the red words to get more information about them!");

        } else {
            $("#reading-elements").prepend('<h3 style="color:blue;">Important words are highlighted in <span style="color:red;">red</span></h3>');
            alert("In this reading, you cannot click on the red words");
	}
	
    });
    //$('.reading').slideDown('slow');
    $('.reading').show();
    $('#mainContent').css("top", "110px"); 
    //var topTag = $("#topTag"); 
    $('html, body').animate({scrollTop: 20}, 'slow'); 
    $('#hd_infoColumn').css("display", "none");
    //$('.entry').show();
    //$(readingId).slideDown("slow");


    //TODO: Alert the user that THIS READING has/doesn't have feedback available
}

function hideReading (reading) {
    $('.reading').hide();
    $('#hd_infoColumn').css("display", "none");
    //TODO: FIX THIS HACK AND DO A PROPER CLEAR
    $('#hd_infoColumn').find('*').text("");
    $('#' + reading).hide();
}
//TEST
//displayReading();
//hideReading();
function displayQuiz (quiz) {
    //$('.quiz').show();
    //alert("inside display quiz");
    $('#' + quiz).css("display", "block");
    $('#' + quiz).css("visibility", "visible");
    //$('#' + quiz).show();
    //$('#mainContent').css({"top": "0px"});
    //$("html, body").animate({ scrollTop: 0 }, "fast");
    $("html, body").scrollTop(0);
}

function hideQuiz (quiz) {
    //$('.quiz').hide();
    $('#' + quiz).hide();

    }

function displayThanks () {
    $("#view").html('<h1>Thanks and have a great day!</h1>');
}
//LOAD BOTH QUIZZES
function loadQuiz () {
    $.get("pages/quiz.html", function(data) {
        $('#view').append(data);
    }, 'html');
}

function clearView () {
    $('#view').empty(); //remove entry from DOM (are any functions still bound?)
}
//END DISPLAY FUNCTIONS

//User enters the interface:
displayEntry();

//the bin button on the entry page controls transition to the next state
//functions for entry mode
//NOTE: $(document).on("click" ... is necessary because this element is dynamically added to the DOM??
$(document).on("click", "input#continue_button", function(e) {
    e.preventDefault();
    var userId = $('#userid').val();
    var lang = $('#nativeLang').val();
    var eflLevel = $('#eflLevel').val();
    //set these values on the user object
    //TODO: implement form checking!!
    userData.id = userId;
    userData.nativeLang = lang;
    userData.eflLevel = eflLevel;
    //userData.test();

    //Set the feedback/control readings for this user
    //TODO: set first reading, if reading = feedback reading, call function with 1
    userData.setRandomReading(1, 2);
    var feedbackClass = userData.feedbackReading;
    var firstReading = userData.firstReading;

    //change the view
    hideEntry();

    //ENTRY POINT
    //Set first reading
    var readingId = 'reading-' + firstReading;
    if (firstReading === feedbackClass) {
        //call with one
        displayReading(firstReading, 1);

    } else {
        //call with zero
        displayReading(firstReading, 0);
    }
    //TODO: randomly choose which reading to display first AND which reading to add feedback to

    //Load the quizzes, but keep them hidden
    loadQuiz();
});
//Now we're in reading mode

//reading-1
$(document).on("click", "#quiz-button-1", function(e) {
    e.preventDefault();
    //USER FINISHED READING 1
    userData.finishedReadings.reading1 = 'yes';
    //change the view
    hideReading();
    //TODO: WORKING  get the current reading and display its quiz
    displayQuiz('quiz-1');
});
//reading-2
$(document).on('click', '#quiz-button-2', function(e) {
    e.preventDefault();
    //USER FINISHED READING 2
    userData.finishedReadings.reading2 = 'yes';
    //change the view
    hideReading('reading-2');
    displayQuiz('quiz-2');
    });
//Now we're in quiz mode
//WORKING: TODO: check remaining readings. if it's empty, get user data and display thanks. if it's not, choose another reading and proceed
$(document).on('click', '.next', function(e) {
    e.preventDefault();
    //alert("Next was clicked");
    //get current reading
    var cr = userData.currentReading;
    //log the answers
    getAnswers(cr);
    //change the view
    hideQuiz('quiz-' + cr);

    var remaining = userData.finishedReadings;
    //alert ("REMAINING: " + remaining);
    //TODO: HACK -- THIS ISN'T CORRECT
    var nextReading = "none";
    $.each(remaining, function(index, value) {
        //alert("finishedReadings -> " + index + ":" + value);
            if (value === "no") {
                nextReading = index.charAt(index.length-1);
            }
     });
    
    if (nextReading != "none") {
        //get next reading
        //TEST
        //alert("Next Reading is: " + nextReading);
        //Set reading
        var feedbackClass = userData.feedbackReading;
        //var readingId = 'reading-' + nextReading;
        if (nextReading == feedbackClass) {
            //call with one
            displayReading(nextReading, 1);
        } else {
            //call with zero
            displayReading(nextReading, 0);
        }
    } else {
        //finish
        //STORE ANSWERS!!
        storeUserData(userData);
        displayThanks();
        //display thanks!
    }
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
    console.log('User data was logged');
    //$('#mainContent').append('<div id="user-data">' + data + '</div>');
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
//TODO: DELETE THIS COMPLETELY
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
			$('#hd_infoColumn').show();
            
		//use (this).... to get the content for this word
			var txt = $(this).text();
			var synonyms = $(this).attr("data-synonyms");
			var example = $(this).attr("data-example");
			//store the word that was clicked
			userData.addWord(txt); //TESTED
			$('#hd_synList').hide();
			$('#hd_synList').html("");
            $('#hd_example').hide();
			$('#hd_example').html("");
			$('#hd_synList').append('<div id="headword"><h3>Synonyms for ' + txt + ': </h3></div>');
			$('#hd_infoColumn').css("display", "inline");
            $('#hd_infoColumn').animate({opacity: 0.80});
			displaySynonyms(synonyms);
			displayExample(example);
  });
  $(document).on("click", "div#hd_infoColumn", function(e) {
		e.preventDefault();
		$('#hd_infoColumn').animate({opacity: 0.00});

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
    //TODO: fix for dynamic loading of readings
    $('#submit_button').on('click', function(e) {
        e.preventDefault();
        var targetUrl = $('#upaddr').val(); //this is the value of the user-entered URL
        });


    });
