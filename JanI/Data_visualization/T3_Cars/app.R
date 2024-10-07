#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#

library(shiny)

# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel(HTML("<h1>Cars plot</h1>
               <p>Plotting speed versus distance</p>")),

    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        sidebarPanel(
            sliderInput("nrows",
                        "Number of rows:",
                        min = 1,
                        max = 50,
                        value = 10)
        ),

        # Show a plot of the generated distribution
        mainPanel(
           plotOutput("carsPlot"),
           dataTableOutput("carsTable")
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {

    output$carsPlot <- renderPlot({
      
        # generate nrows based on input$nrows from ui.R
        # draw the plot
      
        ggplot(cars[1:input$nrows,], aes(x=speed, y=dist))+
        geom_point()
    })
    
    output$carsTable<-renderDataTable({
      
      cars[1:input$nrows,]})
}

# Run the application 
shinyApp(ui = ui, server = server)
