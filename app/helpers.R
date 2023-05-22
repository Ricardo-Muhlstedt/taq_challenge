library(tidyverse)
library(readxl)
library(dygraphs)
library(xts)


data <- "dados_vendas.xlsx"

raw_data <- read_xlsx(data)


gross_revenue <- raw_data %>%
  filter(!grepl("^C.", Invoice),
         Quantity > 0,
         Price > 0,
         !grepl("^[A-Za-z]", StockCode))

data <- gross_revenue %>%
  group_by(InvoiceDate) %>%
  summarise(total_sales = sum(Price * Quantity)) %>%
  mutate(total_sales = parse_number(format(total_sales, nsmall = 2)))

don <- xts(x = data$total_sales, order.by = data$InvoiceDate)