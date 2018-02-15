# results depends on main.R
library(broom)
library(stargazer)

#Condensed df
cond_df_pt <- select(df_pt, sex, age, inj_cat, days_since_inj, gitt, fim, RMSSD,use_laxative)

#Make shared DF
df_cnt$grp <- "cnt"
df_cnt$use_laxative <- "N" #No controls use laxatives
short_data_pt <- transmute(df_pt, sex, age, gitt, grp="pt", use_laxative)
short_data <- rbind(short_data_pt, df_cnt)

#Relevel lax
short_data$use_laxative <- relevel(short_data$use_laxative, ref = "N")

#calc mean gitt and CI
#by group
#calc mean and CI
gitt_mean_grp <- short_data %>% 
	group_by(grp) %>% 
	do(tidy(t.test(.$gitt)))

#by sex
gitt_mean_sex <- short_data %>% 
	group_by(sex) %>% 
	do(tidy(t.test(.$gitt)))

#t.test
(t_test_gitt_grp <- t.test(gitt~grp, data = short_data)) %>% tidy

t_test_gitt_sex <- t.test(gitt~sex, data = short_data) #Ikke signifikant

#Linear model (table 2)
gitt_age_sex_lm <- lm(gitt ~ grp + age + sex, data = short_data)
summary(gitt_age_sex_lm)


