library(plotly)
library(ggplot2)

df = read.csv('GBvideos.csv')

feature_creation = function(df){
	df['like_rate'] = df['likes']/(df['likes']+df['dislikes'])
	df['dislike_rate'] = df['dislikes']/(df['likes']+df['dislikes'])
	df['like_rate_sq'] = df['like_rate']**2
	df['views_sq'] = df['views']**2
	return(df)
}

df = feature_creation(df) #create the new features

#Get some initial results
lin_reg1 = glm(views~like_rate, data = df)
lin_reg2 = glm(views~dislike_rate, data = df)
lin_reg3 = glm(like_rate~views+views_sq, data = df)
print(summary(lin_reg1))
print(summary(lin_reg2))
print(summary(lin_reg3))

#Print a scatter plot to get a clearer image
scatter_plot = plot_ly(name = 'Views/Likes scatter plot',
	data = df,
	y = ~views,
	x = ~likes) %>%
	layout(title = 'Views/Likes scatter plot')
print(scatter_plot)
#Histogram to see the distribution of the like rate
histogram = qplot(df$like_rate, geom="histogram", xlab = 'Like Rate', main = 'Distribution of like rates')
print(histogram)

#This function analyses whether hated views do better or worse
hate_drives_views = function(df, dislike_cutoff, views_cutoff){
	print(dislike_cutoff)
	highly_viewed = subset(df, df['views']>views_cutoff)
	highly_disliked = subset(highly_viewed, highly_viewed['dislike_rate']>dislike_cutoff)

	haters_lin_reg = glm(views~dislike_rate, data = highly_disliked)
	print(summary(haters_lin_reg))
}

#This function looks at the other end of the spectrum compared to the previous one
love_drives_views = function(df, like_cutoff, views_cutoff){
	highly_viewed = subset(df, df['views']>views_cutoff)
	highly_liked = subset(highly_viewed, highly_viewed['like_rate']> like_cutoff)

	likers_lin_reg1 = glm(views~like_rate, data = highly_viewed)
	likers_lin_reg2 = glm(views~like_rate, data = highly_liked)

	print(summary(likers_lin_reg1))
	print(summary(likers_lin_reg2))
}

hate_drives_views(df, 0.5, 5000)
love_drives_views(df, 0.6, 5000)
