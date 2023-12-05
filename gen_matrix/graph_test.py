# import matplotlib.pyplot as plt
# import numpy as np
# import pandas as pd
# from matplotlib import colors
# from matplotlib.ticker import PercentFormatter
 
# # # Creating dataset
# # np.random.seed(23685752)
# # N_points = 100
# # n_bins = 20
 
# # # Creating distribution
# # x = np.random.randn(N_points)
# # y = .8 ** x + np.random.randn(100) + 25
# # df = pd.DataFrame(x, y)
# # print(df)
# # # Creating histogram
# # fig, axs = plt.subplots(1, 1,
# #                         figsize =(10, 7), 
# #                         tight_layout = True)
 
# # axs.hist(df, bins = n_bins)
 
# # # Show plot
# # plt.show()

# def func():
#     print("Hello")

# class MyClass:
#     def hi(self):
#         print("Hi")


from dn_matrix import DotMatrix as Mat
mat = Mat(39)
mat.draw_half(half_pos="top")
mat.save(filename="test2", folder_name="")
mat.draw_half(half_pos="bottom")
mat.save(filename="test3", folder_name="")
mat.draw_complete()
mat.save(filename="test4", folder_name="")


mat = Mat(69)
mat.draw_half(half_pos="top")
mat.save(filename="test5", folder_name="")
mat.draw_half("bottom")
mat.save(filename="test6", folder_name="")
mat.draw_complete()
mat.save(filename="test7", folder_name="")