
library(dplyr)

gitpath = "/Users/anastasiabernat/Desktop/git_repositories/warming-SBB/"

# egg tube data

d = read.csv("/Users/anastasiabernat/Desktop/git_repositories/extreme-flight-trials/data/egg_tube_data.csv")
d = d[d$gen1_ID !="",]
data = d[d$gen1_ID != "gen1_ID",]
data = data[data$S.wing == "N",]

data = data[data$viable == "Y" | data$viable == "",]
data = data[data$death_date == "",]

data$one = 1
summarise_at(group_by(data, MID, pop), vars(one), funs(sum(.,na.rm=TRUE)))

# select 114 and 16

sample(c("M", "F"), 1) # which pull females and which males?

# MID 114 = females
# MID 16 = males

MID114 = data[data$MID == 114,]
nrow(MID114[MID114$sex == "F",]) #23

MID16 = data[data$MID == 16,]
nrow(MID16[MID16$sex == "M",]) #37

path114 = paste0(gitpath, "datasheets/MID114.csv")
path16 = paste0(gitpath, "datasheets/MID16.csv")
#write.csv(MID114, file= path114, row.names = F)
#write.csv(MID16, file= path16, row.names = F)

checked114 = read.csv(paste0(gitpath, "datasheets/MID114-B.csv"))
checked16 = read.csv(paste0(gitpath, "datasheets/MID16-B.csv"))


filtered114 = checked114[checked114$keep !="no",]
filtered16 = checked16[checked16$keep !="no",]

dF = filtered114[filtered114$sex == "F",]
dM = filtered16[filtered16$sex == "M",]


# randomly select 20

females = MID114[MID114$sex == "F",]$gen1_ID
males = MID16[MID16$sex == "M",]$gen1_ID

females = dF$gen1_ID
males = dM$gen1_ID

fem = sample(females, 20, replace=F)
male = sample(males, 20, replace=F)

pairs = data.frame(cbind("114", fem, male, "16"))
colnames(pairs) = c("MIDF","females", "males", "MIDM")

# adult age

pairs$wing_dateF = NA
for (i in 1:(length(fem))){
  row = which(dF[dF$sex == "F",]$gen1_ID == fem[i])
  print(row)
  
  wingdate = dF[row,]$wing_date
  print(wingdate)
  pairs$wing_dateF[i] = wingdate
}

pairs$wing_dateM = NA
for (i in 1:(length(male))){
  row = which(dM[dM$sex == "M",]$gen1_ID == male[i])
  
  wingdate = dM[row,]$wing_date
  print(wingdate)
  pairs$wing_dateM[i] = wingdate
}

pairs$ageF = Sys.Date() - as.Date(pairs$wing_dateF, "%m.%d.%y")
pairs$ageM = Sys.Date() - as.Date(pairs$wing_dateM, "%m.%d.%y")

pairs$agediff = pairs$ageF - pairs$ageM

pairs # not too old from each other in the pairs here. 

outpath = paste0(gitpath, "datasheets/pairs_final-F.csv")

write.csv(pairs, file=outpath, row.names = F)

