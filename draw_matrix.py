# import package and making object 
import turtle 
from random import randint

screen = turtle.Screen()
pen = turtle.Turtle() 
tsize = pen.turtlesize()
# padding for initial start position 
pad = 50
pen.speed(10)
# make pen go to upper left of screen
pen.penup()
pen.goto(tsize[0]/2 - screen.window_width()/2 + pad, screen.window_height()/2 + tsize[0]/2 - pad)
pen.pendown()

# method to draw square with dots 
# space --> distance between dots 
# size	 --> side of square 
def draw(space, size, p): 
    n_red = 0
    for i in range(size): 
        for j in range(size): 
            
            # each dot is a bernoulli trial with probability p
            pen.pendown()
            if randint(1, 100) <= p * 100:
                pen.color("black")
                pen.dot() 
            else:
                pen.color("red")
                pen.dot()
                n_red += 1
            pen.penup()
            # distance for another dot 
            pen.forward(space) 
        pen.backward(space * size) 
        
        # direction 
        pen.right(90) 
        pen.forward(space) 
        pen.left(90) 
    # make space for next matrix
    pen.right(90)
    pen.forward(space * 5)
    pen.left(90) 
    print(n_red)

# Main Section 

draw(space = 10, size = 20, p = 0.5) 

draw(space = 10, size = 20, p = 0.5) 

# hide the turtle 
pen.hideturtle()

turtle.done()

