$(document).ready(function() {
    //TODO: temporary!!
    $(".dragWord").addClass('inBuffer');

    //TODO: call add questions! 
    //NOTE: this is conceptually similar to 'render'
    pageUpdate();
    //END STARTUP FUNCTIONS

    // GLOBAL STATEFUL OBJECTS
    //var Container = {
    //    numElements: function() {
    //        return $(".inBuffer").length;
    //    },
    //    //we need to be able to increment and decrement each spot
    //    nextSpot: function() {
    //        var lineHeight = parseInt($('body').css('line-height'), 10);
    //        //alert ("container says that line height is: " + lineHeight);
    //        return (this.numElements() * lineHeight) + 20;
    //        //alert("NEXT SPOT IS NOW: " + this.nextSpot);
    //    }
    //};
    //Container.nextSpot();

    //Begin UI elements
    $(".dragWord").attr('current', "");
    $(".dragWord").draggable({ 
        start: function() {$(this).css("zIndex", "100");},
        stop: function() {$(this).css("zIndex", "10");},
        snap: ".ui-widget-header", 
        snapMode: "inner", 
        snapTolerance: 30, 
        revert: function(valid) {
            //alert("revert fired"); //Revert always fires!
            if(valid) {
                if ($(this).hasClass('inBlank')) {
                    var oldBlank = $(this).attr('oldBlank');
                    //alert("dragged from blank: " + oldBlank);
                    $('#' + oldBlank).removeClass('occupied');
                    $('#' + oldBlank).attr('current', '');
                } 
                    //TODO: don't add a class if drop location is in #answers
                    //we need the location where this was dropped
                        
                    // $(this).addClass('inBlank'); 
                    //var oldBlank = $(this).attr('oldBlank');
                return false;
            } else {
                return true;
            }
        }, 
    }); 

    //TODO: factor out the drop function
    $(".blank").droppable({
        drop: function( event, ui ) {
            dropped(event, ui, $(this));
            pageUpdate();
            //TODO: add local fallback for JqueryUI
        }
    });

    $("#answers").droppable({
        drop: function( event, ui ) {
            //$('#' + ui.draggable.attr("id")).removeClass('inBlank').removeClass('current').removeClass('oldBlank').addClass('inBuffer');
            var elemId = '#' + ui.draggable.attr("id");
            //alert ("elem: " + elemId + " was dropped into the answers div"); 
            var $e = $(elemId);
            $e.addClass('inBuffer');
            $e.removeClass('inBlank');
            pageUpdate();
        }
    });
    $('#submit')
        .button()
        .click(function( event ) {
            event.preventDefault();
            console.log("submit button was clicked");
            //TODO: switch view properly when this happens
            checkAnswers(); 
    });

    // TODO: move this logic to a global pageUpdate function
    function dropped (event, ui, $elem) {
         //TODO: remove the occupied class from previous blank
         //alert("Dropped in blank fired");
         var draggableId = ui.draggable.attr("id");
         var thisId = $elem.attr("id");
         var $e = $('#' + draggableId);
         //add inBlank regardless, because we know it's in a blank if we're here
         $e.addClass('inBlank');
         
         if ($e.attr('current').length > 2) {
            $e.attr('oldBlank', $e.attr('current'));
         }
         $e.attr("current", thisId);
         $e.removeClass("inBuffer");

         var old = $elem.attr("current");
         $elem.attr("current", draggableId);

         if ($elem.hasClass('occupied')) {
             //alert ("before dragging, current word = " + old); 
             var $o = $('#' + old);
             $o.removeClass("inBlank");

             //TEMPORARY FIX
             $o.addClass("inBuffer");
             //END TEMP FIX

             $o.attr("current", "");
             $o.attr("oldBlank", "");
             var homeOffset = $("#answers").offset();
             var currentOffset = $o.offset(); 

             //TEST
             //var t = $elem.attr("current");
             //alert ("new val for current = " + t); 
         
         } else {
            $elem.toggleClass('occupied', true);
            var t = $elem.attr("current");
            //alert ("ELSE: new val for current = " + t); 
         }
                                                    
         //this part centers the dropped element
         var dropL = $elem.offset().left;
         //alert ("elem id: " + draggableId);
         var w = $e.outerWidth();
         var dropW = $elem.outerWidth();
         var widthDiff = dropW - w;
         var dragL = $e.offset().left;
         var d = dropL - dragL;
         $e.animate({left: "+="+d}, function(){
             var c = widthDiff/2;
             if (c > 0) {
                 $e.animate({left: "+="+c});
             }
         });
         $elem.animate({left: "+="+d});
         //alert("element was dropped!"));
    }

    function pageUpdate() { 
        //alert("page update fired");
        //alert("page update fired");
        var containerOffset = $("#answers").offset();
        var contMiddle = $("#answers").width() / 2;
        //alert ("answers top is: " + containerOffset.top + " answers left is: " + containerOffset.left); 

        var bufferWords = $(".inBuffer"); 

        var lineHeight = parseInt($('body').css('line-height'), 10);
        //var currentTop = container.top --> really this should implement something like sortable()
        for (var i = 0; i < bufferWords.length; i++) {
            //alert("NEXT SPOT IS NOW: " + this.nextSpot);
            var $elem = $(bufferWords[i]);
            //alert("elem is: " + $elem.text());
            var width = $elem.width();
            var newLeft = containerOffset.left + contMiddle - width/2;
            $elem.animate({top: (i * (lineHeight + 20)) + containerOffset.top, left: newLeft});
        }
    }
                    
});

//END UI ELEMENTS
