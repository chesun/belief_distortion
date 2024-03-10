// capture the investment embed variables
// add on submit

Qualtrics.SurveyEngine.addOnPageSubmit(function()
{
  // investment
  var investment = this.getChoiceAnswerValue();
  var currentLoop = "${lm://CurrentLoopNumber}"
  //  investment in this round, 1 is A and 2 is B

  if (investment == "1") {
      Qualtrics.SurveyEngine.setEmbeddedData('current_loop_investment', "Portfolio A");
      Qualtrics.SurveyEngine.setEmbeddedData("invest_round" + currentLoop, "A");
  }
  else if (investment == "2") {
      Qualtrics.SurveyEngine.setEmbeddedData('current_loop_investment', "Portfolio B");
      Qualtrics.SurveyEngine.setEmbeddedData("invest_round" + currentLoop, "B");
  }

  // calculate if investment successful
  var actual_red_A = parseInt("${lm://Field/5}");
  var actual_red_B = parseInt("${lm://Field/10}");
  if (actual_red_A > actual_red_B) {
    if (investment == "1") {
      Qualtrics.SurveyEngine.setEmbeddedData('success_round' + currentLoop, 1);
    }
    else {
      Qualtrics.SurveyEngine.setEmbeddedData('success_round' + currentLoop, 0);
    }
  }
  else {
    if (investment == "1") {
      Qualtrics.SurveyEngine.setEmbeddedData('success_round' + currentLoop, 0);
    }
    else {
      Qualtrics.SurveyEngine.setEmbeddedData('success_round' + currentLoop, 1);
    }
  }
});

