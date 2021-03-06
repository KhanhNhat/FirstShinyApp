library(shiny)
library(ggplot2)
library(tibble)
library(dplyr)

my_mtcars = mtcars
my_mtcars$am = as.factor(my_mtcars$am)
my_mtcars$cyl = as.factor(my_mtcars$cyl)
my_mtcars = rownames_to_column(my_mtcars, var = 'car')

ui <- fluidPage(
  tags$header(
    tags$title('Scatter Plot of mtcars dataset'),
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
                  selected = 'am'),
      
      br(),
      
      downloadButton('downloadData', 'Dowload your selected data here')
    ),
    mainPanel(
      plotOutput(outputId = 'scatterPlot', brush = 'plotBrush'),
      DT::dataTableOutput(outputId = 'mtcarsTable')
    )
  )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
  selectedData = reactive({
    brushedPoints(my_mtcars %>% select(car:qsec, am),
                  brush = input$plotBrush)
  })
  
  output$scatterPlot = renderPlot(
    ggplot(data = my_mtcars, aes_string(y = input$y, col = input$col)) +
      geom_point(aes(x = hp), size = 4, alpha = 0.6)
  )
  
  output$mtcarsTable = DT::renderDataTable(
    DT::datatable(data =selectedData(),
                 options = list(pageLength = 10),
                 rownames = FALSE)
  )
  
  output$downloadData = downloadHandler(
    filename = function(){paste0('data_', Sys.Date(),'.csv')},
    content = function(file){write.csv(selectedData(), file)}
  )
}

# Run the application 
shinyApp(ui = ui, server = server)

