library(ggplot2)
library(plotly)

df = read.csv('GBvideos.csv')

feature_creation = function(df){
	df['like_rate'] = df['likes']/(df['likes']+df['dislikes'])
	df['dislike_rate'] = df['dislikes']/(df['likes']+df['dislikes'])
	return(df)
}

df = feature_creation(df)

# lin_reg1 = glm(views~., data = df)
# print(summary(lin_reg1))

hate_drives_views = function(df, dislike_cutoff, views_cutoff){
	print(dislike_cutoff)
	highly_viewed = subset(df, df['views']>views_cutoff)
	highly_disliked = subset(highly_viewed, highly_viewed['dislike_rate']>dislike_cutoff)
	highly_liked = subset(highly_viewed, highly_viewed['like_rate']>0.5)

	print(cor(highly_disliked['dislike_rate'], highly_disliked['views']))
	print(cor(highly_liked['like_rate'], highly_liked['views']))

	haters_lin_reg = glm(views~dislike_rate, data = highly_disliked)
	likers_lin_reg = glm(views~like_rate, data = highly_liked)
	print(summary(lin_reg1))
	print(summary(lin_reg2))
}

# hate_drives_views(df, 0.5, 1000)

# for(i in seq(0.1,0.9,0.1)){
# 	hate_drives_views(df, i, 1000)
# }

# quant_df = data.frame(df['category_id'], df['views'], df['likes'], df['dislikes'], df['comment_total'])
# print(head(quant_df))