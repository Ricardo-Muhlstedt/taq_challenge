
# Getting all NA values
## Function to count all "NA" values
na_values <- function (col_name) { raw_data %>%
  filter(is.na(col_name)) %>%
  count(name = names(col_name))
}

## Aplying na_values() to all columns
na_data <- map(raw_data, na_values) %>%
  as.data.frame()

names(na_data) <- c("invoice",
                    "stock_code",
                    "description",
                    "quantity",
                    "invoice_date",
                    "price",
                    "customer_id",
                    "country")


# Columns types
raw_data %>%
  sapply(class)
 

# 2010 sales
raw_data %>%
  filter(year(InvoiceDate) == "2010",
         Quantity > 0) %>%
  count()

## Keeping just the gross revenue and filtering bad debts
## (not collectable money, or unpaid transactions)
gross_revenue %>%
  filter(year(InvoiceDate) == "2010",
         grepl("^[A-Z0-9]", Description) | is.na(Description)) %>%
  mutate(sale = Quantity * Price) %>%
  filter(!is.na(sale)) %>%
  summarise(sum_sale = format(sum(sale), nsmall = 2))


# Distinct products
gross_revenue %>%
  filter(grepl("^[A-Z0-9]", Description),
         Quantity > 0) %>%
  distinct(Description) %>%
  count()


# Most sold product on 15-JUN-2010
gross_revenue %>%
  filter(grepl("2010-06-15.", InvoiceDate)) %>%
  group_by(Description) %>%
  summarise(n = sum(Quantity)) %>%
  arrange(desc(n)) %>%
  head(2)


# Top 10 items last 3 months of 2010
gross_revenue %>%
  filter(grepl("2010-(12|11|10)-.", InvoiceDate)) %>%
  group_by(Description) %>%
  summarise(n = sum(Quantity)) %>%
  arrange(desc(n)) %>%
  head(10)


# Best selling day (GROSS)
gross_revenue %>%
  mutate(InvoiceDate = format(ymd_hms(InvoiceDate),
                              format = "%Y-%m-%d")) %>%
  group_by(InvoiceDate) %>%
  summarise(n = sum(Quantity * Price)) %>%
  arrange(desc(n)) %>%
  head(1)


# Mean price "METAL" sales
gross_revenue %>%
  filter(grepl(".METAL.", Description)) %>%
  group_by(Description, Price) %>%
  select(Description, Price) %>%
  distinct() %>%
  ungroup() %>%
  summarise(mean(Price))


# Mug buyers 2010
gross_revenue %>%
  filter(grepl(".MUG .", Description) |
           grepl(".MUGS .", Description) |
           grepl(".STEIN .", Description) |
           grepl(".TANKARD .", Description),
         year(InvoiceDate) == "2010",
         !grepl("^C.", Invoice)) %>%
  group_by(`Customer ID`) %>%
  count() %>%
  ungroup %>%
  count()


# Outliers
raw_data %>%
  ggplot() +
  geom_point(aes(Price, Quantity))

raw_data %>%
  ggplot() +
  geom_hex(aes(Price, Quantity)) 


## Subsetting negative and abnormal pricing and quantities
raw_data   %>%
  filter(Price < 0 | Price > 300 | Quantity > 2000 | Quantity < -2000) %>%
  select(`Customer ID`, everything(), -Invoice, -Country)


# Distribution of total spent per customer
gross_revenue %>%
  group_by(`Customer ID`) %>%
  summarise(total_price = sum(Quantity * Price)) %>%
  ungroup() %>%
  ggplot() +
  geom_histogram(aes(total_price),
                 col = "grey",
                 fill = "#4682B4",
                 bins = 50) +
  scale_x_continuous(breaks = seq(0, 500, 25), 
                     lim = c(0 , 500)) +
   theme_minimal() +
  labs(x = "Total spent per customer",
       y = "Count")

 
 # Distribution of mean spent per Invoice
gross_revenue %>%
  group_by(Invoice) %>%
  summarise(mean_total_price = mean(Quantity * Price)) %>%
  ungroup() %>%
  ggplot() +
  geom_histogram(aes(mean_total_price),
                  col = "grey",
                  fill = "#4682B4",
                  bins = 15) +
   scale_x_continuous(breaks = seq(0, 200, 10), 
                      lim = c(0 , 100)) +
   theme_minimal() +
  labs(x = "Mean spent",
       y = "Count")
 
 # Favorite day of the week and time
 gross_revenue %>%
   mutate(day = wday(InvoiceDate, label = TRUE)) %>%
   group_by(day) %>%
   count(day)
 
 gross_revenue %>%
   mutate(InvoiceDate = format(InvoiceDate, format = "%H")) %>%
   mutate(morning = InvoiceDate < 12,
          afternoon = InvoiceDate >= 12 &
            InvoiceDate < 18,
          night = InvoiceDate >= 18) %>%
   group_by(morning, afternoon, night) %>%
   count() %>%
   arrange(desc(n))
 
 # Seasonal sales
 ## Filtering 2009 sales
 gross_revenue %>%
   filter(!grepl("^2009-.", InvoiceDate)) %>%
   mutate(month = month(InvoiceDate, label = TRUE)) %>%
   group_by(month) %>%
   count() %>%
   ungroup() %>%
   mutate(month = fct_reorder(month, n)) %>%
   ggplot() +
   geom_histogram(aes(month, n),
                  stat = "identity",
                  fill = "#4682B4",
                  orientation = "horizontal") +
   coord_flip() +
   theme_minimal() +
   labs(x = "month",
        y = "count")
   
   
 
 # Worst selling products with best selling products
 unwanted <- gross_revenue %>% 
   filter(grepl("20..-(12|11|10|09)-.", InvoiceDate)
   ) %>%
   group_by(Description) %>%
   summarise(count = n()) %>%
   mutate(pct = count / sum(count)*100) %>%
   ungroup() %>%
   arrange(pct) %>%
   head(30)
 
 
 wanted <- gross_revenue %>% 
   filter(grepl("20..-(12|11|10|09)-.", InvoiceDate)
   ) %>%
   group_by(Description) %>%
   summarise(count = n()) %>%
   mutate(pct = count / sum(count)*100) %>%
   ungroup() %>%
   arrange(desc(pct)) %>%
   head(30)
 
 rbind(unwanted, wanted[4 : 10,]) %>%
   arrange(desc(pct))
   
