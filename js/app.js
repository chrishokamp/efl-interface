$(function(){
    console.log("Inside app.js");
    //Model for feedback item
    var Word = Backbone.Model.extend({
        defaults:{
            word: '',
            pos: '',
            syns: [],
            ex: ''
        },
        
        //don't need helper functions because attributes can be accessed via dot notation
    });

    //collection of all words
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
    function loadReading(readingFile, readingId) {
        $('#reading-elements').load(readingFile, function() {
            $("#reading-elements").prepend('<h3 style="color:blue;">You can click the <span style="color:red;">red</span> words to receive help!</h3>');
            $(readingId).find(".head").addClass('feedback');
            $('.feedback').hover(function() {
                    $('.feedback').addClass('hover-pointer');
                },               
                    function() {
                        $('.feedback').removeClass('hover-pointer');
                    }
            );
                   alert("In this reading, CLICK on the red words to get more information about them!");
	    });
    }

    //TEST:
    loadWordData();
    loadReading('pages/readingOutsiders.html', '#outsidersReading');

});
