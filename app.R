#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(ggplot2)
library(tibble)
library(dplyr)
my_mtcars = mtcars
my_mtcars$am = as.factor(my_mtcars$am)
my_mtcars$cyl = as.factor(my_mtcars$cyl)
my_mtcars = rownames_to_column(my_mtcars, var = 'car')

# Define UI for application that draws a histogram
ui <- fluidPage(
  tags$header(
    tags$link(rel = 'stylesheet', type = 'text/css', href = 'styles.css')
    ),
  
  tags$div(class = 'myRow',
    tags$h4('Scatter plot of mtcars dataset:')),
  
  sidebarLayout(
    sidebarPanel(
      selectInput(inputId = 'y',
                  label = 'Select variable for y axis:',
                  choices = c('Miles(US) per galon' = 'mpg', 
                              'Displacement' = 'disp', 
                              'Horse power' = 'hp', 
                              'Weight (1000 lbs)' = 'wt', 
                              'Quater mile time (s)' = 'qsec'),
                  selected = 'mpg'),
      selectInput(inputId = 'col',
                  label = 'Color by:',
                  choices = c('Number of cylinders' = 'cyl', 
                              'Transmission' = 'am'),
                  selected = 'am')
    ),
    mainPanel(
      plotOutput(outputId = 'scatterPlot', brush = 'plotBrush'),
      dataTableOutput(outputId = 'mtcarsTable')
    )
  )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
  output$scatterPlot = renderPlot(
    ggplot(data = my_mtcars, aes_string(y = input$y, col = input$col)) +
      geom_point(aes(x = hp), size = 4, alpha = 0.6)
  )
  
  output$mtcarsTable = renderDataTable(
    brushedPoints(my_mtcars %>%
                    select(car:qsec, am), 
                    brush = input$plotBrush),
    options = list(pageLength = 10)
  )
}

# Run the application 
shinyApp(ui = ui, server = server)

