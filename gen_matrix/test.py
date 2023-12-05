# from tkinter import *
# from tkinter import ttk
# root = Tk()
# frm = ttk.Frame(root, padding=10)
# frm.grid()
# ttk.Label(frm, text="Hello World!").grid(column=0, row=0)
# ttk.Button(frm, text="Quit", command=root.destroy).grid(column=1, row=0)
# root.mainloop()

from dn_matrix import DotMatrix as Mat
from gen_normal_matrix import Constants, Paths
import numpy as np 

constants = Constants(
    n_pairs = 20, 
    mat_dim= 10
    )

paths = Paths(
    folder_path="./gen_matrix/graphs/discrete_normal",
    folder_name = f"dim_{constants.mat_dim}_pairs_{constants.n_pairs}"
    )    



this_mat = Mat(n_red=39, matrix_dim=10, canvas_dim=300)
this_mat.draw_half(half_pos="top")
this_mat.save(filename="1", folder_name="", folder_path=paths.folder_path)

this_mat.draw_half(half_pos="bottom")
this_mat.save(filename="2", folder_name="", folder_path=paths.folder_path)

this_mat.draw_complete()
this_mat.save(filename="3", folder_name="", folder_path=paths.folder_path)

this_mat = Mat(n_red=78, matrix_dim=10, canvas_dim=300)
this_mat.draw_complete()
this_mat.save(filename="4", folder_name="", folder_path=paths.folder_path)

input = np.array([[19,38] for i in range(10)])

for i in input:
    for j in i:
        this_mat  = Mat(n_red=j, matrix_dim=10, canvas_dim=300)
        this_mat.draw_half(half_pos="top")
        this_mat.save(filename=f"{j}", folder_name="", folder_path=paths.folder_path)
        this_mat.draw_complete()
        this_mat.save(filename=f"{j}_comp", folder_name="", folder_path=paths.folder_path)
