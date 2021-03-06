
# Directory that contains all the files.
# Assumes the file names are in following format (<blockid>.csv)
dirName <- "SoilData_Abhishek"


df <- data.frame()

#Iterate over all files
for(f in dir(dirName))
{
        #Get Block Id
        blockId <- strsplit(f,'\\.')[[1]][1]
        fileName <- paste(dirName, f, sep = "/")
        
        #Read files and skip first 5 lines
        a<-read.csv(fileName,skip = 5, stringsAsFactors = F)
        
        #Get column names that do not have Text box in it.
        names <- colnames(a)[-c(grep("Textbox",colnames(a)))]
        
        a <- a[,names]
        a <- a[,-c(15)]
        
        # Rename COl Names
        colnames(a) <- c("BlockName","SampleNo","pH","EC","OC","N","P","K","S","Zn","Fe","Cu","Mn","B")
        
        #add block Id
        a$BlockId <- blockId
        
        #Merge with existing data frame
        if(nrow(df)==0)
        {
                df<-a
        }
        else
        {
                df<-rbind(df,a)
        }
}


#Function to strsplit and get 1st value
str_split_fn <- function(x)
{
        if(grepl(' ',x))
        {
                return(strsplit(x, ' ')[[1]][1])
        }
        else
        {
                return(x)
        }
}


# Iterate over multiple columns (Col 3-14)
for(i in (3:14))
{
        df[,i] <- unlist(lapply(df[,i], str_split_fn))
}

# Write back the csv file
write.csv(x = df,file = paste0(dirName,".csv"), row.names = F, col.names = T,na = "NA")

# Read csv to update "" -> NA
df<-read.csv(file = paste0(dirName,".csv"))

# Write back the csv file
write.csv(x = df,file = paste0(dirName,".csv"), row.names = F, col.names = T,na = "NA")

rm(list=ls())
