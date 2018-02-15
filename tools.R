library(ggplot2)
library(dplyr)
library(reshape2)
library(stringr)
library(lubridate)

#QQplot - Creates qq plot for assessment of normal distribution
qqnorm1 <- function(x){
	qqnorm(x)
	qqline(x)
}

#Calculate geometric mean
geom_mean <- function(vec, na.rm = FALSE) {
	exp(mean(log(vec), na.rm = na.rm))
}
