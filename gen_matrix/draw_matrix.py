# import packages
import turtle 
import os
from PIL import Image
from random import randint
import csv 

# function to draw matrix with red and black dots - draws both half and the complete matrix
# canvas_dim --> width and height (px) of a square canvas, make sure it is divisible by matrix_dim
# matrix_dim --> dimension of dot matrix, equal to number of dots on one side
# p --> probability of red for bernoulli trial of drawing each dot
# top_half: whether draw top or bottom half, determined by the draw pair function


def draw(canvas_dim, matrix_dim, p, save_path, file_name_shell, top_half): 
    #############################################################
    # canvas and screen setup
    


    # turtle initialization
    # initialize an instance of the turtle screen and pen 
    screen = turtle.Screen()
    pen = turtle.Turtle()
    pen.hideturtle()
    screen.tracer(0)
    pen.speed(0) # the fastest turtle speed    
    
    tsize = pen.turtlesize()

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

    # function to draw dots, starting from wherever the pen is currently
    # dim_x: number of dots horizontally
    # dim_y: number of dots vertically
    def draw_dots(dim_x, dim_y, space, p):
        
        pen.setheading(0)
        # initialize a var for number of red dots
        n_red = 0
        for i in range(dim_y): 
            for j in range(dim_x): 
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
            pen.backward(space * dim_x) 
            
            # move turtle to start of next row
            pen.right(90) 
            pen.forward(space) 
            pen.left(90) 

        # refresh the screen to show drawing
        screen.update()
        return n_red


    # function for saving and converting files,  handles top/bottom half or whole matrix file name conversion
    def save_graph():
        # file path and name
        if draw_half == True and draw_top == True:
            file_name = file_name_shell.format(matrix_dim, red_total) + "_top_half"
        elif draw_half == True and draw_top == False: 
            file_name = file_name_shell.format(matrix_dim, red_total) + "_bot_half" 
        elif draw_half == False:
            file_name = file_name_shell.format(matrix_dim, red_total)
        eps_complete_name = os.path.join(save_path, file_name+'.eps')
        png_complete_name = os.path.join(save_path, file_name+'.png')
        # grab the screen and export to eps file 
        screen.getcanvas().postscript(file = eps_complete_name)
        # convert eps to png
        eps_image = Image.open(eps_complete_name)
        eps_image.save(png_complete_name)

        # delete eps file 
        os.remove(eps_complete_name)
        return png_complete_name

 
    print("turtles before border: ", screen.turtles())
    ##############################################################
    # draw the border of the matrix
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

    #########################################################
    # first draw dots for half matrix
    red_total = 0
    matrix_height = int(matrix_dim/2)
    # whether draw top or bottom half matrix, determine pen starting position for matrix
    
    
    
    # draw the top half
    if top_half == True:
        draw_half = True
        draw_top = True
        # determine starting point for the pen
        pen.goto(starting_x, starting_y)
        #################################################
        # draw dots for the top half 
        red_half = draw_dots(matrix_dim, matrix_height, space, p)
        red_total=red_half
        print("N red in top half: ", red_total)
        # file name for half matrix
        half_complete_name = save_graph()

        # finish the complete matrix
        draw_half = False
        pen.goto(starting_x, starting_y - space * (matrix_dim / 2)) # starting position for drawing bottom half
        red_total += draw_dots(matrix_dim, matrix_height, space, p)
        print("N red in complete matrix: ", red_total)
        # file name for complete matrix 
        whole_complete_name = save_graph()

    else: 
        draw_half = True
        draw_top = False
        pen.goto(starting_x, starting_y - space * (matrix_dim / 2)) # starting position for drawing bottom half
        #################################################
        # draw dots for the bottom half 
        red_half = draw_dots(matrix_dim, matrix_height, space, p)
        red_total = red_half
        print("N red in bottom half: ", red_total)

        half_complete_name = save_graph()

        # finish the complete matrix
        draw_half = False   
        pen.goto(starting_x, starting_y)
        red_total += draw_dots(matrix_dim, matrix_height, space, p)
        print("N red in complete matrix: ", red_total)

        whole_complete_name = save_graph()
   
    
    detail_dict = {"half_position": "top" if draw_top == True else "bottom", "half red": red_half, "total red": red_total, "half_complete_name": half_complete_name, "whole_complete_name": whole_complete_name}
    # for testing purposes
    print(detail_dict)
    print("turtles after drawing: ", screen.turtles())

    # delete all drawings and turtles 
    screen.clearscreen()
    return detail_dict




# testing code

# draw(canvas_dim= 400, matrix_dim= 10, p = 0.5, save_path='/Users/christinasun/Library/CloudStorage/Dropbox/github_repos/belief_distortion/gen_matrix/graphs/half', file_name_shell = 'dim_{}_r_{}', top_half= True)

# draw(canvas_dim= 400, matrix_dim= 10, p = 0.5, save_path='/Users/christinasun/Library/CloudStorage/Dropbox/github_repos/belief_distortion/gen_matrix/graphs/half', file_name_shell = 'dim_{}_r_{}', top_half= True)

# draw(canvas_dim= 400, matrix_dim= 20, p = 0.5, save_path='/Users/christinasun/Library/CloudStorage/Dropbox/github_repos/belief_distortion/gen_matrix/graphs/half', file_name_shell = 'dim_{}_r_{}', top_half=False)

# draw(canvas_dim= 400, matrix_dim= 20, p = 0.5, save_path='/Users/christinasun/Library/CloudStorage/Dropbox/github_repos/belief_distortion/gen_matrix/graphs/half', file_name_shell = 'dim_{}_r_{}', top_half=False)




###################################################
# a function to draw n pairs of matrices
def draw_n_pairs(canvas_dim, matrix_dim, n, p):
    dir = '/Users/christinasun/Library/CloudStorage/Dropbox/github_repos/belief_distortion/gen_matrix/graphs'
    file_prefix_shell = 'pair_{}_mat_{}_'
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
        # coin flip for top or bottom half for current pair
        top_half = True if randint(1, 100) <= 50 else False
        # a list for number of red in each matrix in this pair
        pair_nred = []


        # draw 2 x (half matrix, complete matrix) in the current pair
        for i in range(2):
            # fill the matrix pair number and matrix number in the prefix shell
            file_prefix = file_prefix_shell.format(pairindex + 1, i+1)
            # print('completed file prefix: ', file_prefix)

            # this is a dictionary for this particular drawing
            mat_dict = draw(canvas_dim = canvas_dim, matrix_dim= matrix_dim, p = p, save_path= save_path, file_name_shell= (file_prefix + file_name_shell), top_half= top_half)
            mat_dict["pair number"] = pairindex + 1
            mat_dict["matrix number"] = pairindex * 2 + i + 1
            pair_nred.append(mat_dict)
            # testing code
            print("current matrix details: ", mat_dict)
            print("current pair details: ", pair_nred)
        # check if the two matrices have the same number of red
        while pair_nred[1]["total red"] == pair_nred[0]["total red"]:
            same_instance += 1
            # delete the previous half and whole matrices
            os.remove(pair_nred[1]["half_complete_name"])
            os.remove(pair_nred[1]["whole_complete_name"])
            pair_nred[1] = draw(canvas_dim = canvas_dim, matrix_dim= matrix_dim, p = p, save_path= save_path, file_name_shell= (file_prefix + file_name_shell), top_half=top_half)
            pair_nred[1]["pair number"] = pairindex + 1
            pair_nred[1]["matrix number"] = pairindex * 2 + i + 1
        nred_overall.append(pair_nred[0])
        nred_overall.append(pair_nred[1])

    print('This is the number of times matrix pairs had same n_red: ', same_instance)
    print('details on the matrix pairs: ', nred_overall)

    # write details to csv
    csv_name = os.path.join(save_path, f"mat_details_dim_{matrix_dim}_pairs_{n}.csv")
    with open(csv_name, "w", newline="") as csv_file:
        fieldnames = []
        for key in nred_overall[0].keys():
            fieldnames.append(key)
        writer = csv.DictWriter(csv_file, fieldnames=fieldnames)
        writer.writeheader()
        for dict in nred_overall:
            writer.writerow(dict)


    return nred_overall




# call drawing program
draw_n_pairs(canvas_dim= 300, matrix_dim= 10, n = 10, p = 0.5)

draw_n_pairs(canvas_dim= 400, matrix_dim= 20, n = 10, p = 0.5)

# testing a large number of matrices to see distribution
# draw_n_pairs(canvas_dim= 400, matrix_dim= 20, n = 100, p = 0.5)
