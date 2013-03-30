#!/usr/bin/perl
# This script links all the words in a text (passed via the TEXT param)
# Chris Hokamp 
# Spring 2012
use CGI;
use checkWord;
use preprocess;
use salsaTagger;

$query = new CGI; 
$time = time();

# read the query from the Web interface
$myText = $query->param("TEXT");
#How to get the text back exactly as it was?? --> could split by chars or use substring operations to put new links in (requires storing the char index and length of the word to tag)

my $tokens = &simple_tokenize($myText);
my @tokens = split(/ /, $tokens);
my $ref = \@tokens;
my $output = &tag($ref);

# run my search engine and collect the results
# - the query read from the Web interface is stored in $myQuery
# - the search engine returns a list of documents, which is
# stored in @myResults
#undef($myResults);
#my @myResults = `perl searchEngine \"$myQuery\"`;
#my $myResults = join "<br>",@myResults;


## DISPLAY THE TEXT WITH MARKUP   #TODO: get the whole context 
print $query->header ( ); 
print <<END_HTML; 
<html>

	<head>
		<meta name="robots" content="noindex,nofollow" />
		<meta http-equiv="content-type" content="text/html;charset=utf-8" />
		<title>Salsa Interface</title>
<link href="style.css" rel="stylesheet" media="all" />
<link href="output.css" rel="stylesheet" media="all" />
<script src="//ajax.googleapis.com/ajax/libs/jquery/1.7.2/jquery.min.js" type="text/javascript"></script>

</head>
<body>

 <div id = "wrapper">
<div id = "main">
<div id = "all_columns"> 
<div id = "page"> <!-- this is the page column -->
<!-- the content from the .cgi script on the server goes here -->

<h2>click on the highlighted words to view their synonyms and definitions...</h2>
<div id ="context"><p>$output</p></div> <br /><br />

<script>
var title = \$("em").attr("title");
  \$("#test").text(title);

</script>



</div> <!-- end page -->
<div id="synonyms"> <!-- this is the synonyms column -->

</div> <!-- end synonyms -->
</div>

<script>
\$(document).ready(function(){
  \$('.head').click(function() { 
    var word =\$(this).attr('name');
    var text = \$('div#context').text();
    var id = \$(this).attr('id');
    \$.get("query_salsa.pl", { word:word, context:text, id:id}, function(data) {
	\$('div#synonyms').html(data);
       //alert("Load was performed" + data);
    });
   
  });
});
</script>	
<div id = "bottom">
<div class = "link">
<a href="http://lit.csci.unt.edu/">Language and Information Technologies</a> | <a href="http://www.unt.edu">University of North Texas</a>
</div>
</div> <!-- end bottom -->
</div> <!-- end wrapper -->
</body>
</html>


END_HTML

 

