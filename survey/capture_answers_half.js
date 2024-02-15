// capture answers for guesses after seeing half portfolios.

Qualtrics.SurveyEngine.addOnPageSubmit(function()
{
	// guesses
    var guess_A_half = this.getChoiceAnswerValue(1);
    var guess_B_half = this.getChoiceAnswerValue(2);
    Qualtrics.SurveyEngine.setEmbeddedData('current_loop_A_half_guess', guess_A_half);
    Qualtrics.SurveyEngine.setEmbeddedData('current_loop_B_half_guess', guess_B_half);

    // set embedded variable for bonus calculation
    // guesses after seeing half portfolios
    var currentLoop = "${lm://CurrentLoopNumber}"
    Qualtrics.SurveyEngine.setEmbeddedData("guess_1_A_round" + currentLoop, guess_A_half * 2);
    Qualtrics.SurveyEngine.setEmbeddedData("guess_1_B_round" + currentLoop, guess_B_half * 2);

    // actual number of red in complete portfolios
    Qualtrics.SurveyEngine.setEmbeddedData("actual_red_A_round" + currentLoop, "${lm://Field/5}");
    Qualtrics.SurveyEngine.setEmbeddedData("actual_red_B_round" + currentLoop, "${lm://Field/10}");

    // actual number of red in half portfolios
    Qualtrics.SurveyEngine.setEmbeddedData("actual_red_half_A_round" + currentLoop, "${lm://Field/3}");
    Qualtrics.SurveyEngine.setEmbeddedData("actual_red_half_B_round" + currentLoop, "${lm://Field/8}");
 

    // update autofill display
    jQuery("#complete_A").text(parseInt(guess_A_half) * 2);
    jQuery("#complete_B").text(parseInt(guess_B_half) * 2);
});