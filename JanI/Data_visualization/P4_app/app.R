#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#
library(shiny)
library(dplyr)

library(ggplot2)
expressionData <- read.table("expression_data.txt", header = T, stringsAsFactors = FALSE)
expressionData$median_expression <- log(expressionData$median_expression) # Normalize the data

ui <- fluidPage(
  titlePanel(HTML("<h1>Expression data analysis</h1>
                  <p><strong>Author:</strong> Jan Izquierdo</p>
                  <p>This <em>webpage</em> will show <strong>expression data</strong> </p>")),
  sidebarLayout(
    sidebarPanel(
      #Expression level slider
      sliderInput("expressionInput", "Median expression (log)", 
                  min = -6, max = 12, value = c(1, 5)),
      
      #Tissue checkboxes
      checkboxGroupInput("tissueInput", "Tissue",
                         choices = c("Adipose", "Brain", "Liver",
                                     "Lung", "Lymphocytes", "Muscle",
                                     "Stomach", "Testis"),
                         selected = "Brain"),
      
      #Annotation type buttons
      radioButtons("geneAnnotInput", "Gene annotation",
                   choices = c("ENSEMBL", "HAVANA"),
                   selected = "HAVANA"),
      
      #Gene type selection droplist
      selectInput("geneTypeInput", "Gene type",
                  choices = c("antisense", "lincRNA", "miRNA", "misc_RNA", "protein_coding", "pseudogene", "rRNA", "snoRNA", "snRNA"), 
                  selected = "protein_coding"),
      
      #Strand selection checkboxes
      checkboxGroupInput("strandInput", "Gene strand",
                         choices = c("-", "+"),
                         selected = "+"),
      
      #Gene span slider
      sliderInput("spanInput", "Genome positions", 
                  min = min(expressionData$gene_start), max = max(expressionData$gene_end), 
                  value = c(min(expressionData$gene_start), max(expressionData$gene_end))),
      
      #Type of plot buttons
      radioButtons("typePlotInput", "Type of plot in the second slot",
                   choices = c("Box plot", "Bar graph"),
                   selected = "Bar graph"),
      
      #Table YesNo box
      checkboxInput("TdecInput", "Table(not advised when a lot of data is loaded)", value=FALSE)
      
      #End
      ),
    mainPanel(
      plotOutput("plot"),
      br(),
      plotOutput("Myplot"),
      br(),
      tableOutput("results"),
      
    )
  )
)

server <- function(input, output) {
  #Plot out
  output$plot <- renderPlot({
    
    filtered <-
      expressionData %>%
      filter(median_expression >= input$expressionInput[1],
             median_expression <= input$expressionInput[2],
             tissue %in% input$tissueInput,
             gene_annotation %in% input$geneAnnotInput,
             gene_type %in% input$geneTypeInput
      )
    
    ggplot(filtered, aes(median_expression, fill=gene_chr)) +
      geom_histogram()+scale_fill_viridis_d(option="plasma")+
      facet_grid(tissue_type~.)
  })
  
  #My plot out
  output$Myplot<- renderPlot({
    
    filtered_expData<-
      expressionData %>%
      filter(median_expression >= input$expressionInput[1],
             median_expression <= input$expressionInput[2],
             tissue %in% input$tissueInput,
             gene_annotation %in% input$geneAnnotInput,
             gene_type %in% input$geneTypeInput,
             #My filters
             #Gene span
             gene_start >= input$spanInput[1],
             gene_start <= input$spanInput[2],
             #strand
             gene_strand %in% input$strandInput
      )
    #Plot type
    if (input$typePlotInput=="Box plot"){
      
      #Load the box plots in the app
      ggplot(filtered_expData, aes(x=gene_chr, y=median_expression, fill=gene_strand))+geom_boxplot()+
        labs(x="Chromosomes")+
        scale_fill_manual(values=c("-"="deepskyblue4", "+"="brown4"))+
        theme(axis.text=element_text(size=12))
      
    }else if(input$typePlotInput=="Bar graph"){
      
      #Load the bar graphs in the app
      ggplot(filtered_expData, aes(x=gene_chr, y=median_expression, fill=gene_strand), group_by(gene_strand))+geom_col()+
        labs(x="Chromosomes")+
        scale_fill_manual(values=c("-"="deepskyblue4", "+"="brown4"))+
        theme(axis.text=element_text(size=12))  
    }
  })
  
  
  #Table out
  output$results <- renderTable({
    
    #Table (yes/no) filter
    req(input$TdecInput)
    
    filtered <-
      expressionData %>%
      filter(
        median_expression >= input$expressionInput[1],
        median_expression <= input$expressionInput[2],
        tissue %in% input$tissueInput,
        gene_annotation %in% input$geneAnnotInput,
        gene_type %in% input$geneTypeInput,
        #My filters
        #Gene span
        gene_start >= input$spanInput[1],
        gene_start <= input$spanInput[2],
        #strand
        gene_strand %in% input$strandInput
      )
    filtered
  })
}

shinyApp(ui = ui, server = server)