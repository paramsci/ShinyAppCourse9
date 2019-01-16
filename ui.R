library(shiny)
library(caret)
library(e1071)
# Define UI for application that draws a histogram
ui <- fluidPage(
  
  # Application title
  titlePanel("Classification of Iris Data"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
      selectInput("model","Choose a Model:",
                  choices = c("K nearest Neigbors"= "knn",
                              "Linear Discriminant Analysis"="lda",
                              "Classification & Regression Trees"= "rpart",
                              "Support Vector Machines"= "svmRadial") ),
      actionButton("update","Apply Model"),
      hr(),
      sliderInput("p",
                  "Validation Set parameter:",
                  min = 0,
                  max = 1,
                  value = 0.8),
      checkboxInput("crossval","Cross Validation", FALSE)
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      plotOutput("predvsact"),
      tableOutput("crossTable"),
      textOutput("Accuracy")
    )
  )
)
