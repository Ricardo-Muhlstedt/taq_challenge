
# EDA
raw_data %>%
  ggplot() +
  geom_point(aes(Quantity, Price))

raw_data %>%
  filter(Quantity <= 0) %>%
  count()

raw_data %>%
  filter(Price <= 0) %>%
  count()

raw_data %>%
  filter(Price == max(Price))

raw_data %>%
  filter(!grepl("^[A-Za-z]", StockCode)) %>%
  filter(Price == max(Price))

raw_data %>%
  mutate(date = format(InvoiceDate,
                       format = "%Y")) %>%
  count(date)

raw_data %>%
  mutate(date = format(InvoiceDate,
                       format = "%m")) %>%
  count(date) %>%
  arrange(desc(n))

raw_data %>%
  filter(grepl("^2009-", InvoiceDate)) %>%
  mutate(date = format(InvoiceDate,
                       format = "%m")) %>%
  count(date) %>%
  arrange(desc(n))

raw_data %>%
  filter(!grepl("^C.", Invoice),
         grepl("^[A-Za-z]", StockCode)) %>%
  count()

raw_data %>%
  count(Country) %>%
  arrange(desc(n))

## Expected result, since the company is UK based
raw_data %>%
  count(Country) %>%
  mutate(Country = fct_reorder(Country, n)) %>%
  ggplot() +
  geom_histogram(aes(Country, n),
                 stat = "identity")
