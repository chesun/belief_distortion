// set embedded data for the viewing order in loop and merge

// var currentHalfPos = "${lm://Field/2}";
// var currentMatAHalfRed = parseInt("${lm://Field/5}");
// var currentMatATotalRed = parseInt("${lm://Field/6}");
// var currentMatBHalfRed = parseInt("${lm://Field/9}");
// var currentMatBTotalRed = parseInt("${lm://Field/10}");
// var currentTreat = "${lm://Field/11}";
// var currentPairNum = parseInt("${lm://Field/1}");

var currentLoopNum = parseInt("${lm://CurrentLoopNumber}");
var currentTaskID = parseInt("${lm://Field/12}")

Qualtrics.SurveyEngine.setEmbeddedData('task_id_loop' + currentLoopNum, currentTaskID);

