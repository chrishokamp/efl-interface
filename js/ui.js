$(document).ready(function() {
    //TODO -- TEMPORARY!
    $(".dragWord").addClass('inBuffer');
    pageUpdate();
    //END STARTUP FUNCTIONS

    // GLOBAL STATEFUL OBJECTS
    var Container = {
        numElements: function() {
            return $(".inBuffer").length;
        },
        //we need to be able to increment and decrement each spot
        nextSpot: function() {
            var lineHeight = parseInt($('body').css('line-height'), 10);
            //alert ("container says that line height is: " + lineHeight);
            return (this.numElements() * lineHeight) + 20;
            //alert("NEXT SPOT IS NOW: " + this.nextSpot);
        }
    };
    //Container.nextSpot();


    //$(function() {
    //TODO: only allow dragging to droppable elements
    //TODO: if element is already filled, replace its content and                   send the other element back to the word column
    $(".dragWord").attr('current', "");
    $(".dragWord").draggable({ 
        start: function() {$(this).css("zIndex", "100");},
        stop: function() {$(this).css("zIndex", "10");},
        snap: ".ui-widget-header", 
        snapMode: "inner", 
        snapTolerance: 30, 
        revert: function(valid) {
            if(valid) {
                if ($(this).hasClass('inBlank')) {
                    var oldBlank = $(this).attr('oldBlank');
                    //alert("dragged from blank: " + oldBlank);
                    $('#' + oldBlank).removeClass('occupied');
                    $('#' + oldBlank).attr('current', '');
                } else {
                    $(this).addClass('inBlank'); 
                    //var oldBlank = $(this).attr('oldBlank');
                }
                return false;
            } else {
                return true;
            }
        }, 
        /*

        containment: 'document',
                stop: function() {
            if ($(this).hasClass('inBlank')) {
                //TODO: add attr telling us which blank
                var oldBlank = $(this).attr('current');
                //alert("dragging from blank: " + oldBlank);
                $('#' + oldBlank).removeClass('occupied');
                $('#' + oldBlank).attr('current', '');
            }
        } */
    }); 

    //TODO: factor out the drop function
    $(".blank").droppable({
        drop: function( event, ui ) {
            dropped(event, ui, $(this));

            pageUpdate();
            //TODO: add local fallback for JqueryUI
        }
    });
        
    // TODO: move this logic to a global pageUpdate function
    function dropped (event, ui, $elem) {
         //TODO: remove the occupied class from previous blank
                      
         var draggableId = ui.draggable.attr("id");
         var thisId = $elem.attr("id");
         var $e = $('#' + draggableId);
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
        //if has class inBuffer, add to list and position properly
        // to keep absolute postioning, use something like currentTop += ... each time an element is added
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
