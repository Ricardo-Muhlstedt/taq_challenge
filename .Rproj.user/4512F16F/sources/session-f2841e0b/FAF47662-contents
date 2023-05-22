library(tidyverse)
library(treemapify)
library(dygraphs)

uci <- a("UCI Machine Learning Repository",
         href = "https://archive.ics.uci.edu/ml/datasets/Online+Retail+II")

ui <- fluidPage(
  
  
  h1("Instituto Taqtile challenge"),
  
  uiOutput("uci"),
  
  h3("This Online Retail II data set contains all the transactions occurring for a UK-based and registered, non-store online retail between 01/12/2009 and 09/12/2010.
  The company mainly sells unique all-occasion gift-ware.
  Many customers of the company are wholesalers."),
  
  hr(),
  
      fluidRow(
        column(12,
               fluidRow(column(6,
                               plotOutput("country_sales",
                                          height = "290px")),
                        column(6,
                               plotOutput("sales_year",
                                          height = "290px"))
               ),
               fluidRow(br()
                        ),
               fluidRow(column(6,
                               plotOutput("season_sales")),
                        column(6,
                               plotOutput("best_selling"))),
               fluidRow(br()
                        ),
               fluidRow(column(6,
                               plotOutput("mean_invoice",
                                          height = "290px")),
                        column(4,
                               numericInput("bins",
                                           label = "Bin width",
                                           value = 15,
                                           step = 1),
                               sliderInput("range",
                                           label = "Range",
                                           value = c(0, 100),
                                           min = 0,
                                           max = 250),
                               offset = 2),
                        ),
               fluidRow(br()
               ),
               fluidRow(column(12,
                               dygraphOutput("year_sales",
                                             height = "290px"))
   )
  )
 )
)

