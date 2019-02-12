import pandas as pd 

df = pd.read_csv('GBvideos.csv', error_bad_lines = False)

df_apple = df[df['tags'].str.contains('Apple' or 'apple')]
df_sung = df[df['tags'].str.contains('samsung' or 'Samsung')]

print((df_apple['title']))
print((df_sung['title']))

print(df_apple['views'].sum())
print(df_sung['views'].sum())