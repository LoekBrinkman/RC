#script to make CIs for selfimage, selfimage_mirror, (self)image_photo
#Loek Brinkman 2019

# Instructions: make sure that the three datafiles are in the folder specified below (line 23)
# Make sure that the file 'rcic_seed_1_time_Feb_20_2019_13_42.Rdata' is also in this folder
# Select all the code an press 'Run'


# install & load relevant packages
if (!require("tidyverse")) install.packages("tidyverse")
if (!require("rcicr")) install.packages("rcicr")
if (!require("stringr")) install.packages("stringr")
library(tidyverse)
library(rcicr)
library(stringr)

#clear environment - start with a clean sheet
rm(list=ls())

### step 1: create CIs for selfimage

#set the directory where to data is located
setwd("~/Dropbox/Utrecht/Projects/RC/mirror")

#load data
dat_self <- read_csv('data_exp_8140-v2_task-vihh.csv')

dat_self <- dat_self %>% select(`Participant Public ID`, Response, display) %>% #select the Response column
  filter(!is.na(Response) & Response != "null") %>% #remove rows that don't code for stimuli 
  filter(display == "Choose") %>% 
  mutate(Response_binary = ifelse(Response == 'Photo 1', 1, -1)) #recode responses: ori = 1, inv = -1

#loop over participants & compute CIs
for (i in unique(dat_self$`Participant Public ID`)){ #loop over participants
  filename <- str_c(i, '_self') 
  if (!file.exists(str_c(getwd(), '/cis/ci_', filename, '.png'))) { #check whether the CI already exists for this participant, if so, skip this participant.
    print(str_c('Computing CI for ppn ', filename))
    response_tmp <- dat_self %>% filter(`Participant Public ID` == i) #select the trials for a single participant
    
    generateCI(stimuli = 1:500, #this is where the magic happens!
               responses = response_tmp$Response_binary, 
               baseimage = 'base_face_FMNES', 
               rdata = 'rcic_seed_1_time_Feb_20_2019_13_42.RData',
               filename = filename)
  } else {
    print(str_c('CI for ppn ', filename, ' already exists'))
  }  
}

### step 2: compute CI for selfimage_mirror
#load data
dat_mirror <- read_csv('data_exp_8140-v2_task-zt1v.csv')

dat_mirror <- dat_mirror %>% select(`Participant Public ID`, Response, display) %>% #select the Response column
  filter(!is.na(Response) & Response != "null") %>% #remove rows that don't code for stimuli 
  filter(display == "Choose") %>% 
  mutate(Response_binary = ifelse(Response == 'Photo 1', 1, -1)) #recode responses: ori = 1, inv = -1

#loop over participants & compute CIs
for (i in unique(dat_mirror$`Participant Public ID`)){ #loop over participants
  filename <- str_c(i, '_mirror') 
  if (!file.exists(str_c(getwd(), '/cis/ci_', filename, '.png'))) { #check whether the CI already exists for this participant, if so, skip this participant.
    print(str_c('Computing CI for ppn ', filename))
    response_tmp <- dat_mirror %>% filter(`Participant Public ID` == i) #select the trials for a single participant
    
    generateCI(stimuli = 1:500, #this is where the magic happens!
               responses = response_tmp$Response_binary, 
               baseimage = 'base_face_FMNES', 
               rdata = 'rcic_seed_1_time_Feb_20_2019_13_42.RData',
               filename = filename)
  } else {
    print(str_c('CI for ppn ', filename, ' already exists'))
  }  
}

### step 3: compute CI for (self)image based on photo (by other)
#load data
dat_photo <- read_csv('data_exp_8140-v2_task-zt1v.csv')

dat_photo <- dat_photo %>% select(`Participant Public ID`, Response, display) %>% #select the Response column
  filter(!is.na(Response) & Response != "null") %>% #remove rows that don't code for stimuli 
  filter(display == "Choose") %>% 
  mutate(Response_binary = ifelse(Response == 'Photo 1', 1, -1)) #recode responses: ori = 1, inv = -1

#loop over participants & compute CIs
for (i in unique(dat_photo$`Participant Public ID`)){ #loop over participants
  filename <- str_c(i, '_photo') 
  if (!file.exists(str_c(getwd(), '/cis/ci_', filename, '.png'))) { #check whether the CI already exists for this participant, if so, skip this participant.
    print(str_c('Computing CI for ppn ', filename))
    response_tmp <- dat_photo %>% filter(`Participant Public ID` == i) #select the trials for a single participant
    
    generateCI(stimuli = 1:500, #this is where the magic happens!
               responses = response_tmp$Response_binary, 
               baseimage = 'base_face_FMNES', 
               rdata = 'rcic_seed_1_time_Feb_20_2019_13_42.RData',
               filename = filename)
  } else {
    print(str_c('CI for ppn ', filename, ' already exists'))
  }  
}
