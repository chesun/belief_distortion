
Qualtrics.SurveyEngine.addOnPageSubmit(function()
{
    // investment
    var investment = this.getChoiceAnswerValue();
    if (investment == "1") {
        Qualtrics.SurveyEngine.setEmbeddedData('current_practice_investment', "Portfolio A");
    }
    else if (investment == "2") {
        Qualtrics.SurveyEngine.setEmbeddedData('current_practice_investment', "Portfolio B");

    }

});

Qualtrics.SurveyEngine.addOnPageSubmit(function()
{
	// guesses
    var guess_A_half = this.getChoiceAnswerValue(1);
    var guess_B_half = this.getChoiceAnswerValue(2);

    Qualtrics.SurveyEngine.setEmbeddedData('current_practice_A_half_guess', guess_A_half);
    Qualtrics.SurveyEngine.setEmbeddedData('current_practice_B_half_guess', guess_B_half);

    jQuery("#complete_A").text(parseInt(guess_A_half) * 2);
    jQuery("#complete_B").text(parseInt(guess_B_half) * 2);
});