test( "hello test", function() {
  ok( 1 == "1", "Passed!" );
});

//test app.js:notEmpty(str)
test( "notEmpty", function() {
    equal(notEmpty(""), false);
    equal(notEmpty(''), false);
    equal(notEmpty('rabbit'), true);
    equal(notEmpty("empty"), true);
});

//TODO: implement more tests
    
