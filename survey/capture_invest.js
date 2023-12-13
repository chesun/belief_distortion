// capture the investment embed variables
// add on submit

Qualtrics.SurveyEngine.addOnPageSubmit(function()
{
  // investment
  var investment = this.getChoiceAnswerValue();
  var currentLoop = "${lm://CurrentLoopNumber}"
  //  investment in this round, 1 is A and 2 is B
  Qualtrics.SurveyEngine.addEmbeddedData("invest_round" + currentLoop, investment);

  if (investment == "1") {
      Qualtrics.SurveyEngine.setEmbeddedData('current_loop_investment', "Portfolio A");
  }
  else if (investment == "2") {
      Qualtrics.SurveyEngine.setEmbeddedData('current_loop_investment', "Portfolio B");

  }
});