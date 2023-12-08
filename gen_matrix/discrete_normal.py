from statistics import NormalDist
import pandas as pd
import matplotlib.pyplot as plt 
import numpy as np

# normal distribution with mean 50 and sd 10
class DiscreteNormal:
    # initialize the class: mean, sd of the continuous normal parent
    # and cutoff_distance is the distance of cutoff from mean  of the desired discrete distribution
    def __init__(self, mean, sd, cutoff_distance):
        self.mean = mean
        self.sd = sd 
        self.cutoff_distance = cutoff_distance
        self.lower_limit = mean - cutoff_distance
        self.upper_limit = mean + cutoff_distance
        # values in the support of the discrete distribution
        self.support = list(range(mean - cutoff_distance, mean + cutoff_distance + 1))
        self.support_size = len(self.support) # number of discrete values in the support
        self.cont_normal_dist = NormalDist(mu = mean, sigma= sd)
    def complete_pdf(self):
        self.cont_cdf = self.cont_normal_dist.cdf
        self.pdf = {}
        for i in self.support:
            pr_i = self.cont_cdf(i + 0.5) - self.cont_cdf(i - 0.5)
            self.pdf[i] = pr_i
        # correction for boundaries of the boundary values of the support
        # leftover density to be added
        discrepancy = 1 - sum(self.pdf.values())
        for num, prob in self.pdf.items():
            self.pdf[num] = prob + discrepancy/self.support_size
        # subtract or add the residual value 
        if sum(self.pdf.values()) != 1:
            self.pdf[self.mean] += 1 - sum(self.pdf.values())
     
        
        try:
            assert sum(self.pdf.values()) == 1
        except:
            print("Error: Sum of PDF does not equal to 1")
        return self.pdf
    def cdf(self, x):
        # prob(X <= x)
        cdf_x = 0
        if x not in self.support:
            raise ValueError
        for num, prob in self.pdf.items():
            if num != x:
                cdf_x += self.pdf[num]
            else:
                cdf_x += self.pdf[x]
                break
        return cdf_x
    def histogram(self, population=1000, extra = 20, show=True):
        # returns a histogram plotted by matplotlib
        if type(population) is not int:
            raise ValueError
        # first convert pdf dictionary to pd dataframe
        pdf_df = pd.DataFrame.from_dict(self.pdf, orient="index", columns=["p"]) # keys (support) are rows
        # add extra values at either end of the support
        start_df = pd.DataFrame.from_dict({x:0 for x in range(0, extra)}, orient="index", columns=["p"])
        # print(start_df)
        end_df = pd.DataFrame.from_dict({x:0 for x in range(self.upper_limit + 1, self.upper_limit + extra + 1)}, 
                                        orient="index", columns=["p"])
        # print(end_df)
        # multiply the probabilities by 1000 to get frequency histogram from a population of 1000
        pdf_df["p"] = pdf_df["p"].apply(lambda x: x*population)
        df = pd.concat([start_df, pdf_df, end_df])
        # print(df)
        fig, axs = plt.subplots(1, 1, figsize =(8, 8))
        axs.bar(x=df.index.tolist(), height = df["p"], width = 0.45)
        # change tick label size
        axs.tick_params(axis='both', which='major', labelsize=22)
        axs.tick_params(axis='both', which='minor', labelsize=22)

        if show is True:
            plt.show()
        return fig
    
    def sample(self, n_rows = 20, n_cols = 2):
        return np.random.choice(list(self.pdf.keys()), p = list(self.pdf.values()), size = (n_rows, n_cols))





        

        


