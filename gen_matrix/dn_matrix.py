# given number of red, draw matrix
import turtle 
import os
from PIL import Image
import numpy as np

class DotMatrix:
    def __init__(self, n_red, matrix_dim = 10, canvas_dim = 300):
        self.n_red = n_red
        self.matrix_dim = matrix_dim
        self.canvas_dim = canvas_dim
        # set the width and height of turtle window
        self.window_w = canvas_dim + 50
        self.window_h = canvas_dim + 50
        # padding for the matrix, if matrix bigger than 10 x 10 use twice the padding
        self.pad = canvas_dim/(2 * matrix_dim) if matrix_dim <= 10 else canvas_dim/matrix_dim
        # space between dots
        self.space = (canvas_dim - 2 * self.pad)/(matrix_dim - 1)
        # starting coordinates for the full matrix
        self.starting_x = - canvas_dim/2 + self.pad
        self.starting_y = canvas_dim/2 - self.pad
        
        # initialize the array representation for the matrix using 1s and 0s
        # list of 1s and 0s, number of 1s equal to self.n_red
        list_repr = [1 for i in range(self.n_red)]
        list_repr.extend([0 for i in range(self.matrix_dim**2 - self.n_red)])
        # print(list_repr)
        self.mat_array = np.array(list_repr)
        # shuffle the numbers in the matrix
        np.random.shuffle(self.mat_array)
        # reshape array into matrix 
        self.mat_array = np.reshape(self.mat_array, newshape= (self.matrix_dim, self.matrix_dim))
        print(self.mat_array)
        try:
            assert len(list_repr) == self.matrix_dim**2
        except Exception as e:
            print(f"array representation dimension incorrect: {e}")
        self.mat_top_half_array = self.mat_array[:int(self.matrix_dim/2), :]
        self.mat_bot_half_array = self.mat_array[int(self.matrix_dim/2):, :]
        self.n_red_top = np.sum(self.mat_top_half_array)
        self.n_red_bot = np.sum(self.mat_bot_half_array)
    
    def setup(self):
        # initialize an instance of the turtle screen and pen 
        # *****************************
        self.screen = turtle.Screen()
        self.pen = turtle.Turtle()
        self.pen.hideturtle()
        self.screen.tracer(0)
        self.pen.speed(0) # the fastest turtle speed    
        # set turtle window size
        self.screen.setup(self.window_w, self.window_h)
        # set turtle canvas size
        self.screen.screensize(self.canvas_dim, self.canvas_dim)

    def clear(self):
        # delete all drawings and turtles 
        self.screen.clearscreen()

    def save(self, filename, folder_name, folder_path = "./gen_matrix/graphs/discrete_normal"):
        save_path = os.path.join(folder_path, folder_name)
        eps_path = os.path.join(save_path, filename + ".eps")
        png_path = os.path.join(save_path, filename + ".png")
        
        self.screen.getcanvas().postscript(file= eps_path)
        eps_img = Image.open(eps_path)
        eps_img.save(png_path)
        os.remove(eps_path)
        self.clear()

    
    def draw_border(self):
        ##############################################################
        # draw the border of the matrix
        self.pen.color("black")
        self.pen.setheading(0)
        self.pen.penup()
        self.pen.goto(self.starting_x - self.pad, self.starting_y + self.pad) # top left corner
        self.pen.pendown()

        self.pen.goto(self.starting_x - self.pad, - self.starting_y - self.pad) # bottom left corner
        self.pen.goto(- self.starting_x + self.pad, - self.starting_y - self.pad) # bottom right corner
        self.pen.goto(- self.starting_x + self.pad, self.starting_y + self.pad) # top right corner
        self.pen.goto(self.starting_x - self.pad, self.starting_y + self.pad) #  back to top left corner

        self.pen.penup()
        self.screen.update()


    def draw_half(self, top: bool):
        self.setup()
        self.draw_border()
        if top:
            self.pen.goto(self.starting_x, self.starting_y)
            mat_to_draw = self.mat_top_half_array
            self.n_red_this_half = self.n_red_top
        else:
            self.pen.goto(self.starting_x, self.starting_y - self.space * (self.matrix_dim / 2))    
            mat_to_draw = self.mat_bot_half_array
            self.n_red_this_half = self.n_red_bot
        # iterate over rows of the array
        for row in mat_to_draw:
            for num in row:
                self.pen.pendown()
                if num == 0:
                    self.pen.color("black")
                    self.pen.dot()
                else:
                    self.pen.color("red")
                    self.pen.dot()
                self.pen.penup()
                self.pen.forward(self.space)
            self.pen.backward(self.space * self.matrix_dim)

            # move turtle to start of next row
            self.pen.right(90) 
            self.pen.forward(self.space) 
            self.pen.left(90) 
        self.screen.update()

        # self.save(filename="test")
        # self.clear()
    
    def draw_complete(self):
        self.setup()
        self.draw_border()
        self.pen.goto(self.starting_x, self.starting_y)
        # iterate over first 5 rows of the array
        for row in self.mat_array:
            for num in row:
                self.pen.pendown()
                if num == 0:
                    self.pen.color("black")
                    self.pen.dot()
                else:
                    self.pen.color("red")
                    self.pen.dot()
                self.pen.penup()
                self.pen.forward(self.space)
            self.pen.backward(self.space * self.matrix_dim)

            # move turtle to start of next row
            self.pen.right(90) 
            self.pen.forward(self.space) 
            self.pen.left(90) 
        self.screen.update()






mat = DotMatrix(n_red=45)
top = mat.draw_half(True)
# mat.save(folder_name="", filename="test1")
# bot = mat.draw_half(half_pos="top")
# mat.save(folder_name="test", filename="test2")
