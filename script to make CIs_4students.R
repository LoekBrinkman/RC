#script to make CIs
#Loek Brinkman 2019

# load the relevant packages
library(tidyverse)
library(rcicr)
library(stringr)
library(readxl)

#clear environment - start with a clean sheet
rm(list=ls())

### step 1: load the data 
#set the directory where to data is located
setwd("~/ci script")

#load data
dat <- read_csv2('data_exp_7614-v16_task-zaz4.csv')

dat <- dat %>% select(`Participant Public ID`, Response, display) %>% #select the Response column
  filter(!is.na(Response) & Response != "null") %>% #remove rows that don't code for stimuli 
  filter(display == "Choose") %>% 
  mutate(Response_binary = ifelse(Response == 'Foto 1', 1, -1)) #recode responses: ori = 1, inv = -1

#loop over participants & compute CIs
for (i in unique(dat$`Participant Public ID`)){ #loop over participants
  filename <- i 
  if (!file.exists(str_c(getwd(), '/cis/ci_', filename, '.png'))) { #check whether the CI already exists for this participant, if so, skip this participant.
    print(str_c('Computing CI for ppn ', filename))
    response_tmp <- dat %>% filter(`Participant Public ID` == i) #select the trials for a single participant
    
    generateCI(stimuli = 1:500, #this is where the magic happens!
               responses = response_tmp$Response_binary, 
               baseimage = 'base_face_FMNES', 
               rdata = 'rcic_seed_1_time_Feb_20_2019_13_42.RData',
               filename = filename)
  } else {
    print(str_c('CI for ppn ', filename, ' already exists'))
  }  
}

