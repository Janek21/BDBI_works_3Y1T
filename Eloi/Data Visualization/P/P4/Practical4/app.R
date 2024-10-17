library(shiny)
#expressionData <- read.table("FILE.txt", header = T, stringsAsFactors = FALSE)
#expressionData$median_expression <- log(expressionData$median_expression) # Normalize the data

ui <- fluidPage(
  titlePanel("Big Title"),
  "hello my name is ", strong("eloi"), "and today is", em("11/10/24"), br(),
  sidebarLayout(
    sidebarPanel(sliderInput("expressionInput", "Median expression (log)", 
                             min = -6, max = 12,value = c(1, 5)),
                 checkboxGroupInput("tissueInput", "Tissue",
                                    choices = c("Adipose", "Brain", "Liver","Lung", 
                                                "Lymphocytes", "Muscle","Stomach", "Testis"), 
                                    selected = "Brain"),
                 radioButtons("geneAnnotInput", "Gene annotation",
                              choices = c("ENSEMBL", "HAVANA"),
                              selected = "HAVANA"),
                 selectInput("geneTypeInput", "Gene type",
                             choices = c("antisense", "lincRNA", "miRNA", 
                                         "misc_RNA", "protein_coding", "pseudogene", 
                                         "rRNA", "snoRNA", "snRNA"), 
                             selected = "protein_coding"),
                 selectInput("chrInput", "Gene Chr",
                             choices = c(as.character(1:20), "X", "Y"), 
                             selected = "1")
    ),
    mainPanel(strong(textOutput("text")), br(),
      plotOutput("plot"), br(), br(),
              tableOutput("results"))
  )
)

server <- function(input, output) {
  output$plot <- renderPlot({
    
    filtered <-
      expressionData %>%
      filter(median_expression >= input$expressionInput[1],
             median_expression <= input$expressionInput[2],
             tissue %in% input$tissueInput,
             gene_annotation %in% input$geneAnnotInput,
             gene_type %in% input$geneTypeInput
      )
    
    ggplot(filtered, aes(x = median_expression)) +
      geom_histogram(bins = 30, fill = "steelblue", color = "white") +
      scale_x_continuous(name = "Log of Median Expression") +
      scale_y_continuous(name = "Count") + 
      theme_classic() +
      ggtitle("Distribution of Median Expression Levels") + 
      theme(plot.title = element_text(hjust = 0.5, face = "bold"), 
            panel.grid.minor = element_blank()
      )
  })
  output$results <- renderTable({
    filtered <-
      expressionData %>%
      filter(
        median_expression >= input$expressionInput[1],
        median_expression <= input$expressionInput[2],
        tissue %in% input$tissueInput,
        gene_annotation %in% input$geneAnnotInput,
        gene_type %in% input$geneTypeInput
      )
    filtered
  })
  output$text <- renderText({
    filtered <-
      expressionData %>%
      filter(
        median_expression >= input$expressionInput[1],
        median_expression <= input$expressionInput[2],
        tissue %in% input$tissueInput,
        gene_annotation %in% input$geneAnnotInput,
        gene_type %in% input$geneTypeInput
        
      )
    number_of_res <- paste(nrow(filtered) * ncol(filtered), "results found")
    number_of_res
  })
}
shinyApp(ui = ui, server = server)
