# Define server logic required to draw a histogram
function(input, output,session) {
  
  dataset <- iris

  crossTable <- eventReactive(
    input$update,{
    # browser()
    validationSet <- createDataPartition(dataset$Species, p = input$p, list = FALSE)
    validation <- dataset[-validationSet,]
    dataset <- dataset[validationSet,]
    x<- dataset[,1:4]
    y<- dataset[,5]
    metric <- "Accuracy"
    set.seed(7)
    str1 <- input$model
    if ( input$crossval) {
    control <- trainControl(method = "cv", number = 10)
    fit <- train(Species~.,data = dataset, method= str1,
                 metric = metric, trControl = control)
    } else{
      fit <- train(Species~.,data = dataset, method= str1,
                   metric = metric)  
    }
    
    
    pred1 <- predict(fit,validation)
    # browser()
    xx<- as.table(confusionMatrix(pred1,validation$Species)[[2]])
    acc <- confusionMatrix(pred1,validation$Species)[[3]][1]
    isolate({
      withProgress({
        setProgress(message = "Processing...")
            })
    })
    return(list(confmat = xx, accuracy = acc,pred = pred1, val = validation$Species))
    
  })
  
  
  output$crossTable <- renderTable(crossTable()$confmat)
  output$Accuracy <- renderText(paste("Accuracy = ",crossTable()$accuracy))
  output$predvsact <- renderPlot({
    x<- crossTable()$pred
    y<- crossTable()$val
    plot(x,y)
  })
  

}