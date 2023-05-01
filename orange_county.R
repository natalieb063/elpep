library(tidyverse)
library(tigris)
library(tidycensus)

data <- read_csv("/Users/nataliebrown/Downloads/nowcasts_OC_CA.csv")

data_selected <- data %>%
  select(GEOID, age_0to5_count, age_6to12_count, COUNTYFIP)

data_selected$GEOID <- as.character(data_selected$GEOID)
data_selected$COUNTYFIP <- as.character(data_selected$COUNTYFIP)

orange <- tracts("CA", "Orange", cb = TRUE)

orange <- orange %>% select(GEOID, geometry)

#removing leading zeroes
orange$GEOID <- str_remove(orange$GEOID, "^0+")

n_distinct(data_selected$GEOID)
#there are 577 census tracts in our output, but 613 census tracts in our tigris
#output. I assume this is because some census tracts are also P.O. boxes (or
#is that zctas? either way, going to continue and see if there are holes)

#going to left_join data_selected to orange to keep all rows in data_selected

orange_data <- left_join(data_selected, orange, by = "GEOID")

#there seem to be some census tracts missing...

ggplot(data = orange_data, aes(fill = age_0to5_count, geometry = geometry)) + 
  geom_sf() +
  scale_fill_distiller(palette = "RdPu", direction = 1) +
  labs(title = "  Children Age 0-5, 2023",
       caption = "Data source: ___",
       fill = "ELPEP estimate") 


