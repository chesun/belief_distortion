# script to create matrices
from dataclasses import dataclass
from discrete_normal import DiscreteNormal as DN
import numpy as np
import pandas as pd
from dn_matrix import DotMatrix 
from random import randint
import os
import pdb

# Constants

@dataclass(frozen=True)
class Constants:
    """ Data class to store constants"""
    n_pairs: int
    mat_dim: int

@dataclass
class Paths:
    """Data class to store path strings"""
    folder_path: str
    folder_name: str



# save the distribution histogram
def save_dist_graph(distribution):
    fig = distribution.histogram(show=False)
    fig.savefig("./gen_matrix/graphs/dist_histogram.png")


# draw random sample
def draw_sample(n_pairs, dist):
    sample = dist.sample(n_rows=n_pairs)
    for row in range(n_pairs):
        while sample[row, 0] == sample[row, 1]:
            sample[row] = dist.sample(1, 2)
    # save array to csv
    pd.DataFrame(sample).to_csv("./gen_matrix/graphs/discrete_normal/sample.csv")
    print(sample)
    return sample # this is a numpy array

# create folder
def make_folder(folder_path, folder_name):
    save_path = os.path.join(folder_path, folder_name)
    try:
        os.makedirs(save_path, exist_ok=True)
        print(f"Folder {save_path} created successfully")
    except OSError as e:
        print(e)

# delete folder contents
def clear_folder(folder_path, folder_name):
    path = os.path.join(folder_path, folder_name)
    for file in os.scandir(path):
        os.remove(os.path.join(path, file.name))


# draw matrices
def draw(sample, mat_dim, folder_name, folder_path):
    pair_counter = 0
    for pair in sample:
        pair_counter += 1
        # randomly draw top and bottom
        draw_top = True if randint(0, 1) == 0 else False
        mat_counter = 0
        for n_red_total in pair:
            mat_counter += 1
            this_mat = DotMatrix(n_red = n_red_total, matrix_dim = mat_dim)
            # draw and save half matrices
            
            # pdb.set_trace()

            this_mat.draw_half(top = draw_top)
            filename_half = f"pair_{pair_counter}_mat_{mat_counter}_r_{this_mat.n_red_this_half}_top_{draw_top}"
            this_mat.save(filename=filename_half, folder_name=folder_name, folder_path=folder_path)
            #  draw and save whole matrix
            this_mat.draw_complete()
            filename_complete = f"pair_{pair_counter}_mat_{mat_counter}_r_{n_red_total}_full"
            this_mat.save(filename=filename_complete, folder_name=folder_name, folder_path=folder_path)

def main():
    constants = Constants(
        n_pairs = 20, 
        mat_dim= 10
        )

    paths = Paths(
        folder_path="./gen_matrix/graphs/discrete_normal",
        folder_name = f"dim_{constants.mat_dim}_pairs_{constants.n_pairs}"
        )    

    # initialize distribution 
    dist = DN(mean=50, sd=10, cutoff_distance=30)
    print(dist.complete_pdf())

    # save distribution graph
    save_dist_graph(dist)

    # draw random sample
    sample_array = draw_sample(n_pairs=constants.n_pairs, dist=dist)

    # create folder and clear contents
    make_folder(folder_name=paths.folder_name, folder_path=paths.folder_path)

    # delete old contents
    clear_folder(folder_name= paths.folder_name, folder_path= paths.folder_path)

    
    # draw matrices
    draw(
        sample= sample_array, 
        mat_dim= constants.mat_dim, 
        folder_name= paths.folder_name,
        folder_path= paths.folder_path
        )
















if __name__ == "__main__":
    main()



