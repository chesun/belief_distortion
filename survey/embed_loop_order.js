// set embedded data to the viewing order in loop and merge
var currentLoopNum = parseInt("${lm://CurrentLoopNumber}");
var currentTaskID = parseInt("${lm://Field/1}");
var currentTreat = "${lm://Field/2}";
var currentMatRed = parseInt("${lm://Field/3}");

Qualtrics.SurveyEngine.setEmbeddedData('loop_' + currentLoopNum + '_task_id', currentTaskID);
Qualtrics.SurveyEngine.setEmbeddedData('loop_' + currentLoopNum + '_treat', currentTreat);
Qualtrics.SurveyEngine.addEmbeddedData('loop_' + currentLoopNum + '_mat_red', currentMatRed);
