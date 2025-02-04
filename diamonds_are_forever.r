---
output:
  pdf_document: default
  html_document: default
---
Lesson 6
========================================================

### Welcome
Notes:

***

### Scatterplot Review

```{r Scatterplot Review}

library('ggplot2')
data(diamonds)

ggplot(data = diamonds, aes(carat, price)) +
  geom_point()

ggplot(data = diamonds, aes(carat, price)) +
  scale_x_continuous(lim = c(0, quantile(diamonds$carat, 0.99))) +
  scale_y_continuous(lim = c(0, quantile(diamonds$price, 0.99))) +
  geom_point(fill = I('#F79420'), color = I('black'), shape = 21)
 # with(diamonds, cor.test(price, carat))



#  add smooth line

ggplot(data = diamonds, aes(carat, price)) +
  scale_x_continuous(lim = c(0, quantile(diamonds$carat, 0.99))) +
  scale_y_continuous(lim = c(0, quantile(diamonds$price, 0.99))) +
  geom_point(color = I('#F79420'), alpha = 1/4, shape = 21) +
  stat_smooth(method = 'lm') 
# put the trend line first and it was buried underneath the points

#add trendline to check how well the data fits around the trend line (linear trendline)

#notice how the linear trendline is not aligned with the data in some key places where the line should be lower and higher


 # with(diamonds, cor.test(price, carat))

```

***

### Price and Carat Relationship
Response:

***
Exponential non-linear patter. Blocks at every whole number

### Frances Gerety
Notes:


#### A diamonds is


***

### The Rise of Diamonds
Notes:

***

### ggpairs Function
Notes:
lower triangle ->
 grouped histograms -> qual/qual pairs
 scatter plots -> quant/quant pairs
 
upper triangle -> 
 grouped histograms -> qual/qual (x value for grouping pairs)
 boxplot -> qual/quant pairs

diagonal = corrs for quant/quant pairs

```{r ggpairs Function}
# install these if necessary
# install.packages('GGally')
# install.packages('scales')
# install.packages('memisc') #summarise regression
# install.packages('lattice')
# install.packages('MASS')
# install.packages('car') #recode variables
# install.packages('reshape') #reshape/wrangle
# install.packages('plyr') #summaries/transforms

# load the ggplot graphics package and the others
library(ggplot2)
library(GGally)
library(scales)
library(memisc)

# sample 10,000 diamonds from the data set
set.seed(20022012)
diamond_samp <- diamonds[sample(1:length(diamonds$price), 10000), ]
ggpairs(diamond_samp)

help("wrap", package = "GGally")


```

What are some things you notice in the ggpairs output?
Response:
Price/Clarity | Price/Colour
Critical factor is the carat (size)
***

### The Demand of Diamonds
Notes:
Price/Size - nonlinear
Often the case that using substantive knowledge can lead to fruitful transformations

Path dependence
Multiplicative processes like year on year inflation

The distribution monetary variable will be highly skewed due to path dependence or multiplicative processes. 
Good idea to look into compressing any such variable
by putting it on a log scale. (Research later*)

```{r The Demand of Diamonds}

plot1 <- ggplot(data = diamonds, aes(price)) +
  geom_histogram(binwidth = 100, fill = I('#099DD9')) + 
  ggtitle("Price")

plot2 <- ggplot(data = diamonds, aes(price)) +
  geom_histogram(binwidth = 0.01, fill = I('#F79420')) + 
  scale_x_log10()
  ggtitle("Price (log10)")

library(gridExtra)
library(grid)
grid.arrange(plot1, plot2, ncol = 2)
  
```

***

### Connecting Demand and Price Distributions
Notes:
The raw prices are skewed to the right. With a long tail.

The log10 distribution is closer to a normal distribution. Also showing signs of bimodality; where there may be two different sets of consumers who purchase at drastically different price points.

***

### Scatterplot Transformation

```{r Scatterplot Transformation}

ggplot(data = diamonds, aes(carat, price)) +
  geom_point(fill = I('#F79420')) + 
  scale_y_continuous(trans = log10_trans())
  ggtitle("Price (log10) by Carat")
  
  # because carats are measuring volume, we are getting exp. dispersion, so let's use the cubed root of carat cutting el*w*h

```


### Create a new function to transform the carat variable

```{r cuberoot transformation}
cuberoot_trans = function() trans_new('cuberoot', transform = function(x) x^(1/3),inverse = function(x) x^3)
```

#### Use the cuberoot_trans function
```{r Use cuberoot_trans}
ggplot(aes(carat, price), data = diamonds) + 
  geom_point() + 
  scale_x_continuous(trans = cuberoot_trans(), limits = c(0.2, 3),
                     breaks = c(0.2, 0.5, 1, 2, 3)) + 
  scale_y_continuous(trans = log10_trans(), limits = c(350, 15000),
                     breaks = c(350, 1000, 5000, 10000, 15000)) +
  ggtitle('Price (log10) by Cube-Root of Carat')
```

***

### Overplotting Revisited

```{r Sort and Head Tables}
head(sort(table(diamonds$carat), decreasing = T))
head(sort(table(diamonds$price), decreasing = T))

```


```{r Overplotting Revisited}
ggplot(aes(carat, price), data = diamonds) + 
  geom_jitter(alpha = 5/20, size = 0.75, position = 'jitter') + 
  scale_x_continuous(trans = cuberoot_trans(), limits = c(0.2, 3),
                     breaks = c(0.2, 0.5, 1, 2, 3)) + 
  scale_y_continuous(trans = log10_trans(), limits = c(350, 15000),
                     breaks = c(350, 1000, 5000, 10000, 15000)) +
  ggtitle('Price (log10) by Cube-Root of Carat')
```

***

### Other Qualitative Factors
Notes:
Use domain knowledge to understand features from consumers and makers. 
***

### Price vs. Carat and Clarity

Alter the code below.
```{r Price vs. Carat and Clarity}
# install and load the RColorBrewer package
# install.packages('RColorBrewer')
library(RColorBrewer)
?geom_point
ggplot(aes(x = carat, y = price), data = diamonds) + 
  geom_point(aes(color = clarity), alpha = 0.5, size = 1, position = 'jitter') +
  scale_x_continuous(trans = cuberoot_trans(), limits = c(0.2, 3),
    breaks = c(0.2, 0.5, 1, 2, 3)) + 
  scale_y_continuous(trans = log10_trans(), limits = c(350, 15000),
    breaks = c(350, 1000, 5000, 10000, 15000)) +
  ggtitle('Price (log10) by Cube-Root of Carat and Clarity')
```

***

### Clarity and Price
Response:
Clarity has a positive relationship with price as the classes typically remain consistently stratified at the same relative price levels as the carats increase. 
***

### Price vs. Carat and Cut

Alter the code below.
```{r Price vs. Carat and Cut}
ggplot(aes(x = carat, y = price, color = cut), data = diamonds) + 
  geom_point(alpha = 0.5, size = 1, position = 'jitter') +
  scale_color_brewer(type = 'div',
                     guide = guide_legend(title = 'Cut ', reverse = T,
                                          override.aes = list(alpha = 1, size = 2))) +  
  scale_x_continuous(trans = cuberoot_trans(), limits = c(0.2, 3),
                     breaks = c(0.2, 0.5, 1, 2, 3)) + 
  scale_y_continuous(trans = log10_trans(), limits = c(350, 15000),
                     breaks = c(350, 1000, 5000, 10000, 15000)) +
  ggtitle('Price (log10) by Cube-Root of Carat and Clarity')
```

***

### Cut and Price
Response:
Most of the data seems to be ideal/premium so there
isn't much stratification diversity here as it looks outweighed by the sheer amount of higher end cuts. 

***

### Price vs. Carat and Color

Alter the code below.
```{r Price vs. Carat and Color}
ggplot(aes(x = carat, y = price, color = color), data = diamonds) + 
  geom_point(alpha = 0.5, size = 1, position = 'jitter') +
  scale_color_brewer(type = 'div',
                     guide = guide_legend(title = 'Color', reverse = F,
                                          override.aes = list(alpha = 1, size = 2))) +  
  scale_x_continuous(trans = cuberoot_trans(), limits = c(0.2, 3),
                     breaks = c(0.2, 0.5, 1, 2, 3)) + 
  scale_y_continuous(trans = log10_trans(), limits = c(350, 15000),
                     breaks = c(350, 1000, 5000, 10000, 15000)) +
  ggtitle('Price (log10) by Cube-Root of Carat and Color')
```

***

### Color and Price
Response:
Yes, colour does seem to influece price, but it is also closely related to clarity, but doesn't seem semantically related.
***

### Linear Models in R
Notes:
predict with the lm() function

lm (y~x)
outcome variable = y
explanatory variable = x
price ~ carat
log(price) ~ carat^(1/3)

Response:
log(price) ~ carat^(1/3)

***

### Building the Linear Model
Notes:

```{r Building the Linear Model}
# using the I wrapper ( I() ) variables, it is there to tell R to use the expression before using the regression.
m1 <- lm(I(log(price)) ~ I(carat^(1/3)), data = diamonds)
m2 <- update(m1, ~ . + carat)
m3 <- update(m2, ~ . + cut)
m4 <- update(m3, ~ . + color)
m5 <- update(m4, ~ . + clarity)
mtable(m1, m2, m3, m4, m5)

```

Notice how adding cut to our model does not help explain much of the variance
in the price of diamonds. This fits with our exploration earlier.

***

### Model Problems
Video Notes:

Research:
(Take some time to come up with 2-4 problems for the model)
(You should 10-20 min on this)

Since we are including each of the features/vars, we may have some innerdependence that could overlap and be better outside the model. Finding the principal components might be key here. 
Using all the features may result in overfitting and only work on a very specific dataset.  
We didn't include inflation rate or cultural trends that may be occuring because of this. 

Response:

***

### A Bigger, Better Data Set
Notes:

```{r A Bigger, Better Data Set}
# install.packages('bitops')
# install.packages('RCurl')
library('bitops')
library('RCurl')

diamondsurl = '/Users/christianramsey/PycharmProjects/udacity/data\ analyst/P4\ Explore\ and\ Summarize\ Data/EDA_Course_Materials/lesson6/BigDiamonds.Rda'
load((diamondsurl))
```

The code used to obtain the data is available here:
https://github.com/solomonm/diamonds-data

## Building a Model Using the Big Diamonds Data Set
Notes:

```{r Building a Model Using the Big Diamonds Data Set}

diamondsbig$logprice = log(diamondsbig$price)
m1 <- lm(logprice ~ I(carat^(1/3)),
         data = diamondsbig[diamondsbig$price < 10000 & diamondsbig$cert == "GIA",])
m2 <- update(m1, ~ . + carat)
m3 <- update(m2, ~ . + cut)
m4 <- update(m3, ~ . + color)
m5 <- update(m4, ~ . + clarity)
mtable(m1, m2, m3, m4, m5)
```


***

## Predictions
we need to expontiate the result of our model since we took the log of price

Example Diamond from BlueNile:
Round 1.00 Very Good I VS1 $5,601

```{r}
#Be sure you’ve loaded the library memisc and have m5 saved as an object in your workspace.
thisDiamond = data.frame(carat = 1.00, cut = "V.Good",
                         color = "I", clarity="VS1")
modelEstimate = predict(m5, newdata = thisDiamond,
                        interval="prediction", level = .95)
```

Evaluate how well the model predicts the BlueNile diamond's price. Think about the fitted point estimate as well as the 95% CI.

***

## Final Thoughts
Notes:

***

