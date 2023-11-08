<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.0/jquery.min.js"></script> 
  <script>var $j = jQuery.noConflict();</script> 
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
  <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>


<div id='see_dots'>

  <div  style="text-align:center" class='container-fluid ' style='display:block;text-align:center'>
   
   <div class='row'>
         
        <div id='round' style="color:black;text-align:center;margin-left:auto;margin-right:auto;font-size:25px;font-weight:bold"></div>
        <br><br><br>

   </div>
   
   <div class='row'>


    <div class="col-md-12"  style='display:block;text-align:center;font-size:16px'>

      <div id='dotPanel'></div>

    </div>

   </div>


</div>


</div>




<script>

// ------------------------------------------------------------
// ------------------------------------------------------------
// Drawing the Dots
// ------------------------------------------------------------
// ------------------------------------------------------------



  draw=function(){

    var numWhite= 100-parseInt(numBlack)

    var blackArray=Array(numBlack).fill(0)
    var whiteArray=Array(numWhite).fill(1)
    var colArray=shuffle(whiteArray.concat(blackArray))


    signal=colArray

    var canvas = document.getElementById('canvas');
    var context = canvas.getContext('2d');
    var radius = 9;
    var lineWidth = 5;
    var cols = 10;
    var rows = 10;
    var distance = 5;
    var selected=0;

    var b=0, r=0, counter=0

    for (var i = 0; i < rows; i++) {
        for (var j = 0; j < cols; j++) {
            
            counter=counter+1

            // Draw circle
            var offset = radius * 2 + lineWidth + distance;
            var center = radius + lineWidth;
            var x =  j * offset + center;
            var y = i * offset + center;
            context.beginPath();
            
            context.strokeStyle = "black"
            context.arc(x, y, radius, 0, 2 * Math.PI, false);


            context.stroke()
            // context.fillStyle= (colArray[counter-1]==0) ? "red":"blue"
            context.fillStyle= (colArray[counter-1]==0) ? "black":"white"
            context.fill();

        }
    }


  }


  function shuffle(a) {
      for (let i = a.length - 1; i > 0; i--) {
          const j = Math.floor(Math.random() * (i + 1));
          [a[i], a[j]] = [a[j], a[i]];
      }
      return a;
  }


  showSignal=function(){

    $j('#start').hide()
    $j('#signalInstructions').hide()

    draw()
    timer = setInterval(function() {

      $j('#see_dots').css('visibility','hidden')
      // $j('#enter_guess').css('visibility','visible')

      clearInterval(timer)

    },0.25*100000)


  }



// ------------------------------------------------------------
// ------------------------------------------------------------
// Parameters and Setups
// ------------------------------------------------------------
// ------------------------------------------------------------


  var numBlack=55


  signalHtml='<div id="ways" style="margin:0 auto;text-align: center">'+
            '<table>  '+
              '<tr>'+
              '<span id="signalInstructions" style="color:black"></span>'+
              '<button id="start" class="btn btn-info">Ready?</button>'+
              '</tr>'+
            '</table>'+
          '</div>'+
          '<canvas  height="300px" id="canvas" style="border-style:solid;border-width:0px;border-color:green" width="300px"></canvas>'
          

  $j('#dotPanel').html(signalHtml)

  $j('#start').click(function(){

    showSignal()
    
  })

  $j('#round').html( '<br><span style="font-size:17px">Click "Ready" to see dots.</span>')



</script>
