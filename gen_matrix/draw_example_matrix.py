# draw whole matrices to be diplayed for practice

# import packages
import turtle 
import os
from PIL import Image
from random import randint
import csv 

def draw_whole_matrix(canvas_dim, matrix_dim, p, save_path, file_name_shell):
    # initialize turtle
    pen = turtle.Turtle()
    screen = turtle.Screen()
    screen.tracer(0) # turn off tracer
    pen.speed(0) # fastest turtle speed
    pen.hideturtle() # hide turtle

    # set the width and height of turtle window
    window_w = canvas_dim + 50
    window_h = canvas_dim + 50
    # padding for the matrix, if matrix bigger than 10 x 10 use twice the padding
    pad = canvas_dim/(2 * matrix_dim) if matrix_dim <= 10 else canvas_dim/matrix_dim
    # space between dots
    space = (canvas_dim - 2 * pad)/(matrix_dim - 1)
    # starting coordinates for the full matrix
    starting_x = - canvas_dim/2 + pad
    starting_y = canvas_dim/2 - pad

    # set turtle window size
    screen.setup(window_w, window_h)
    # set turtle canvas size
    screen.screensize(canvas_dim, canvas_dim)

    # draw the border 
    pen.color("black")
    pen.setheading(0)
    pen.penup()
    pen.goto(starting_x - pad, starting_y + pad) # top left corner
    pen.pendown()

    pen.goto(starting_x - pad, - starting_y - pad) # bottom left corner
    pen.goto(- starting_x + pad, - starting_y - pad) # bottom right corner
    pen.goto(- starting_x + pad, starting_y + pad) # top right corner
    pen.goto(starting_x - pad, starting_y + pad) #  back to top left corner

    pen.penup()
    screen.update()

    # draw whole matrix
    red_total = 0
    # determine starting point for the pen
    pen.goto(starting_x, starting_y)
    

