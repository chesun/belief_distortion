# import packages
import turtle 
import os
from PIL import Image
from random import randint

# function to draw square matrix with red and black dots 
# canvas_dim --> width and height (px) of a square canvas, make sure it is divisible by matrix_dim
# matrix_dim --> dimension of dot matrix, equal to number of dots on one side
# p --> probability of red for bernoulli trial of drawing each dot
def draw(canvas_dim, matrix_dim, p, save_path, file_name_shell): 
    # set the width and height of turtle window
    window_w = canvas_dim + 20
    window_h = canvas_dim + 20

    # initialize an instance of the turtle screen and pen 
    screen = turtle.Screen()
    # turn off tracer
    screen.tracer(0)
    pen = turtle.Turtle() 
    tsize = pen.turtlesize()
    pen.speed(10)

    # set turtle window size
    screen.setup(window_w, window_h)
    # set turtle canvas size
    screen.screensize(canvas_dim, canvas_dim)

    # print('screen size: ', screen.screensize(), 'window width: ', screen.window_width(), 'window height: ', screen.window_height())

    # padding for the matrix
    pad = canvas_dim/(2 * matrix_dim)
    # space between dots
    space = (canvas_dim - 2 * pad)/(matrix_dim - 1)

    # make pen go to starting position
    pen.penup()
    pen.goto(- canvas_dim/2 + pad, canvas_dim/2  - pad)
    pen.pendown()

    # initialize a var for number of red dots
    n_red = 0
    for i in range(matrix_dim): 
        for j in range(matrix_dim): 
            
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
        pen.backward(space * matrix_dim) 
        
        # move turtle to start of next row
        pen.right(90) 
        pen.forward(space) 
        pen.left(90) 
    
    # print('number of red dots: ', n_red)

    # hide the turtle 
    pen.hideturtle()
    # refresh the screen to show drawing
    screen.update()
    # file path and name
    file_name = file_name_shell.format(matrix_dim, n_red)
    eps_complete_name = os.path.join(save_path, file_name+'.eps')
    png_complete_name = os.path.join(save_path, file_name+'.png')
    # grab the screen and export to eps file 
    turtle.getscreen().getcanvas().postscript(file = eps_complete_name)
    # print(eps_complete_name)

    # convert eps to png
    eps_image = Image.open(eps_complete_name)
    eps_image.save(png_complete_name)

    # delete eps file 
    os.remove(eps_complete_name)
    # turtle.done()
    # screen.mainloop()

    return(n_red)



# a function to draw n pairs of matrices
def draw_n_pairs(canvas_dim, matrix_dim, n, p):
    dir = '/Users/christinasun/Library/CloudStorage/Dropbox/github_repos/belief_distortion/gen_matrix/graphs'
    file_prefix_shell = 'pair_{}_'
    file_name_shell = 'dim_{}_r_{}'
    # create a folder for graphs and handle already exist error
    folder = 'dim_{}_pairs_{}'.format(matrix_dim, n)
    save_path = os.path.join(dir, folder)
    try:
        os.makedirs(save_path, exist_ok = True)
        print('Folder "%s" created successfully' % folder)
    except OSError as error:
        print(error)

    # delete everything in the folder
    for file in os.scandir(save_path):
        print(file)
        os.remove(os.path.join(save_path, file.name))


    # a counter for the total number of times matrix pairs have the same number of red
    same_instance = 0

    nred_overall = []
    # draw matrix pairs
    for pairindex in range(n):
        # a list for number of red in each matrix in this pair
        pair_nred = []
        # fill the matrix pair number in the prefix shell
        file_prefix = file_prefix_shell.format(pairindex + 1)
        print('completed file prefix: ', file_prefix)
        # draw 2 matrices
        for i in range(2):
            nred = draw(canvas_dim = canvas_dim, matrix_dim= matrix_dim, p = p, save_path= save_path, file_name_shell= (file_prefix + file_name_shell))
            pair_nred.append(nred)
        # check if the two matrices have the same number of red
        while pair_nred[1] == pair_nred[0]:
            same_instance += 1
            pair_nred[1] = draw(canvas_dim = canvas_dim, matrix_dim= matrix_dim, p = p, save_path= save_path, file_name_shell= (file_prefix + file_name_shell))
        nred_overall.append(pair_nred)
    print('This is the number of times matrix pairs had same n_red: ', same_instance)
    print('number of red dots in all matrix pairs: ', nred_overall)
    return nred_overall

# call drawing program
draw_n_pairs(canvas_dim= 200, matrix_dim= 10, n = 10, p = 0.5)

draw_n_pairs(canvas_dim= 200, matrix_dim= 20, n = 10, p = 0.5)


