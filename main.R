#Included patients
source("tools.R")

# Load Data 
path_pt <- "anonymized_data/patient_data_anon.csv"
path_cnt <- "anonymized_data/control_data_anon.csv"
path_pt_hrv <- "anonymized_data/hrv_data_anon.csv"

df_pt <- read.csv(path_pt, stringsAsFactors = FALSE) %>% tbl_df()
df_cnt <- read.csv(path_cnt, stringsAsFactors = FALSE) %>% tbl_df()
df_hrv <- read.csv(path_pt_hrv, stringsAsFactors = FALSE) %>% tbl_df()

source("variables.R")
source("results_gitt.R")
source("results_hrv.R")
source("make_table1.R")
source("gen_plots_article.R")
