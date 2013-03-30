$(document).ready(function() {
  $('#salsa_button').on('click', function(e) {
        e.preventDefault();
	var targetUrl = $('#upaddr').val(); //this is the value of the user-entered URL
        // ajax request - send this URL to the server (cgi/getUrl.pl)
        $.ajax ({
            async: true,
            cache: false,    
   	    type: 'post',
	    url: 'cgi/parseAndSave.pl',
	    data: {
		 targetUrl : $('#upaddr').val()
	    },
            dataType: 'html',
            success: function(data) {
		        $("#user-content").attr("src", "cgi/retrieveDoc.pl?docUrl="+data);
                //$("user-content").contents().find('html').html(data);
  		        $("#user-content").show();
  	    },
            complete: function() {
                console.log('Fired when the request is complete');
            },
            error: function(){
            	alert('there was a problem with the request');
            }
        });

    });
  var iframe =  $("#user-content");  
  iframe.load(function() {
	alert('the iframe loaded');
	var frameBody = iframe.contents().find('body');
   	frameBody.find('.feedback').click(function(event){
        event.preventDefault();
        // here is the iframe feedback callback
        var clickedElement = $(this);
        showFeedback(clickedElement);
        //alert('feedback word clicked');	
        var word = clickedElement.text();
        alert("word is: " + word);
        var id = clickedElement.attr("id");
        alert("id is: " + id);
        var senId = "sen" + id; 
        alert("senId is: " + senId);
        var context = iframe.contents().find("#" + senId).text();
        alert("context and word are: " + context + " & " + word);
        disambiguate(word, context);
	}); 
  });
  function disambiguate (word, context) {
    //$.post("cgi/addHead.pl", {w: word, c: context}, 
    //    function(result) {
    //        alert("the result of disambiguate is: " + result);
    //    });
    $.ajax ({
        async: true,
        cache: false,    
        type: 'post',
        url: 'cgi/addHead.pl',
        data: {
            w: word,
            c: context 
        },
        success: function(data) {
            alert("the result of disambiguate is: " + data);
        },
        error: function(){
            alert('there was a problem with the Disambiguation request');
        }   
    });
  }
  function showFeedback (elem) {
		//use (this).... to get the content for this word
			var txt = $(elem).text();
            alert('element text: ' + txt);
            queryWordNet(txt); 

			$('#hd_synList').hide();
			$('#hd_synList').html("");
            $('#hd_example').hide();
			$('#hd_example').html("");
			$('#hd_synList').append('<div id="headword"><h3>Synonyms for ' + txt + ': </h3></div>');
			$('#hd_infoColumn').css("display", "inline");
            $('#hd_infoColumn').animate({opacity: .80});
             
			//displaySynonyms(synonyms);
			//displayExample(example);
  }
  $(document).on("click", "div#hd_infoColumn", function(e) {
		e.preventDefault();  
		$('#hd_infoColumn').animate({opacity: .00});

  }); 

function queryWordNet (query) {
    $('#definition').empty();
	$.ajax ({
        async: true,
        cache: false,    
        type: 'post',
        url: 'cgi/wordNet.pl',
        data: {
            word: query 
        },
        dataType: 'html',
        success: function(data) {
            alert('wordnet data is: ' + data);
            //TODO: TEST
            $('#definition').html(data);
		    $('#definition').animate({opacity: 1});
			//$('#wordInfo').append('All definitions: <br /> ' + data);    
            //$('#hd_synList').html('Top synonyms from salsa: '+data);
        },
        complete: function() {
             console.log('Fired when the request is complete');
        },
        error: function(){
            alert('there was a problem with the WordNet request');
        }   
    });
}



  /*
//30.1.13 - THIS WAS COPIED FROM evaluation.html - TODO: only keep the necessary parts of this code
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
  */
  //End functions for reading mode
   $("#reading-elements").css("display", "inline");  
});

