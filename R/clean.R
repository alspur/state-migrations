# clean.R
# 2017-11-18

# load -------------

# load packages
library(tidyverse)
library(readxl)

# read table 1 - summary of migration ages 1+ -------------
move_total_04 <- read_xls("data/state_migration_flows_tables.xls")

# read table 5 - age 65+ -------------

move_sr_04 <- read_xls("data/state_migration_flows_tables.xls", sheet = 6)

# read table 6 - foreign born ------------

move_foreign_04 <- read_xls("data/state_migration_flows_tables.xls", sheet = 8)

# read table 7 - young, single, college educated ----------

move_college_04 <- read_xls("data/state_migration_flows_tables.xls", sheet = 10)

# appendix a - by prior state residence ------------

move_state_04 <- read_xls("data/state_migration_flows_tables.xls",
                          sheet = 12, skip = 4)
move_state_05 <- read_xls("data/state_to_state_migrations_table_2005.xls",
                          skip =6)


# reshape state movement data --------------

move_04_clean <- move_state_04 %>% 
  rename(current_state = X__1) %>% 
  select(-starts_with("X")) %>% 
  filter(!is.na(current_state)) %>% 
  filter(!str_detect(current_state, "Source")) %>% 
  filter(!str_detect(current_state, "MOE")) %>% 
  gather(prior_state, total, -current_state) %>% 
  mutate(total = as.numeric(total), year = 2004)

move_05_clean <- move_state_05 %>% 
  rename(current_state = X__1) %>% 
  select(-starts_with("X")) %>% 
  filter(!is.na(current_state)) %>% 
  filter(!str_detect(current_state, "Source")) %>% 
  filter(!str_detect(current_state, "MOE")) %>% 
  filter(!str_detect(current_state, "Footnote")) %>%
  filter(!str_detect(current_state, "Current")) %>% 
  gather(prior_state, total, -current_state) %>% 
  mutate(total = as.numeric(total), year = 2004)

