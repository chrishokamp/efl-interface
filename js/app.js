console.log("Inside app.js");
//WORKING: instantiate the user prototype -- TODO: keep in a separate file

//this portion collects entry data about the user -- to be persisted on the server
//ENTRY
$("#entryData")
    .modal({
        keyboard: false,
        backdrop: 'static'
    })
    .css("top", "120px");

$("#entryData").keypress(function(e) { //on enter press, trigger click on toReading button
    if (e.keyCode == 13) {
        console.log("you pressed enter in the entry data area" );
        $("#toReading").trigger('click');
   }
});

//INSTRUCTIONS
$("#instructions").keypress(function(e) { //on enter press, trigger click on toReading button
    if (e.keyCode == 13) {
        console.log("you pressed enter in the instructions area" );
        $("#continue").trigger('click');
   }
});

var currentUser;
$(document).on('click', '#toReading', function() {
    var loc = $("#locationArea").val(); 
    var id  = $("#idArea").val(); 
    //Check value, else add alert
    if (notEmpty(loc) === true && notEmpty(id) === true) {
        currentUser = new User(id, loc);
        $("#entryData").modal('hide');
        $("#instructions").modal().css("top", "120px");
    } else {
        var a = '<div class="alert alert-error"><button type="button" class="close" data-dismiss="alert">&times;</button>Please enter a valid location and/or id.</div>';
        $("#entryData .modal-body").prepend(a);
        //$("#infoColumn").animate({opacity:0});
    }
});

$(document).on('click', '#continue', function() {
    $("#instructions").modal('hide');
    //TEST
    console.log('current user id = ' + currentUser.id);
    console.log('current user id = ' + currentUser.loc);
    //END TEST
});

function notEmpty (str) {
    console.log("notEmpty: length of string: " + str.length);
    if (str.length > 0) {
        console.log("returning true");
        return true;
    } else {
        console.log("returning false");
        return false;     
    }
}  
//End entry area
         
//Reading Space
$(document).on('click', '#infoColumn', function() {
    $("#infoColumn").animate({opacity:0});
});

//VIEWS
ReadingView = Backbone.View.extend({
    el: $('#readingElements'),
    initialize: function() {
        console.log("initialized Reading view");
    },
    render: function (dataLocation, template) {
        //console.log("ReadingView rendered using json from loc: " + dataLocation);
        this.loadReading(dataLocation, template);
    },
    loadReading: function (readingFile, template) {
        console.log("loading reading from: " + readingFile);
        console.log("Element is: " + this.$el.attr('id'));
        //TODO: prepend twitter bootstrap alert
        var a = '<div class="alert"><button type="button" class="close" data-dismiss="alert">&times;</button>You can <strong>click</strong> the <span style="color: blue">blue</span> words to get feedback.</div>';
        var e = '<div id="toQuiz"><button id="quizButton"><strong>Go To Quiz</strong></button></div>';
        this.$el.prepend(a);
        var that = this;
        $.getJSON('data/outsider_usages.json', function(data) {
            console.log("getting the reading JSON");
            var dict = data;
            _.each(dict, function(entry) {
                console.log("feedback word: " + entry.feedbackWord);
                console.log("surface word: " + entry.surfaceForm);
                //var readingItem = new Reading({context: entry.context, feedbackWord: entry.feedbackWord});
                var c = entry.context;
                var f = entry.feedbackWord;
                var w = entry.surfaceForm;
                var markedUp = c.replace(w, '<span class="feedback" data-word="'+f+'">'+w+'</span>');
                //NOW FILL THE READING TEMPLATE
                var readingItem = {context: markedUp};
                var html = template(readingItem); 
                that.$el.append(html);
            });
            that.$el.append(e);
        });
    },
    events: {
        "click .feedback": function(e) {
                e.preventDefault();
                var $clicked = $(e.currentTarget);
                var wordID = $clicked.data('word');
                
                //TEST
                debugger;
                console.log('clicked element: wordID: ' + wordID);
                this.trigger("click", wordID, currentUser);             
        },
        "click #toQuiz": function(e) {
                e.preventDefault();
                console.log('inside reading view --> toQuiz event');
                this.trigger("toQuiz"); //TODO: store user data in model
        }
   }
});

FeedbackView = Backbone.View.extend({
    el: $('#infoColumn'),
    initialize: function() {
        console.log("initialized view");
    },
    render: function (template, feedbackObj) {
        this.toggleColumn(true);
        var html = template(feedbackObj);
        this.$el.html(html);
        //if syns/examples is not empty, prepend text
        
        //this.$el.html("I was passed: " + word);
        
        console.log("FeedbackView rendered");
    },
    toggleColumn: function(bool) {
        if (bool === true) {
            this.$el.animate({opacity:1});
        }
        else if (bool === false) {
            this.$el.animate({opacity:0});
        }
    }
});

QuizView = Backbone.View.extend({
    el: $('html')
    //TODO: load quiz into html element via ajax call 


});    

//END VIEWS

//MODELS AND COLLECTIONS
//Model for reading item
var Reading = Backbone.Model.extend({
    defaults:{
        surfaceWord: '',
        context: '',
        feedbackWord: '',
    }
    //don't need helper functions because attributes can be accessed via dot notation
});

//Model for feedback item
var Word = Backbone.Model.extend({
    defaults:{
        word: '',
        pos: '',
        syns: [],
        ex: ''
    }
    //don't need helper functions because attributes can be accessed via dot notation
});

//collection of all words -- aka feedback collection
var Words  = Backbone.Collection.extend({
    model: Word,
    //TODO initialize collection via JSON Ajax?
    //  - iterate over attributes to get every word
    loadWordData: function() {
        var that = this;
        $.getJSON('data/feedback.json', function(data) {
            //models = [];
            console.log("getting the JSON for the feedback vocabulary");
            var dict = data;
            _.each(dict, function(i) {
                console.log("word: " + i.word);
                //TODO: connect words to <span>s by id = word
                //TODO: load readings with <span> ids
                var w = new Word({id: i.word, word: i.word, pos: i.pos, syns: i.syns, ex: i.examples});
                that.add(w);
            });
            //that.wordCollection(models);
        });   
    }
});
//END MODELS AND COLLECTIONS

//loadReading('pages/readingOutsiders.html', '#outsidersReading');
var reading = new ReadingView();
var feedback = new FeedbackView();
var quiz = new QuizView();

var feedbackTemplate = Handlebars.compile($('#feedbackTemplate').html());
var readingTemplate = Handlebars.compile($('#readingTemplate').html());

reading.render('pages/readingOutsiders.html', readingTemplate); //TODO: change the argument structure here

var words = new Words();
words.loadWordData();

//TODO: the feedback onClick event also interacts with the user object
//TODO: change from elem text to data-word
feedback.listenTo(reading, "click", function(elemText) {
    console.log("Feedback View heard click from reading -- text: " + elemText);
    $.trim(elemText);
    var fb = words.get(elemText);
    //add clicked word to user data object
    currentUser.clickedWords.push(elemText);
    //TEST #tested
    console.log("added " + elemText + " to user object TEST: " + currentUser.clickedWords[currentUser.clickedWords.length-1]);

    var sLabel = '';
    if (fb.get('syns').length > 0) {
         sLabel = 'Synonyms';
    }
    var eLabel = '';
    if (fb.get('ex').length > 0) {
         eLabel = 'Example Usages';
    }
    //populate the handlebars template
    var out = {word: fb.get('word'), synLabel: sLabel, exLabel: eLabel, syns: fb.get('syns'), ex: fb.get('ex')};
    //this.render(elemText);
    this.render(feedbackTemplate, out);
});

//todo -- make quiz view -- render event replaces HTML with the quiz -- DON'T LOSE THE DATA
quiz.listenTo(reading, "toQuiz", function() {
    console.log("quiz view heard toQuiz event from reading view");
    //this.render(feedbackTemplate, out);
    //HACKS
    $(document).on('click', '#quizButton', function(e) {
         e.preventDefault();
         $.ajax({
             url: 'quiz.html',
             success: function(data) {
                 //call renderQuiz() from ui
                 $('body').html(data);
                 $("html, body").animate({ scrollTop: 0 }, "fast"); //scroll to top
                 renderQuiz();
                 console.log("rendered quiz");
             }
        });
        console.log('quizButton clicked');
         //TODO: pre-load quiz into a hidden div
         //load quiz from ajax -- TODO: submit interaction feature vector
    });

    $(document).on('click', '#submit', function(e) { 
         e.preventDefault();
         var $w = $('#wrapper');
         $w.find('.alert').remove();
         console.log("INSIDE app.js: submit button was clicked");
         //TODO: pass numAnswers as param
         var numAnswers = 10;
         var l = $(".inBlank").length;
         if (l < numAnswers) {
            var a = '<div class="alert alert-error"><button type="button" class="close" data-dismiss="alert">&times;</button><strong>Please answer every question</strong></div>';
            $w.prepend(a);
         } else {
            //core.js --> format checkAnswers(callback)
            checkAnswers(useQuizData);
            var b = '<div class="alert"><button type="button" class="close" data-dismiss="alert">&times;</button><strong>Thanks, and have a great day!</strong></div>';
            $w.prepend(b);
         }
        console.log("Size of .inBlank list: " + l);
        console.log('submit button clicked');
    });
});

function useQuizData (quizData) {
    //TEST
    //var d = quizData.blank2;
    //for (var c = 0; c<d.length; c += 1) {
    //  console.log("CALLBACK: quizData returned: " + d[c]);
    //}

    //User is global - can be grabbed from anywhere
    if (currentUser.submitted === undefined) {
        currentUser["quizResults"] = quizData;
        //TODO: set user's total time
        currentUser.stopTime = new Date().getTime()/1000;
        currentUser.totalTime = Math.floor(currentUser.stopTime - currentUser.startTime);

        //TEST
        var o = JSON.stringify(currentUser);
        console.log("Pushing to server: currentUser to JSON: " + o);
        //End Test

        storeUserData(currentUser);
        currentUser.submitted = 'true';
        $("#wrapper").find('#submit').remove();
        
    }
}

function storeUserData (userObj) {
    //store the total time
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
        },
        error: function(){
            console.log('userData did not persist -- there was a problem with the request');
        }
    });
}



