library(tidyverse)
library(treemapify)
library(dygraphs)
library(xts)
library(htmlwidgets)

theme_set(theme_minimal())
#  per Country sales
gross_revenue %>%
  count(Country) %>%
  mutate(Country = fct_reorder(Country, n)) %>%
  filter(n > 20) %>%
  ggplot(aes(fill = n, area = n, label = Country)) +
  geom_treemap() +
  geom_treemap_text(place = "centre",
                    color = "white") +
  theme(legend.position = "none")

# sales per year
gross_revenue %>%
  mutate(date = format(InvoiceDate, "%Y-%m-01")) %>%
  mutate(date = as.Date(date)) %>%
  group_by(date) %>%
  summarise(total_sales = sum(Price * Quantity)) %>%
  mutate(total_sales = parse_number(format(total_sales, nsmall = 2))) %>%
  ggplot(aes(date, total_sales)) +
  geom_point(color = "#4682B4",
             size = 2)  +
  geom_line(color = "#4682B4",
            size = 1) +
  labs(title = "Total sales by year",
       y = "Total sales",
       x = "") +
  theme(text = element_text(size = 20),
        plot.title = element_text(hjust = -4))


# Seasonal sales

## Monthly
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
  labs(title = "Monthly sales",
       x = "",
       y = "Count")+
  theme(text = element_text(size = 20),
        plot.title = element_text(hjust = -0.13),
        axis.title = element_text(color = "#4a4a4a"))

## Quarterly
gross_revenue %>%
  filter(!grepl("^2009-.", InvoiceDate)) %>%
  mutate(quarter = as.factor(quarter(InvoiceDate))) %>%
  group_by(quarter) %>%
  count() %>%
  ungroup() %>%
  mutate(quarter = fct_reorder(quarter, n)) %>%
  ggplot() +
  geom_histogram(aes(quarter, n),
                 stat = "identity",
                 fill = "#4682B4",
                 orientation = "horizontal") +
  coord_flip() +
  theme_minimal() +
  labs(title = "Quarterly sales",
       subtitle = "A sum of all sales made by quarter",
       x = "",
       y = "Count")+
  theme(text = element_text(size = 20),
        plot.title = element_text(hjust = -0.06),
        plot.subtitle = element_text(size = 18,
                                     color = "#4a4a4a",
                                     hjust = -0.08),
        axis.title = element_text(color = "#4a4a4a"))

## Semesterly
gross_revenue %>%
  filter(!grepl("^2009-.", InvoiceDate)) %>%
  mutate(semester = as.factor(semester(InvoiceDate))) %>%
  group_by(semester) %>%
  count() %>%
  ungroup() %>%
  mutate(semester = fct_reorder(semester, n)) %>%
  ggplot() +
  geom_histogram(aes(semester, n),
                 stat = "identity",
                 fill = "#4682B4",
                 orientation = "horizontal") +
  coord_flip() +
  theme_minimal() +
  labs(title = "Quarterly sales",
       subtitle = "A sum of all sales made by semester",
       x = "",
       y = "Count")+
  theme(text = element_text(size = 20),
        plot.title = element_text(hjust = -0.06),
        plot.subtitle = element_text(size = 18,
                                     color = "#4a4a4a",
                                     hjust = -0.08),
        axis.title = element_text(color = "#4a4a4a"))

# Mean per invoice
gross_revenue %>%
  group_by(Invoice) %>%
  summarise(mean_total_price = mean(Quantity * Price)) %>%
  ungroup() %>%
  ggplot() +
  geom_histogram(aes(mean_total_price),
                 col = "grey",
                 fill = "#4682B4",
                 bins = 15) +
  scale_x_continuous(breaks = seq(0, 100, 10), 
                     lim = c(0 , 100)) +
  theme_minimal() +
  labs(title = "Mean value spent per invoice",
       x = "Mean spent",
       y = "Count") +
  theme(text = element_text(size = 20),
        plot.title = element_text(hjust = -0.13),
        axis.title = element_text(color = "#4a4a4a"))

# Best selling
gross_revenue %>%
  filter(grepl("2010-.", InvoiceDate)) %>%
  group_by(Description) %>%
  summarise(n = sum(Quantity) / 1000) %>%
  arrange(desc(n)) %>%
  mutate(Description = fct_reorder(Description, n)) %>%
  head(10) %>%
  ggplot() +
  geom_point(aes(Description, n),
           color = "#4682B4",
           size = 3) +
  coord_flip() +
  theme_minimal() +
  labs(title = "Best selling itens",
       x = "",
       y = "Amount sold
(by thousand)") +
  theme(text = element_text(size = 20),
        plot.title = element_text(hjust = -1),
        axis.title = element_text(color = "#4a4a4a"))
  

# Sales year
data <- gross_revenue %>%
    group_by(InvoiceDate) %>%
    summarise(total_sales = sum(Price * Quantity)) %>%
    mutate(total_sales = parse_number(format(total_sales, nsmall = 2)))

don <- xts(x = data$total_sales, order.by = data$InvoiceDate)

dygraph(don) %>%
  dyOptions(labelsUTC = TRUE,
            fillGraph=TRUE,
            fillAlpha=0.1,
            drawGrid = FALSE,
            colors="#4682B4") %>%
  dyRangeSelector() %>%
  dyCrosshair(direction = "vertical") %>%
  dySeries(label = "Total sales")
  dyHighlight(highlightCircleSize = 5,
              highlightSeriesBackgroundAlpha = 0.2,
              hideOnMouseOut = FALSE)  %>%
  dyRoller(rollPeriod = 1)

  