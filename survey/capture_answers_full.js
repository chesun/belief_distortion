// set embedded variables for guesses after seeing complete portfolios
// for bonus calculation
Qualtrics.SurveyEngine.addOnPageSubmit(function() 
{
	// guesses
    var guess_A = this.getChoiceAnswerValue(1);
    var guess_B = this.getChoiceAnswerValue(2);

    var currentLoop = "${lm://CurrentLoopNumber}"

    Qualtrics.SurveyEngine.setEmbeddedData("guess_2_A_round" + currentLoop, guess_A);
    Qualtrics.SurveyEngine.setEmbeddedData("guess_2_B_round" + currentLoop, guess_B);

   
});
