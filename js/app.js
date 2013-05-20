$(function(){
    console.log("Inside app.js");

    ReadingView = Backbone.View.extend({
        el: $('#readingElements'),
        initialize: function() {
            console.log("initialized view");
        },
        render: function (dataLocation) {
            //this.$el.html("I was passed: " + word);
            //console.log("ReadingView rendered using json from loc: " + dataLocation);
            this.loadReading(dataLocation);
        },
        loadReading: function (readingFile) {
            console.log("loading reading from: " + readingFile);
            console.log("Element is: " + this.$el.attr('id'));

            this.$el.load(readingFile, function() {
                //TODO: use a templating engine for this part!
                console.log("inside success callback");
                $(this).prepend('<h3 style="color:blue;">You can click the <span style="color:red;">red</span> words to receive help!</h3>');
                $(this).find(".head").addClass('feedback');
                $('.feedback').hover(function() {
                    $('.feedback').addClass('hover-pointer');
                    },               
                    function() {
                        $('.feedback').removeClass('hover-pointer');
                    }
                );
         
            });
        },
        events: {
            "click .feedback": function(e) {
                //console.log("click: value of this is: " + typeof(this)); //value of 'this' is the Backbone view
                    e.preventDefault();
                    console.log('clicked element was: ' + $(e.currentTarget).text());
                    this.trigger("click", $(e.currentTarget).text()); //Is it correct to pass text() here?
            }
       }
    });

    FeedbackView = Backbone.View.extend({
        el: $('#infoColumn'),
        initialize: function() {
            console.log("initialized view");
        },
        render: function (word) {
            this.toggleColumn(true);
            //initialize the word models, and the words collection 
            //add the div to the DOM, or select it
            this.$el.html("I was passed: " + word);
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

    //Model for feedback item
    Word = Backbone.Model.extend({
        defaults:{
            word: '',
            pos: '',
            syns: [],
            ex: ''
        },
        
        //don't need helper functions because attributes can be accessed via dot notation
    });

    //collection of all words -- aka feedback collection
    var feedbackList = Backbone.Collection.extend({
        model: Word,
        //TODO: HELPER FUNCTIONS?        
    });

    //TODO initialize collection via JSON Ajax?
    //  - iterate over attributes to get every word

    //NOTE: this is a reading function!
    function loadWordData () {
        //loading();
        $.getJSON('data/words.json', function(data) {
            var dict = data.words;
            _.each(dict, function(prop) {
                console.log("word: " + prop.word);
                //TODO: connect words to <span>s by id = word
                //TODO: load readings with <span> ids
                
            });

            //$('#loading').animate({opacity: 0.0}, 1500, function() {
                //stopLoading();
            //});
            
        });
    }

    //TEST:
    loadWordData();
    //loadReading('pages/readingOutsiders.html', '#outsidersReading');
    var reading = new ReadingView();
    var feedback = new FeedbackView();
    reading.render('pages/readingOutsiders.html');
    feedback.listenTo(reading, "click", function(elemText) {
        console.log("Feedback View heard click from reading -- text: " + elemText);
    });

    //_.extend(feedback, Backbone.Events);

});
