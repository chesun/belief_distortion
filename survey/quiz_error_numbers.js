// javascript code to capture number of times each a quiz question is answered correctly

var question = $(this.questionId)
$(question).select('.ValidationError').each(function(error) {
    if (error.innerHTML == 'Your answer is incorrect. Please refer to the instructions and try again.') {
var errors = parseInt(Qualtrics.SurveyEngine.getEmbeddedData("errors_quiz_q1"))
errors++;
Qualtrics.SurveyEngine.setEmbeddedData("errors_quiz_q1", errors);
}
})