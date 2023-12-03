import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
from matplotlib import colors
from matplotlib.ticker import PercentFormatter
 
# Creating dataset
np.random.seed(23685752)
N_points = 100
n_bins = 20
 
# Creating distribution
x = np.random.randn(N_points)
y = .8 ** x + np.random.randn(100) + 25
df = pd.DataFrame(x, y)
print(df)
# Creating histogram
fig, axs = plt.subplots(1, 1,
                        figsize =(10, 7), 
                        tight_layout = True)
 
axs.hist(df, bins = n_bins)
 
# Show plot
plt.show()