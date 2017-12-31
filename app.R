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
my_mtcars = mtcars
my_mtcars$am = as.factor(my_mtcars$am)
my_mtcars$cyl = as.factor(my_mtcars$cyl)

# Define UI for application that draws a histogram
ui <- fluidPage(
  sidebarLayout(
    sidebarPanel(
      selectInput(inputId = 'y',
                  label = 'Select variable for y axis:',
                  choices = c('mpg', 'disp', 'hp', 'wt', 'qsec'),
                  selected = 'mpg'),
      selectInput(inputId = 'col',
                  label = 'Color by:',
                  choices = c('cyl', 'am'),
                  selected = 'am')
    ),
    mainPanel(
      plotOutput(outputId = 'scatterPlot')
    )
  )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
  output$scatterPlot = renderPlot({
    ggplot(data = my_mtcars, aes_string(y = input$y, col = input$col)) +
      geom_point(aes(x = hp), size = 4, alpha = 0.6)
  })
}

# Run the application 
shinyApp(ui = ui, server = server)

