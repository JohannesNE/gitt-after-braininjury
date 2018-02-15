#HRV results ------------
library(stargazer)
library(tidyr)
library(Hmisc)

# Select only relevant HRV variables
df_hrv_ms <- transmute(df_pt, anon_id,
		 mean.HR_24,
		 SDNN_24,
		 RMSSD_24, 
		 LF.power_24,
		 HF.power_24,
		 LF.HF.power_24,
		 tot.power_24,
		 mean.HR_5,
		 SDNN_5,
		 RMSSD_5,
		 LF.power_5,
		 HF.power_5,
		 LF.HF.power_5,
		 tot.power_5)

# Reshape to long format
df_hrv_long <- gather(df_hrv_ms, key = variable, value = value, na.rm = TRUE,
		      -anon_id )

#generate type variable (5min/24h) depending on variable. variables beginning
#with mean_ are 5min
#Remove mean_
df_hrv_long <- mutate(df_hrv_long, type = ifelse(grepl("_5$", variable), "5min", "24H"),
		      variable = str_replace(variable, "^(.*)_5$", "\\1"))

log_ci <- function(vec) {
	test <- t.test(log(vec))
	exp(test$conf.int) %>% as.numeric()
}
ci <- function(vec) {
	test <- t.test(vec)
	test$conf.int %>% as.numeric()
}

# geometric mean + confidence interval of hrv measurements calculated using log transformation
hrv_table_log <- df_hrv_long %>% 
	group_by(type, variable) %>% 
	summarise(n = n(), geom_mean_value = geom_mean(value), 
		  lwr_exp = log_ci(value)[1], upr_exp = log_ci(value)[2])

# Arithmetic mean and confidence interval (only appropriate for HR)
hrv_table_linear <- df_hrv_long %>% 
	group_by(type, variable) %>% 
	summarise(n = n(), mean_value = mean(value), 
		  lwr = ci(value)[1], upr = ci(value)[2])


#Correlation table

#Calculate result string consisting of coef and p-value
cor_p <- function(vec1, vec2, print_p = FALSE, ...){
	cor_res <- cor.test(vec1, vec2, ...)
	p_star = ""
	
	if(cor_res$p.value < 0.01) p_star <- "^{**}"
	else if(cor_res$p.value < 0.05)	p_star <- "^{*}"
	
	if (print_p) sprintf("$%.3f, p = %.3f$", cor_res$estimate, cor_res$p.value) #For specific p value
	else sprintf("$%.3f%s$", cor_res$estimate, p_star)
	
}
cor_p <- Vectorize(cor_p)

log_hrv_values <- transmute(df_pt,
			    HR = mean.HR_5,
			    `log(SDNN)` = log(SDNN_5), 
			    `log(RMSSD)` = log(RMSSD_5), 
			    `log(HF power)` = log(HF.power_5), 
			    `log(LF power)` = log(LF.power_5), 
			    `log(LF/HF)` = log(LF.HF.power_5))

cor.table.per <- outer(log_hrv_values, select(df_pt, gitt, age), 
		       FUN = cor_p, method = "pearson")

cor.table.spe <- outer(log_hrv_values, 
	select(df_pt, fim), FUN = cor_p, method = "spearman")

cor.table <- cbind(cor.table.per, cor.table.spe)

#With p values

cor.table.per_p <- outer(log_hrv_values, select(df_pt, gitt, age), 
		       FUN = cor_p, print_p = TRUE, method = "pearson")

cor.table.spe_p <- outer(log_hrv_values, select(df_pt, fim), 
			FUN = cor_p, print_p = TRUE, method = "spearman")

# Correlation table with pearson correlation for gitt and age, spearman for fim (table 4)
cor.table_p <- cbind(cor.table.per_p, cor.table.spe_p)

cor.table.per.all <- outer(log_hrv_values, select(df_pt, gitt, age, fim), 
			     FUN = cor_p, print_p = FALSE, method = "pearson")

# Generate latex correlation tables (table 4)
(cor_pearson <- latex(cor.table.per.all, file = "", 
      caption = "Correlations between outcome measures for 5 min HRV analyses and GITT, age and FIM",
      label = "cor_table",
      rowlabel = "",
      colheads = c("GITT", "Age", "FIM"),
      #Add footnote with dagger
      insert.bottom = "{\\footnotesize $^{*}$p$<$0.05; $^{**}$p$<$0.01 \\newline
All coefficients are Pearson's product-moment correlation ($r$). \\newline
      HRV, Heart rate variability; GITT, Gastrointestinal transit time; FIM, Functional independence measure.}",
      booktabs = TRUE
))

cor_w_spearman <- latex(cor.table, file = "", 
      caption = "Correlations between HRV and GITT",
      label = "cor_table",
      rowlabel = "",
      colheads = c("GITT$^\\dagger$", "Age$^\\dagger$", "FIM$^\\ddagger$"),
      #Add footnote with dagger
      insert.bottom = "{\\footnotesize $^{*}$p$<$0.05; $^{**}$p$<$0.01 \newline
$^\\dagger$Pearson's product-moment correlation \\newline
      $^\\ddagger$Spearman's rank correlation}",
      booktabs = TRUE
      )
	

