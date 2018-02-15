	
### PATIENT DATA ==============================================
##Get HRV Analysis---------------------------------------------
df_pt <- left_join(df_pt, df_hrv, by = "anon_id")

#Calc mean variables for the four 5 min recordings.

summarise_vars <- function(df, var, index = 1:4, func = geom_mean){
  #creates a summary of variables for each subject. The default is geometric mean.
	select(df, num_range(var, index)) %>% 
		apply(1,func)
}
df_pt$mean_mean.HRV <- summarise_vars(df_pt, "mean.HRV_", func = mean) #Aritemetic mean of 4 measurements of HR. (HRV is due to a naming error from the kubios export)

df_pt$mean_std.RR <- summarise_vars(df_pt, "std.RR_") #std.RR = SDNN

df_pt$mean_LF.power <-  summarise_vars(df_pt, "LF.power_")

df_pt$mean_HF.power <- summarise_vars(df_pt, "HF.power_")

df_pt$mean_RMSSD <- summarise_vars(df_pt, "RMSSD_")

df_pt$mean_mean.RR <- summarise_vars(df_pt, "mean.RR_")

df_pt$mean_LF.HF.power <- summarise_vars(df_pt, "LF.HF.power_")

df_pt$mean_tot.power <- summarise_vars(df_pt, "tot.power_")

#Convet seconds to ms and use apropriate names
df_pt <- mutate(df_pt, 
    # 24 h analyses
		mean.RR_24 = mean.RR * 1000,
		SDNN_24 = std.RR * 1000,
		mean.HR_24 = mean.HRV,
		#std.HR_24 = std.HRV,
		RMSSD_24 = RMSSD * 1000,
		TINN_24 = TINN * 1000,
		LF.power_24 = LF.power * 1e6,
		HF.power_24 = HF.power * 1e6,
		LF.HF.power_24 = LF.HF.power,
		tot.power_24 = tot.power * 1e6,
		#5min
		mean.RR_5 = mean_mean.RR * 1000,
		mean.HR_5 = mean_mean.HRV,
		SDNN_5 = mean_std.RR * 1000,
		RMSSD_5 = mean_RMSSD * 1000,
		LF.power_5 = mean_LF.power * 1e6,
		HF.power_5 = mean_HF.power * 1e6,
		LF.HF.power_5 = mean_LF.HF.power,
		tot.power_5 = mean_tot.power * 1e6
		)

## Calculate GITT ----------------------------------------------
f_dd = 0.5 #fraction of dalily dose
dd = 10 #markers pr day
df_pt <- mutate(df_pt, mark_total = mark_R + mark_L + mark_RS,
	     gitt = (mark_total + f_dd*dd)/dd,
	     tt_R = mark_R/dd,
	     tt_L = mark_L/dd,
	     tt_RS = mark_RS/dd)

##Fim corrected for bowel score
df_pt$fim_no_bowel <- df_pt$fim - df_pt$fim_bowel

##Factor variables--------------
#Injury_cat to factor
# df_pt <- mutate(df_pt, inj_cat = factor(inj_cat, 
# 					levels = c(1,2,3,4,5),
# 					labels = c("TBI", "HemoragicStroke", "IschemicStroke", 
# 						   "SAH", "Anoxic")))

#Laxatives
df_pt$use_laxative <- factor(df_pt$use_laxative, levels = c("Y", "N"))


#Categorize injuries in focal and diffuse
focal_injs <- c("HemoragicStroke", "IschemicStroke")
df_pt$inj_focal <- ifelse(df_pt$inj_cat %in% focal_injs,
			  yes = "Focal",
			  no = "Diffuse")

### Test Variables
stopifnot(df_pt$fim == df_pt$fim_cog + df_pt$fim_motor) #tests that fim == motor + cog

