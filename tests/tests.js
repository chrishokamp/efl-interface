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
test( "user constructor and basic functionality", function() {
    console.log("testing user object...");
    var u = new User('r2d2', 'space');
    equal(u.id, 'r2d2');
    console.log("u.id = " + u.id);

    equal(u.loc, 'space');
    console.log("u.loc = " + u.loc);

    //TEST APPENDING TO CLICKED WORDS
    u.clickedWords.push('apple');
    u.clickedWords.push('rabbit');
    equal(u.clickedWords[1], 'rabbit');
    console.log("u.clickedWords[1] = " + u.clickedWords[1]);
     
});
    
