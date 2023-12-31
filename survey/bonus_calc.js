// calculate bonus payment using embedded variables set by JS code
function getRandomIntInclusive(min, max) {
    min = Math.ceil(min);
    max = Math.floor(max);
    return Math.floor(Math.random() * (max - min + 1) + min); // The maximum is inclusive and the minimum is inclusive
  }

// get the number of rounds
var num_rounds = parseInt(Qualtrics.SurveyEngine.getEmbeddedData('num_rounds'));

// randomly select the round and questions for payment
var round_drawn = getRandomIntInclusive(1, num_rounds);
var portfolio_number_drawm = getRandomIntInclusive(1,2);
if (portfolio_number_drawm == 1) {
    var portfolio_letter_drawn = "A";
} else {
    var portfolio_letter_drawn = "B";
}
var first_or_second_belief = getRandomIntInclusive(1,2);


// get the actual red in the selected round
var actual_red_A = parseInt(Qualtrics.SurveyEngine.getEmbeddedData('actual_red_A_round' + round_drawn));
var actual_red_B = parseInt(Qualtrics.SurveyEngine.getEmbeddedData('actual_red_B_round' + round_drawn));
console.log("actual A is " + actual_red_A);
console.log("actual B is " + actual_red_B);
// whether A or B has more red dots
var higherA = actual_red_A > actual_red_B;
console.log("higherA is " + higherA);
var higherB = actual_red_B > actual_red_A;
console.log("higherB is " + higherB);


// get the relevant guess
var belief = parseInt(Qualtrics.SurveyEngine.getEmbeddedData('guess_' + first_or_second_belief + '_' + portfolio_letter_drawn + '_round' + round_drawn));
console.log("which belief is drawn: " + first_or_second_belief);
console.log("which portfolio for belief is drawn: " + portfolio_letter_drawn)
console.log("reported belief is " + belief);

// var guess_A = parseInt(Qualtrics.SurveyEngine.getEmbeddedData('guess_' + first_or_second_belief + "_A_round" + round_drawn));
// var guess_B = parseInt(Qualtrics.SurveyEngine.getEmbeddedData('guess_' + first_or_second_belief + "_B_round" + round_drawn));

// get the investment (1 is A, 2 is B)
var investment = parseInt(Qualtrics.SurveyEngine.getEmbeddedData('invest_round' + round_drawn));

// get the bonus amounts
var choice_bonus = parseInt(Qualtrics.SurveyEngine.getEmbeddedData('choice_bonus'));
var belief_bonus = parseInt(Qualtrics.SurveyEngine.getEmbeddedData('belief_bonus'));

// determine choice bonus
// if A has more red dots
if (higherA) { 
    // check if invested in A
    if (investment == 1) {
        var earned_choice_bonus = choice_bonus;
    } else {
        var earned_choice_bonus = 0;
    }
} else { // if B has more red dots
    if (investment == 2) {
        var earned_choice_bonus = choice_bonus;
    } else {
        var earned_choice_bonus = 0;
    }
}


// determine belief bonus
if (portfolio_letter_drawn == "A") {
    var actual_red = actual_red_A;
} else {
    var actual_red = actual_red_B;
}

if ((belief >= actual_red - 5) && (belief <= actual_red + 5)) {
    var earned_belief_bonus = belief_bonus;
} else {
    var earned_belief_bonus = 0;
}


// set embedded variables
// lottery outcomes
Qualtrics.SurveyEngine.setEmbeddedData('round_drawn', round_drawn);
Qualtrics.SurveyEngine.setEmbeddedData('portfolio_for_belief', portfolio_letter_drawn);
Qualtrics.SurveyEngine.setEmbeddedData('belief_first_or_second', first_or_second_belief);

// investment choice and belief report
if (investment == 1) {
    var investment_letter = "A";
} else {
    var investment_letter = "B";
}
 
Qualtrics.SurveyEngine.setEmbeddedData('chose_round_invest', investment_letter);
Qualtrics.SurveyEngine.setEmbeddedData('chosen_belief', belief);

// portfolio details
Qualtrics.SurveyEngine.setEmbeddedData('chosen_round_A_red', actual_red_A);
Qualtrics.SurveyEngine.setEmbeddedData('chosen_round_B_red', actual_red_B);

// payment details
Qualtrics.SurveyEngine.setEmbeddedData('earned_invest_bonus', earned_choice_bonus);
Qualtrics.SurveyEngine.setEmbeddedData('earned_belief_bonus', earned_belief_bonus);
Qualtrics.SurveyEngine.setEmbeddedData('earned_total_bonus', earned_choice_bonus + earned_belief_bonus);





