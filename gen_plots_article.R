#Gennerete plots for article

#Plots depends on resuts.R
library(ggplot2)

if(!exists("df_pt")) source("main.R")
article_plot_folder <- "Plots/article"

# Add group: pt with laxative use
new_grp <- ifelse(short_data$use_laxative == "Y", "pt_lax", short_data$grp) %>% 
	factor(levels = c("pt", "pt_lax", "cnt"))
short_data_plots <- mutate(short_data, grp = new_grp)

#Set Color and theme for all plots 
	#colors
	grp_colors <- c(pt = "#FF6138",
			cnt = "#00A388")
	grp_fills <- c(pt = "#000000",
			cnt = "#FFFFFF")
	grp_shapes <- c(pt = 19,
			cnt = 1)
	grp_labels <- c(pt = "Patient with ABI",
			cnt = "Control")
	grp_lax_shapes <- c(pt = 19,
			pt_lax = 17,
			cnt = 1)

	grp_lax_labels <- c(pt = "Patient, no laxative use",
			pt_lax = "Patient, with laxative use",
			cnt = "Control, no laxative use")
	
	theme_set(theme_minimal(base_size = 10) + 
		  	theme(panel.grid.minor = element_blank(),
		  	      axis.title = element_text(size = 8)))

#Apply group colors to scales
grp_col_scale <- scale_colour_manual(name = "Group",values = grp_colors,
				     breaks = names(grp_labels),
				     labels = grp_labels)

grp_fill_scale <- scale_fill_manual(name = "Group",values = grp_fills,
				    breaks = names(grp_labels),
				    labels = grp_labels)

grp_lax_shape_scale <- scale_shape_manual(name = "",values = grp_lax_shapes,
				       breaks = names(grp_lax_labels),
				       labels = grp_lax_labels)


#Default scales
gitt_scale <- scale_y_continuous(limits = c(0,6), breaks = 0:6)


#Scatter plots
plot_gitt_age <- ggplot(short_data_plots, aes(age, gitt, shape = grp)) + 
    geom_point() + grp_lax_shape_scale + gitt_scale + 
    labs(x = "Age [years]", y = "GITT [days]") + 
    theme(legend.position = c(0.2, 0.8)) + 
    theme(legend.background = element_rect(fill = "white", color = "white"))
plot_gitt_age

plot_gitt_age_lm <- plot_gitt_age +
	geom_smooth(method="lm", se = FALSE)
plot_gitt_age_lm

gitt_age_lm_effectmod <- lm(gitt~age*grp, data = short_data)

gitt_age_lm <- lm(gitt~age + grp, data=short_data)

plot_gitt_age_lm_equal <- plot_gitt_age +
	geom_line(aes(y = pred), data = cbind(short_data, pred = predict(gitt_age_lm)),
		  size = 1)
plot_gitt_age_lm_equal

plot_gitt_age_pt <- ggplot(df_pt, aes(age, gitt)) + 
	geom_point(size=2, color = grp_colors["pt"]) + 	grp_col_scale +
	labs(x = "Age [years]", y = "GITT [days]")


plot_log_gitt_age <- plot_gitt_age +
	scale_y_log10(breaks = c(0.5, 1, 2, 5), limits=c(0.5, 6),
		      minor_breaks = seq(0.5, 5, by = 0.1))

# Plot of HRV results (HF)
other_hrv <- data.frame(group = c("This study", "Semi-intensive care", "Healthy controls"),
			mean_HF = c(90.7, 8.9, 290),
			lwr = c(50.5, 5.4, 211),
			upr = c(162.6, 14.8, 399))
plot_other_hrv <- ggplot(other_hrv, aes(group, mean_HF)) +
	geom_point() + 
	geom_errorbar(aes(x = group, ymin = lwr, ymax = upr), width = 0.3) +
	scale_x_discrete(limits = c("Semi-intensive care", "This study", "Healthy controls"),
			 labels = c("Patients with ABI, \nsemi-intensive care",
			 	   "Patients with ABI, \nthis study",
			 	   "Healthy controls"),
			 name = "") +
	scale_y_log10(breaks = c(1,10,100,1000), limits = c(1,1000),
		      name = "HF power [ms^2]")
plot_other_hrv			

#Export
if(FALSE) {
	ggsave("gitt_age.pdf", path = article_plot_folder, plot = plot_gitt_age, 
	       width = 10, height = 7, units = "cm")

	ggsave("log_gitt_age.pdf", path = article_plot_folder, plot = plot_log_gitt_age, 
	       width = 10, height = 7, units = "cm")

	ggsave("hrv_other.pdf", path = article_plot_folder, plot = plot_other_hrv, 
	       width = 10, height = 7, units = "cm")
	
	ggsave("gitt_age.eps", path = article_plot_folder, plot = plot_gitt_age, 
	       width = 10, height = 7, units = "cm")
	
	ggsave("log_gitt_age.eps", path = article_plot_folder, plot = plot_log_gitt_age, 
	       width = 10, height = 7, units = "cm")
	
	ggsave("hrv_other.eps", path = article_plot_folder, plot = plot_other_hrv, 
	       width = 10, height = 7, units = "cm")
	
}
