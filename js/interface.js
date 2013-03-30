$(document).ready(function() {
  
  $("#upaddr").focus();
  $("#upaddr").keypress(function(e) {
      if (e.keyCode == '13') {
        $("#go_button").click();
        e.preventDefault();
      }
  });
  var fileIframe = $('#fileIframe');
  fileIframe.load(function() {
      //alert('invisible iframe loaded');
      var responseHtml = this.contentDocument.body.innerHTML;
      //alert ("response html: " + responseHtml);
      //$("#user-content").contents().find('html').html(responseHtml);
      $("#user-content").attr("src", "cgi/retrieveDoc.pl?docUrl="+responseHtml);
      $("#user-content").show();
  });
  //button to help with cross-browser file input styling (mozilla vs. chrome)
  $('#file_upload').on('click', function(e) {
        e.preventDefault();
        //trigger click() event on chooseFile      
        $('#chooseFile').click();
  });
  //display the name of the chosen file
  $('#chooseFile').change(function(e){
        $in=$(this);
        $('#fileName').html($in.val());
  });
  
  //TODO: this should be different for file and url upload!
  $('#go_button').on('click', function(e) {
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
	//alert('the iframe loaded');
	var frameBody = iframe.contents().find('body');
   	frameBody.find('.feedback').click(function(event){
        event.preventDefault();
        showInfoCol();
        // here is the iframe feedback callback
        var clickedElement = $(this);
        //alert('feedback word clicked');	
        var word = clickedElement.text();
        //alert("word is: " + word);
        var id = clickedElement.attr("id");
        //alert("id is: " + id);
        var senId = "sen" + id; 
        //alert("senId is: " + senId);
        var context = iframe.contents().find("#" + senId).text();
        //alert("context and word are: " + context + " & " + word);
        disambiguate(word, context);
        queryWordNet(word);
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
            //alert("the result of disambiguate is: " + data);
            displaySynonyms(data);
            
        },
        error: function(){
            alert('there was a problem with the Disambiguation request');
        }   
    });
}
function showInfoCol() {
    //alert("inside info col");
    $('#hd_infoColumn').css('visibility', 'visible');
    $('#hd_infoColumn').animate({opacity: 0.80});
}
  $(document).on("click", "div#hd_infoColumn", function(e) {
		e.preventDefault();  
		$('#hd_infoColumn').animate({opacity: 0.00});

  }); 

function queryWordNet (query) {
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
            //alert('wordnet data is: ' + data);
            $('#definitions').empty();
            $("#definitions").append('<h4 style="padding: 10px; margin: 0">Definitions:</h4>'); 
            $('#definitions').append(data);
            $('#definitions').animate({opacity: 1});
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

function displaySynonyms (synList) {
    $("#synonyms").empty();
    var syns = synList.split(";");
    $("#synonyms").append('<h4 style="padding: 10px; margin: 0">Top Synonyms:</h4>'); 
    for (var i=0; i < syns.length; i++) {
        //alert(syns[i]);
        $('#synonyms').append('<div class="synonym">' + syns[i] + '</div>'); 
    } 
    //$('#hd_synList').slideDown('fast');
    $('#hd_synList').show();
    $('#hd_synList').animate({opacity: 1.0}, 2000);		
}	
/*
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

