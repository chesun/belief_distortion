# script to create matrices
from dataclasses import dataclass
from discrete_normal import DiscreteNormal as DN
import numpy as np
import pandas as pd
from dn_matrix import DotMatrix 
from random import randint
import os
import shutil
import pdb
import csv

# Constants

@dataclass(frozen=True)
class Constants:
    """ Data class to store constants"""
    n_pairs: int
    n_sets: int
    mat_dim: int

@dataclass
class Paths:
    """Data class to store path strings"""
    folder_path: str
    folder_name: str
    '''Directory for the repo that hosts the assets on the web'''
    hosting_path: str


    
@dataclass(frozen=True)
class HTML_Strings:
    """Data class to store strings for generating html tags"""
    url_dir: str
    img_size: int


# save the distribution histogram
def save_dist_graph(distribution):
    fig = distribution.histogram(show=False)
    fig.savefig("./gen_matrix/graphs/dist_histogram.png")


# draw random sample
def draw_sample(n_pairs, dist, folder_path, folder_name):
    sample = dist.sample(n_rows=n_pairs)
    for row in range(n_pairs):
        while sample[row, 0] == sample[row, 1]:
            sample[row] = dist.sample(1, 2)
    # save array to csv
    pd.DataFrame(sample).to_csv(os.path.join(folder_path, folder_name, "sample.csv"))
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

# copy folder contents
def copy_folder(src_path: str, src_folder: str, dst_path: str, dst_folder: str):
    '''Delete all destination folder contents and copy source folder contents'''
    make_folder(folder_name= dst_folder, folder_path= dst_path)
    clear_folder(folder_path= dst_path, folder_name= dst_folder)
    src_dir = os.path.join(src_path, src_folder)
    dst_dir = os.path.join(dst_path, dst_folder)
    if not os.path.exists(dst_dir):
        os.makedirs(dst_dir)
    for file in os.scandir(src_dir):
        src_file = os.path.join(src_dir, file.name)
        dst_file = os.path.join(dst_dir, file.name)
        shutil.copy(src_file, dst_file)

# create html img tag
def gen_img_tag(url_dir, folder_name, filename, img_size):

    full_url = os.path.join(url_dir, folder_name, filename)
    tag = f"<img src= \"{full_url}\" width = \"{img_size}\" height = \"{img_size}\" >"
    return tag 

# draw matrices
def draw(sample, mat_dim, folder_name, folder_path, url_dir, img_size):
    pair_counter = 0
    # overall list of pair dictionaries
    list_of_pair_dicts = []
    
    for pair in sample:
        # dictionary for each pair
        pair_dict = {}

        pair_counter += 1

        pair_dict["pair_number"] = pair_counter

        # randomly draw top and bottom
        draw_top = True if randint(0, 1) == 0 else False
        top_str = "top" if draw_top else "bottom"
        mat_counter = 0

        # update pair half position
        pair_dict[f"mat_half"] = top_str
        
        for n_red_total in pair:
            mat_counter += 1
            this_mat = DotMatrix(n_red = n_red_total, matrix_dim = mat_dim)
            # draw and save half matrices
            
            # pdb.set_trace()

            this_mat.draw_half(top = draw_top)
            filename_half = f"pair_{pair_counter}_mat_{mat_counter}_r_{this_mat.n_red_this_half}_{top_str}"
            
            # create html tag for half matrix
            half_tag  = gen_img_tag(
                url_dir= url_dir, 
                folder_name= folder_name, 
                filename= filename_half, 
                img_size= img_size)
            # update pair details
            pair_dict[f"mat_{mat_counter}_red_half"] = this_mat.n_red_this_half
            pair_dict[f"mat_{mat_counter}_tag_half"] = half_tag

            # save graph
            this_mat.save(filename=filename_half, folder_name=folder_name, folder_path=folder_path)

            #  draw and save whole matrix
            this_mat.draw_complete()
            filename_complete = f"pair_{pair_counter}_mat_{mat_counter}_r_{n_red_total}_full"

            # create html tag for complete matrix
            complete_tag = gen_img_tag(
                url_dir=url_dir,
                folder_name= folder_name,
                filename= filename_complete,
                img_size= img_size
            )

            # save graph
            this_mat.save(filename=filename_complete, folder_name=folder_name, folder_path=folder_path)
            
            # update details
            pair_dict[f"mat_{mat_counter}_red_total"] = n_red_total
            pair_dict[f"mat_{mat_counter}_tag_complete"] = complete_tag
            pair_dict["treatment"] = "baseline"

        # update overall details 
        list_of_pair_dicts.append(pair_dict)

    # return overall details, a list of dicts
    return list_of_pair_dicts


# export matrix details to csv
def export_details_to_csv(folder_path, folder_name, matrix_data):
    path = os.path.join(folder_path, folder_name, "matrix_details.csv")

    df = pd.DataFrame.from_records(matrix_data)
    df.to_csv(path)

# create control task dictionaries by switching matrix order
def export_control_treat_data(treat_dicts, folder_path, folder_name):
    control_dicts = []
    for treat_dict in treat_dicts:
        control_dict = {}
        control_dict["treatment"] = "control"
        control_dict["pair_number"] = treat_dict["pair_number"]
        # switch matrix left and right position in control 
        control_dict["mat_half"] = treat_dict["mat_half"]
        control_dict["mat_1_red_half"] = treat_dict["mat_2_red_half"]
        control_dict["mat_1_tag_half"] = treat_dict["mat_2_tag_half"]
        control_dict["mat_1_red_total"] = treat_dict["mat_2_red_total"]
        control_dict["mat_1_tag_complete"] = treat_dict["mat_2_tag_complete"]

        control_dict["mat_2_red_half"] = treat_dict["mat_1_red_half"]
        control_dict["mat_2_tag_half"] = treat_dict["mat_1_tag_half"]
        control_dict["mat_2_red_total"] = treat_dict["mat_1_red_total"]
        control_dict["mat_2_tag_complete"] = treat_dict["mat_1_tag_complete"]

        control_dicts.append(control_dict)
    
    # combine two lists
    overall_dicts = treat_dicts + control_dicts
    path = os.path.join(folder_path, folder_name, "control_treat_loop_fields.csv")
    pd.DataFrame.from_records(overall_dicts).to_csv(path)

# create matrix pairs 
def gen_matrix_pairs(mat_dim, n_pairs, set_num):

    paths = Paths(
        folder_path="./gen_matrix/graphs/discrete_normal",
        folder_name = f"set_{set_num}_dim_{mat_dim}_pairs_{n_pairs}",
        hosting_path= "/Users/christinasun/Library/CloudStorage/Dropbox/github_repos/asset_hosting_service/matrix_graphs/discrete_normal"
        )    
    
    html_data = HTML_Strings(
        url_dir= "http://christinasun.net/asset_hosting_service/matrix_graphs/discrete_normal",
        img_size= 300
    )


    # initialize distribution 
    dist = DN(mean=50, sd=10, cutoff_distance=30)
    print(dist.complete_pdf())

    # save distribution graph
    save_dist_graph(dist)

    # draw random sample
    sample_array = draw_sample(n_pairs=n_pairs, dist=dist, folder_name= paths.folder_name, folder_path= paths.folder_path)

    # create folder and clear contents
    make_folder(folder_name=paths.folder_name, folder_path=paths.folder_path)

    # delete old contents
    clear_folder(folder_name= paths.folder_name, folder_path= paths.folder_path)

    
    # draw matrices and return matrix details
    matrix_details = draw(
        sample= sample_array, 
        mat_dim= mat_dim, 
        folder_name= paths.folder_name,
        folder_path= paths.folder_path,
        url_dir= html_data.url_dir,
        img_size= html_data.img_size
        )
    
    # copy files to web hosting repo
    copy_folder(
        src_path= paths.folder_path, 
        src_folder= paths.folder_name, 
        dst_path= paths.hosting_path, 
        dst_folder= paths.folder_name
        )
    
    print(matrix_details)

    # save to csv
    export_details_to_csv(
        folder_path= paths.folder_path,
        folder_name= paths.folder_name,
        matrix_data= matrix_details
    )

    # export overall treatment and control details to csv
    export_control_treat_data(
        treat_dicts= matrix_details, 
        folder_path= paths.folder_path, 
        folder_name= paths.folder_name
    )


#*****************************************************************************
# main functionality
def main():
    constants = Constants(
        n_pairs = 10, 
        n_sets = 20,
        mat_dim = 10
        )
    
    for i in range(constants.n_sets):
        gen_matrix_pairs(mat_dim= constants.mat_dim, n_pairs= constants.n_pairs, set_num = i+1)















if __name__ == "__main__":
    main()



