library(ggplot2)
library(plotly)
library(tree)

df = read.csv('GBvideos.csv')

#Creating an empty dataframe for our new variables
avg_views_by_cat = matrix(0, ncol = 7, nrow = 29)
avg_views_by_cat= data.frame(avg_views_by_cat)

#Variable creation based on category data
for (category in 1:29){
	#avg views by category
	avg_views_by_cat[category, 1] = mean(df['views'][df['category_id']==category])
	#avg likes by category
	avg_views_by_cat[category, 2] = mean(df['likes'][df['category_id']==category])
	#avg dislikes by category
	avg_views_by_cat[category, 3] = mean(df['dislikes'][df['category_id']==category])
	#avg number of likes + dislikes by category (active views)
	avg_views_by_cat[,4] = avg_views_by_cat[,2] + avg_views_by_cat[,3]
	#avg number of passive views by category
	avg_views_by_cat[,5] = avg_views_by_cat[,1] - avg_views_by_cat[,4]
	#% active views
	avg_views_by_cat[,6] = avg_views_by_cat[,4] / avg_views_by_cat[,1]
	#avg comments per video by category
	# avg_views_by_cat[category, 7] = mean(c(df['comment_total'][df['category_id']==category]))	
}

#Remove the couple of missing values
avg_views_by_cat = na.omit(avg_views_by_cat)

#Convert the category dummies back to their real names
category_names = data.frame(c("Film & Animation",
	"Autos & Vehicles",
	"Music",
	"Pets & Animals",
	"Sports",
	"Travel & Events",
	"Gaming",
	"People & Blogs",
	"Comedy",
	"Entertainment",
	"News & Politics",
	"Howto & Style",
	"Education",
	"Science & Technology",
	"Misc."
	))

names(category_names) = 'category_names'

avg_views_by_cat = data.frame(category_names, avg_views_by_cat)
print(head(avg_views_by_cat))

#Produce a bar chart for the number of active/passive views
bar1 = plot_ly(avg_views_by_cat,
	name = 'Avg Number of active views',
	x = ~category_names,
	y = ~V4,
	type = "bar") %>%
	add_trace(y = ~V5, name = 'Avg Number of passive views') %>%
	# add_trace(y = ~X3, name = 'Avg dislikes') %>%
	
	layout(title = "Average views of GB Trending Videos by Category",
         xaxis = list(title = ""),
         yaxis = list(title = ""),
         barmode = 'stack')

print(bar1)

quant_df = na.omit(data.frame(df['category_id'], df['views'], df['likes'], df['dislikes'], df['comment_total']))

#Creating data for a num videos per category bar chart
vids_per_cat = function(quant_df){
	videos_per_cat = matrix(0, nrow = 29, ncol = 1)
	for (category in 1:29){
		for (i in 1:nrow(quant_df)){
			if (quant_df[i, 'category_id'] == category){
				videos_per_cat[category] = videos_per_cat[category] + 1
			}
		}
	}
	videos_per_cat = data.frame(videos_per_cat)
	videos_per_cat = videos_per_cat[c(1,2,10,15,17,19,20,22,23,24,25,26,27,28,29),]
	return(na.omit(videos_per_cat))
}

videos_per_cat = vids_per_cat(quant_df)

videos_per_cat = data.frame(category_names, videos_per_cat)

#Create a bar chart to show the number of videos per category
bar2 = plot_ly(videos_per_cat,
	name = 'Total number of Videos',
	x = ~category_names,
	y = ~videos_per_cat,
	type = "bar",
	color = 'green') %>%
	layout(title = "Total Number of GB Trending Videos by Category",
         xaxis = list(title = ""),
         yaxis = list(title = ""))

print(bar2)


quant_1hot_df = read.csv('1hotnumdata.csv')


#Set aside a test set
set.seed(42)
n_total = nrow(quant_1hot_df)
ntrain = floor(0.8 * n_total)
ntest = floor(0.2 * n_total)
index = seq(1:n_total)
trainIndex = sample(index, ntrain)
testIndex = index[-trainIndex]

train = quant_1hot_df[trainIndex,]
test = quant_1hot_df[testIndex,]
test_unlabeled = subset(test, select =  -c(views))
test_labels = test['views']

#Build Tree
mdl = tree(views~., data = train)
print(summary(mdl))

#calculate MSE for test set
preds = predict(mdl, test_unlabeled)
mse_list = ((preds - test_labels)**2)/length(preds)
mse = sum(mse_list)
print(mse) #Big number