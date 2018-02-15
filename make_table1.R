### Generates table 1 tex file
library("xtable")
library("Gmisc")
library("Hmisc")

getStats <- function(varname, digits=0, type = "mean", data_df=df_pt, use_html = FALSE){
	if(type == "mean"){
		return(describeMean(data_df[[varname]],
				    html = use_html,
				    digits = digits,
				    plusmin_str = ""
				    ))
	}
	if(type == "prop"){
		return(describeProp(data_df[[varname]],
				    html = use_html,
				    digits = digits
		))
	}
	if(type == "factor"){
		return(describeFactors(data_df[[varname]],
				    html = use_html,
				    digits = digits
		))
	}
	if(type == "median"){
		return(describeMedian(data_df[[varname]],
				       html = use_html,
				       digits = digits
		))
	}
	if(type == "n"){
		counts <- length(data_df[[varname]])
		names(counts) <- "n"
		counts
	}
	else return("error: Type does not exist")
}
#Vectorized version of function. The second arg is the functionarguments to be vectorized.
vec_getStats <- Vectorize(getStats, c("varname", "type", "digits")) 



##Genereates list from vectors of variable names and summarytype. ... is used to pass
#use_html = T/F and digits to vec_getStats()
make_list_data <- function(var_vector, type_vector, name_vector = var_vector, 
			   use_html = FALSE, ...){
	temp_list <- list()
	
	temp_list[name_vector] <- vec_getStats(var_vector, 
		type = type_vector, use_html = use_html,
		...)
	
	temp_list <- lapply(temp_list, as.matrix)
	
	if (use_html) {
		return(lapply(temp_list, function(x) {
			colnames(x) <- "Statistics" #Adds the same colname to all list items
			#Nesessary to use mergeDesc()
			return(x)
		}))
	}
	else {
		return(temp_list)
	}
	
}

vars_in_table_pt <- c("anon_id", "sex", "age", "days_since_inj", "fim", "inj_cat",
		      "use_laxative", "gitt")
names_in_table_pt <- c("Total", "Sex", "Age", "Days since injury", "FIM score",
		       "Type of injury", "Laxative use", "Total GITT")
types_in_table_pt <- c("n","factor", "median", "median", "median",
		       "factor", "factor", "mean")

table_data_pt <- make_list_data(vars_in_table_pt,
	  types_in_table_pt,
	  names_in_table_pt,
	  data_df = df_pt,
	  digits = c(0, 0, 1, 0, 0, 0, 0, 2),
	  use_html = FALSE)

table_data_html_pt <- make_list_data(vars_in_table_pt,
			     types_in_table_pt,
			     names_in_table_pt,
			     data_df = df_pt,
			     digits = c(0, 0, 1, 0, 0, 0, 0, 2),
			     use_html = TRUE)


vars_in_table_cnt <- c("sex", "sex", "age", "use_laxative", "gitt")
names_in_table_cnt <- c("Total", "Sex", "Age","Laxative use", "Total GITT")
types_in_table_cnt <- c("n","factor", "median", "factor", "mean")

table_data_cnt <- make_list_data(vars_in_table_cnt,
				 types_in_table_cnt,
				 names_in_table_cnt,
				 data_df = df_cnt,
				 digits = c(0,0,1,0,2),
				 use_html = FALSE)

table_data_html_cnt <- make_list_data(vars_in_table_cnt,
				 types_in_table_cnt,
				 names_in_table_cnt,
				 data_df = df_cnt,
				 digits = c(0,0,1,0,2),
				 use_html = TRUE)

