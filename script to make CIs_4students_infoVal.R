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
dat <- read_csv('data_exp_8140-v4_task-q3sn.csv')

dat <- dat %>% select(`Participant Public ID`, Response, display, `Trial Number`) %>% #select the Response column
  filter(!is.na(Response) & Response != "null") %>% #remove rows that don't code for stimuli 
  filter(display == "Choose") %>% 
  mutate(Response_binary = ifelse(Response == 'Photo 1', 1, -1)) #recode responses: ori = 1, inv = -1

# #loop over participants & compute CIs
# for (i in unique(dat$`Participant Public ID`)){ #loop over participants
#   filename <- i 
#   if (!file.exists(str_c(getwd(), '/cis/ci_', filename, '.png'))) { #check whether the CI already exists for this participant, if so, skip this participant.
#     print(str_c('Computing CI for ppn ', filename))
#     response_tmp <- dat %>% filter(`Participant Public ID` == i) #select the trials for a single participant
#     
#     generateCI(stimuli = 1:500, #this is where the magic happens!
#                responses = response_tmp$Response_binary, 
#                baseimage = 'base_face_FMNES', 
#                rdata = 'rcic_seed_1_time_Feb_20_2019_13_42.RData',
#                filename = filename)
#   } else {
#     print(str_c('CI for ppn ', filename, ' already exists'))
#   }  
# }


## compute infoVal score per participant

#load .Rdata file that contains the description of the stimuli
rdata <- 'rcic_seed_1_time_Feb_20_2019_13_42.RData'
load(rdata)
allSub <- unique(dat$`Participant Public ID`)


# loop over ppn
infoVal <- rep(0, length(allSub))
cnt <- 1
#test<- rep(0, length(allSub))
for (iSub in allSub){ 
  # Generate CI 
  stimuli <- 1:500
  responses <- dat[dat$`Participant Public ID` == iSub,]$Response_binary
  ci <- generateCI(stimuli = stimuli, responses = responses, baseimage = "base_face_FMNES", rdata = rdata, save_as_png=F)
  
  # Compute infoVal 
  infoVal[cnt] <- computeInfoVal2IFC(ci, rdata)
  cnt <- cnt + 1
  print(cnt-1)
}

# add ppn numbers
infoVal_scores <- tibble(infoVal = infoVal, participant = allSub, tmp = rep(1, length(allSub)))

#plot to check distribution
ggplot(infoVal_scores, aes(tmp, infoVal)) +
  geom_violin() + 
  geom_jitter()

# save output
filename <- 'infoVal_scores.csv'
write_csv(infoVal_scores, filename)


