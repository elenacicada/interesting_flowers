#Analysis for "The evolutionary dynamics of plant mating systems: 
#how bias for studying ‘interesting’ plant reproductive systems could backfire

################################################################################
#Setup

#install.packages("devtools")
#devtools::install_github("ecoinfor/U.Taxonstand")
#install.packages("readxl")
#install.packages("dplyr")

library(devtools)
library(U.Taxonstand)
library(readxl)
library(dplyr)

setwd("/Users/elenameyer/Documents/Data_Dryad") 

#reading in reference for correcting names from World Flora Online 
#from https://www.sciencedirect.com/science/article/pii/S2468265922000944 

setwd("/Users/elenameyer/Documents/Data_Dryad/WFO_Data") 

dat1 <- read_excel("Plants_WFO_database_part1.xlsx")
dat2 <- read_excel("Plants_WFO_database_part2.xlsx")
dat3 <- read_excel("Plants_WFO_database_part3.xlsx")

#rbinding to single data table
database <- rbind(dat1, dat2, dat3)

setwd("/Users/elenameyer/Documents/Data_Dryad") 

################################################################################
#Reading in dataset

#reading in data from my review off two sheets, formatting
splist <- read_excel("Input_Data_MS.xlsx", sheet = 2)

#getting large review data for formatting (warning is just cell formatting)
reviews_splist <- read_excel("Input_Data_MS.xlsx", sheet = 3)

#changing from binary, correct/constant with Moeller et al (SI=0, SC=1)
#quant=tm=the proportion of seeds outcrossed as opposed to selfed
one <- filter(.data = reviews_splist, ref == "Moeller et al 2017") 
one$mating_system[one$mating_system == 1] <- "SC"
one$mating_system[one$mating_system == 0] <- "SI"
#one$quant[one$quant > 0.2] <- "fSC"
#one$quant[one$quant < 0.2] <- "fSI"
one <- one[, c("index", "ref", "genus_species", "mating_system")]

#formatting Tateyama et al 
two <- filter(.data = reviews_splist, ref == "Tateyama et al 2021") 
two <- two[, c("index", "ref", "genus_species", "mating_system")]

#formatting Prior and Busch 
three <- filter(.data = reviews_splist, ref == "Prior and Busch") 
three$mating_system <- NA
three <- three[, c("index", "ref", "genus_species", "mating_system")]

#formatting Razanajatovo
four <- reviews_splist %>% 
  filter(ref == "Razanajatovo") %>% 
  mutate(mating_system_new = NA) %>% 
  rename(mating_system = mating_system_new, 
         quant = mating_system, quant2 = quant) 
four <- four[, c("index", "ref", "genus_species", "mating_system")]

#formatting Delaney and Igic
five <- filter (.data = reviews_splist, ref == "Delaney and Igic")
five <- five[, c("index", "ref", "genus_species", "mating_system")]

#formatting "Freyman and Hohna"
six <- filter(.data = reviews_splist, ref == "Freyman and Hohna")
six <- six[, c("index", "ref", "genus_species", "mating_system")]

#formatting Whitehead et al 
seven <- reviews_splist %>% 
  filter(ref == "Whitehead et al") %>% 
  mutate(mating_system_new = NA) %>% 
  rename(mating_system = mating_system_new, 
         quant1 = mating_system, quant2 = quant)
seven <- seven[, c("index", "ref", "genus_species", "mating_system")]

#formatting Grossenbacher et al (2015 and 2017)
eight <- filter(.data = reviews_splist, ref == "Grossenbacher et al (2017)") 
eight <- eight[, c("index", "ref", "genus_species", "mating_system")]

nine <- filter(.data = reviews_splist, ref == "Grossenbacher et al (2015)") 
nine <- nine[, c("index", "ref", "genus_species", "mating_system")]

#merging all data 
large_reviews_all <- rbind(one, two, three, four, five, six, seven, eight, nine)
unique.check.l <- unique(large_reviews_all$genus_species)

#fixing names
newdf.s <- splist
newdf.l <- large_reviews_all #8584 observations here 
u.newdf.l <- distinct(.data = newdf.l, col = genus_species, .keep_all = TRUE)
u2.newdf.l <- unique(newdf.l$genus_species) #5559 here
newdf.l <- filter(newdf.l, mating_system != "NA") #removing NAs here, end net is 4141 

#using tidyverse to aggregate data in a better way - larger dataset
save <- newdf.l%>% 
  group_by(genus_species) %>% 
  summarize(mating_system = paste0(mating_system, collapse = ", "))

#for smaller dataset
save2 <- newdf.s%>% 
  group_by(genus_species) %>% 
  summarize(mating_system = paste0(mating_system, collapse = ", "))

#rbinding together + grouping 
bofa <- bind_rows(save, save2) #binding the two datasets together, 7845
adj <- bofa %>% 
  group_by(genus_species) %>% 
  summarize(mating_system = paste0(mating_system, collapse = ", "))

#seeing how many unique cases of SI/SC disagreement or otherwise
real.unique <- unique(adj$mating_system)

#fixing all cases/enteries to get SI/SC props 
adj.forfix <- adj #now this should run the whole dataset for props 

adj.forfix$mating_system[adj.forfix$mating_system == "SI"] <- "si"
adj.forfix$mating_system[adj.forfix$mating_system == "SC, SC"] <- "sc"
adj.forfix$mating_system[adj.forfix$mating_system == "SC, review"] <- "sc"
adj.forfix$mating_system[adj.forfix$mating_system == "SC"] <- "sc"
adj.forfix$mating_system[adj.forfix$mating_system == "SI, SI, SI, SI"] <- "si"
adj.forfix$mating_system[adj.forfix$mating_system == "SI, SI, SC, SI"] <- "na"
adj.forfix$mating_system[adj.forfix$mating_system == "SI, SI, SC, SI"] <- "na"
adj.forfix$mating_system[adj.forfix$mating_system == "SI, SI, SI"] <- "si" 
adj.forfix$mating_system[adj.forfix$mating_system == "SI, SC"] <- "na" 
adj.forfix$mating_system[adj.forfix$mating_system == "SI, SC, SI"] <- "na" 
adj.forfix$mating_system[adj.forfix$mating_system == "SI, SC (?), SI"] <- "na" 
adj.forfix$mating_system[adj.forfix$mating_system == "DIC"] <- "na"
adj.forfix$mating_system[adj.forfix$mating_system == "SI, SI"] <- "si" 
adj.forfix$mating_system[adj.forfix$mating_system == "SI (?)"] <- "na"
adj.forfix$mating_system[adj.forfix$mating_system == "SC (?)"] <- "na"
adj.forfix$mating_system[adj.forfix$mating_system == "SC or APO (?)"] <- "na"
adj.forfix$mating_system[adj.forfix$mating_system == "?"] <- "na"
adj.forfix$mating_system[adj.forfix$mating_system == "SI, ?, SI"] <- "si"
adj.forfix$mating_system[adj.forfix$mating_system == "SC*"] <- "na"
adj.forfix$mating_system[adj.forfix$mating_system == "BSO"] <- "na"
adj.forfix$mating_system[adj.forfix$mating_system == "review"] <- "na"    
adj.forfix$mating_system[adj.forfix$mating_system == "SC, SC, SC"] <- "sc"  
adj.forfix$mating_system[adj.forfix$mating_system == "SC, SC, SC, SC"] <- "sc"  
adj.forfix$mating_system[adj.forfix$mating_system == "SI, SI, SC"] <- "na"
adj.forfix$mating_system[adj.forfix$mating_system == "SC, SC, SI"] <- "na"
adj.forfix$mating_system[adj.forfix$mating_system == "SI, SI, SI, SC"] <- "na"
adj.forfix$mating_system[adj.forfix$mating_system == "SI, SC, SC, SC"] <- "na"
adj.forfix$mating_system[adj.forfix$mating_system == "DIO"] <- "si"
adj.forfix$mating_system[adj.forfix$mating_system == "SC/APO"] <- "na"
adj.forfix$mating_system[adj.forfix$mating_system == "SI (?)"] <- "na"
adj.forfix$mating_system[adj.forfix$mating_system == "SC, SI"] <- "na"
adj.forfix$mating_system[adj.forfix$mating_system == "review, SI"] <- "si"
adj.forfix$mating_system[adj.forfix$mating_system == "PCI"] <- "na"
adj.forfix$mating_system[adj.forfix$mating_system == "SI, review"] <- "si"
adj.forfix$mating_system[adj.forfix$mating_system == "SC, SC, SC, SC, SC"] <- "sc"
adj.forfix$mating_system[adj.forfix$mating_system == "SC, SC, SC/APO"] <- "sc"
adj.forfix$mating_system[adj.forfix$mating_system == "SC, SI, SI"] <- "na"
adj.forfix$mating_system[adj.forfix$mating_system == "SI, SI, SI, SI, SI, SI"] <- "si"
adj.forfix$mating_system[adj.forfix$mating_system == "??"] <- "na"
adj.forfix$mating_system[adj.forfix$mating_system == "SI, SI, SC, SC, SC, SC"] <- "na"
adj.forfix$mating_system[adj.forfix$mating_system == "SI, SI, SI, SI, SI"] <- "si"
adj.forfix$mating_system[adj.forfix$mating_system == "SI, SC, SI, SC, SI"] <- "na"
adj.forfix$mating_system[adj.forfix$mating_system == "SC, SI, SC"] <- "na"
adj.forfix$mating_system[adj.forfix$mating_system == "SI/APO"] <- "na"
adj.forfix$mating_system[adj.forfix$mating_system == "SI, SI, SI/SC"] <- "na"
adj.forfix$mating_system[adj.forfix$mating_system == "SC, SI, SI, SI, SI (?)"] <- "na"
adj.forfix$mating_system[adj.forfix$mating_system == "SI, SC, review"] <- "na"
adj.forfix$mating_system[adj.forfix$mating_system == "D, SI"] <- "si"
adj.forfix$mating_system[adj.forfix$mating_system == "SC, SC, SC, SI"] <- "na"
adj.forfix$mating_system[adj.forfix$mating_system == "SC, SC, SC, SI, SC"] <- "na"
adj.forfix$mating_system[adj.forfix$mating_system == "SC, SI, SC, SC"] <- "na"
adj.forfix$mating_system[adj.forfix$mating_system == "SC, SC, SC, SC, SC, SC, SC, SC"] <- "sc"
adj.forfix$mating_system[adj.forfix$mating_system == "BSO, SI"] <- "na"
adj.forfix$mating_system[adj.forfix$mating_system == "BSO, SC"] <- "na"
adj.forfix$mating_system[adj.forfix$mating_system == "SI, SI, SI, SC, SC, SI, SI"] <- "na"
adj.forfix$mating_system[adj.forfix$mating_system == "SI, DIC"] <- "na"
adj.forfix$mating_system[adj.forfix$mating_system == "SI, review, SI, SC (?)"] <- "na"
adj.forfix$mating_system[adj.forfix$mating_system == "SI, SC, SC (?)"] <- "na"
adj.forfix$mating_system[adj.forfix$mating_system == "SC, SC, SC, review"] <- "sc"
adj.forfix$mating_system[adj.forfix$mating_system == "SI**"] <- "na"
adj.forfix$mating_system[adj.forfix$mating_system == "SI, SI, SI, SC, SI"] <- "na"
adj.forfix$mating_system[adj.forfix$mating_system == "SC, SC, ?, SI, SI"] <- "na"
adj.forfix$mating_system[adj.forfix$mating_system == "review, review"] <- "na"
adj.forfix$mating_system[adj.forfix$mating_system == "D"] <- "na"
adj.forfix$mating_system[adj.forfix$mating_system == "SI/SC/APO"] <- "na"
adj.forfix$mating_system[adj.forfix$mating_system == "SI, SI, SI, SC, SI(?)"] <- "na"
adj.forfix$mating_system[adj.forfix$mating_system == "SC/APO, SC"] <- "sc"
adj.forfix$mating_system[adj.forfix$mating_system == "SC, SC, SC, SC, SC, SC, SC, SC, SC, SC"] <- "sc"
adj.forfix$mating_system[adj.forfix$mating_system == "SI, SC*, SC"] <- "na"
adj.forfix$mating_system[adj.forfix$mating_system == "SC, SC/APO"] <- "na"
adj.forfix$mating_system[adj.forfix$mating_system == "SC, SI (?), SC"] <- "sc"
adj.forfix$mating_system[adj.forfix$mating_system == "SI, SC, SI (?), SC"] <- "na"
adj.forfix$mating_system[adj.forfix$mating_system == "SC, SI, SI, SI"] <- "na"
adj.forfix$mating_system[adj.forfix$mating_system == "SC, SC, SC, SC, SC, SC"] <- "sc"
adj.forfix$mating_system[adj.forfix$mating_system == "SI, SI, SI, SC, SI"] <- "na"
adj.forfix$mating_system[adj.forfix$mating_system == "SI, ?, SI"] <- "si"
adj.forfix$mating_system[adj.forfix$mating_system == "review, review, SI"] <- "si"
adj.forfix$mating_system[adj.forfix$mating_system == "SC, SC, SC, SC, SC, SC, SC, SC, SC, SC, SC"] <- "sc"
adj.forfix$mating_system[adj.forfix$mating_system == "SC**"] <- "na"
adj.forfix$mating_system[adj.forfix$mating_system == "SC, SI/APO"] <- "na"
adj.forfix$mating_system[adj.forfix$mating_system == "SI?"] <- "na"
adj.forfix$mating_system[adj.forfix$mating_system == "SI, SC, SI (?)"] <- "na"
adj.forfix$mating_system[adj.forfix$mating_system == "SI, SI, SI, SC**"] <- "si"
adj.forfix$mating_system[adj.forfix$mating_system == "review, review, SC, SC"] <- "sc"
adj.forfix$mating_system[adj.forfix$mating_system == "SI, SC, SC, SI"] <- "na"
adj.forfix$mating_system[adj.forfix$mating_system == "SI/APO (?), SC"] <- "na"
adj.forfix$mating_system[adj.forfix$mating_system == "SC, SC (?)"] <- "sc"
adj.forfix$mating_system[adj.forfix$mating_system == "SI**, SC, SC"] <- "na"
adj.forfix$mating_system[adj.forfix$mating_system == "SI/SC (?), SC"] <- "na"
adj.forfix$mating_system[adj.forfix$mating_system == "SC, SC, review"] <- "sc"
adj.forfix$mating_system[adj.forfix$mating_system == "BSO, SC, SC"] <- "sc"
adj.forfix$mating_system[adj.forfix$mating_system == "HET, HET"] <- "na"
adj.forfix$mating_system[adj.forfix$mating_system == "?, SC"] <- "sc"
adj.forfix$mating_system[adj.forfix$mating_system == "?, SC, SC"] <- "sc"
adj.forfix$mating_system[adj.forfix$mating_system == "SI/APO"] <- "na"
adj.forfix$mating_system[adj.forfix$mating_system == "SI/APO (?)"] <- "na"
adj.forfix$mating_system[adj.forfix$mating_system == "SI/APO (?), SC"] <- "na"
adj.forfix$mating_system[adj.forfix$mating_system == "SI, SI (?), SC"] <- "na"
adj.forfix$mating_system[adj.forfix$mating_system == "SI, SI (?), SI"] <- "si"
adj.forfix$mating_system[adj.forfix$mating_system == "SI, SC, SI"] <- "na"
adj.forfix$mating_system[adj.forfix$mating_system == "SC, SC, SI, SC"] <- "na"
adj.forfix$mating_system[adj.forfix$mating_system == "SI, SC, SC"] <- "na"
adj.forfix$mating_system[adj.forfix$mating_system == "SI, SC, SI"] <- "na"
adj.forfix$mating_system[adj.forfix$mating_system == "SI (?), SI"] <- "si"
adj.forfix$mating_system[adj.forfix$mating_system == "SC, SI, SI, SI (?)"] <- "na"
adj.forfix$mating_system[adj.forfix$mating_system == "SI, SI, SI, SC, SI (?)"] <- "na"
adj.forfix$mating_system[adj.forfix$mating_system == "SI, SC, SI (?), SC?"] <- "na"
adj.forfix$mating_system[adj.forfix$mating_system == "SC, SI/APO (?)"] <- "na"
adj.forfix$mating_system[adj.forfix$mating_system == "SC/APO (?), SC"] <- "na"

#confirming all unclear cases converted to NAs
unique(adj.forfix$mating_system)
str(adj.forfix) 

################################################################################
#Name checking

#name check - putting in U.Tax format 
ms.props <- adj.forfix%>% 
  mutate(mating_system = NA) %>% 
  rename(name=genus_species, author=mating_system)

#name check procedure 
res2 <- nameMatch(spList=ms.props, 
                  spSource=database, 
                  author=FALSE,
                  max.distance=1, 
                  genusPairs=NULL, 
                  Append=FALSE)

res_no_gym_2 <- res2 %>% #not sure where they came from but this sp. (n=25, 17 sps)
  filter(Family !="Araucariaceae") %>% 
  filter(Family !="Cupressaceae") %>% 
  filter(Family !="Cycadaceae") %>% 
  filter(Family !="Ephedraceae") %>% 
  filter(Family !="Ginkgoaceae") %>% 
  filter(Family !="Gnetaceae") %>% 
  filter(Family !="Pinaceae") %>% 
  filter(Family !="Podocarpaceae") %>%  
  filter(Family !="Sciadopityaceae") %>% 
  filter(Family !="Taxaceae") %>% 
  filter(Family !="Welwitschiaceae") %>% 
  filter(Family != "Zamiaceae") 

#match adj.forfix and res.renames.2 so that we have SI and SC values as well 
si_sc <- rename(.data=res_no_gym_2, genus_species = "Accepted_SPNAME")
si_sc <- si_sc[, c("genus_species", "Family")]

trial <- merge(si_sc, adj.forfix, by="genus_species")
unique.trial <- unique(trial) 

#reviewing props 
sc.pro <- filter(unique.trial, mating_system == "sc") #2471
si <- filter(unique.trial, mating_system == "si") #1533
na <- filter(unique.trial, mating_system == "na") #320 

#writing out results - cleaned + sumarized w/NAs 
write.csv(unique.trial, file = "Output_Data_MS.csv") 

#reading back in to check 
ms.dat.fin <- read.csv("Output_Data.csv")

################################################################################
#End 

#quick re-run except for "res2"
rm(list=ls()[! ls() %in% c("res2")]) 

#session info 
sessionInfo()