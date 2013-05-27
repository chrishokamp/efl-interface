//User constructor
var User = function(id, loc) {
    this.id = id;
    this.loc = loc;
    this.startTime = new Date().getTime()/1000;
    this.clickedWords = [];
}; 

//TODO: add prototype with methods:
//user.finalTime = currentTime - user.startTime;
//user.answers

//TODO: add feature for how many times a word was clicked in the QUIZ(?)
//user.clickedWords[word] += 1;
