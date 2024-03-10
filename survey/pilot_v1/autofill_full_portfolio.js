// automatically fill in number for complete portfolios based on guesses for half


var qid= this.questionId;
console.log("This question id is " + qid);
console.log("this.getQuestionInfo().QuestionID returns " + this.getQuestionInfo().QuestionID)

jQuery("#"+qid).keyup(function() {
 

    console.log("inside the function the qid var is " + qid);
    var input1 = document.getElementById("QR~"+qid+"~1").value;
    console.log("form field 1 id is " + "QR~"+qid+"~1");
    console.log("input1 is "+ input1);

    var input2 = document.getElementById("QR~"+qid+"~2").value;
    var this_guess_A = parseInt(input1);
    var this_guess_B = parseInt(input2);
    
    console.log("first value is " + this_guess_A)

    var predict_A = this_guess_A * 2
    var predict_B = this_guess_B * 2
    if (isNaN(predict_A)) {
        jQuery("#complete_A").text("Empty: Please Enter a Whole Number");
    } else {
        jQuery("#complete_A").text(predict_A);
    }
    if (isNaN(predict_B)) {
        jQuery("#complete_B").text("Empty: Please Enter a Whole Number");
    } else {
        jQuery("#complete_B").text(predict_B);

    }

});




