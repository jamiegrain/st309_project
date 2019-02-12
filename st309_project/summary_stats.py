import pandas as pd
import matplotlib.pyplot as plt 
import math
import numpy as np
# from matplotlib import style

# style.use('fivethirtyeight')

df = pd.read_csv('GBvideos.csv', error_bad_lines = False)
quant_df = df[['views', 'likes', 'dislikes', 'comment_total']]
print(quant_df.median(axis = 0))

quant_df.replace(to_replace = 0, value = 1, inplace = True)

quant_df.apply(np.log)

fig = plt.figure()
fig.suptitle('Summary Statistics (all values in log form)', fontsize = 16)

plt.subplot(2,2,1)
plt.hist(quant_df['views'], bins = 50, color = 'blue')
plt.title('Views')

plt.subplot(2,2,2)
plt.hist(quant_df['likes'], bins = 50, color = 'green')
plt.title('Likes')

plt.subplot(2,2,3)
plt.hist(quant_df['dislikes'], bins = 50, color = 'red')
plt.title('Dislikes')

plt.subplot(2,2,4)
plt.hist(quant_df['comment_total'], bins = 50, color = 'purple')
plt.title('Number of Comments')

plt.show()