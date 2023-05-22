## Loading libraries
library(tidyverse)
library(readxl)


## Loading data from excel file
data <- "data//input//dados_vendas.xlsx"

raw_data <- read_xlsx(data)


# Cleaned data                  
gross_revenue <- raw_data %>%
  filter(!grepl("^C.", Invoice),
         Quantity > 0,
         Price > 0,
         !grepl("^[A-Za-z]", StockCode))

