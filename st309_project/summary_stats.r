df = read.csv('GBvideos1.csv')
quant_df = data.frame(df['category_id'], df['views'], df['likes'], df['dislikes'], df['comment_total'])

print(mean(df['comment_total']))