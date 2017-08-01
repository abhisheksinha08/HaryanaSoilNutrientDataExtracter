
if("tcltk" %in% installed.packages() == FALSE)
{
    install.packages("tcltk")
}

if("dplyr" %in% installed.packages() == FALSE)
{
    install.packages("dplyr")
}

library(tcltk)
library(dplyr)

data.dir <- tclvalue(tkchooseDirectory())

all.data <- data.frame()

cat("Concating files...")
for(f in dir(data.dir))
{
    cat(f)
    cat("\r\n")
    if(grepl(".csv", f)){
        if(nrow(all.data)==0)
        {
            all.data <- read.csv(paste(data.dir, f, sep = "/"))
        }
        else
        {
            all.data <- rbind(all.data, read.csv(paste(data.dir, f, sep = "/")))
        }
    }
}


haryana.district.block <- read.csv("haryana_blocks_url.csv")
haryana.district.block <- haryana.district.block[,1:4]

all.data<- full_join(all.data, haryana.district.block, by="BlockId")
all.data<-all.data %>% select(DistrictId, DistrictName, BlockId, BlockName = BlockName.x, SampleNo, SoilPh=pH, ElectricalConductivity=EC, 
                              OrganicCarbon=OC, Nitrogen=N, Phosphorous=P, Potassium=K, Sulphur=S, Zinc=Zn, Iron=Fe,
                              Copper=Cu, Magnesium = Mn, Boron=B)

write.csv(all.data, file = "haryana_soil_nutrient.csv")

rm(list = ls())

