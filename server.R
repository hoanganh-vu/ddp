#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(mlbench)
library(caret)
library(e1071)
data(PimaIndiansDiabetes2)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {

    require(mlbench)
    require(plotly)

    #Plotting tab
    output$example <- renderTable(head(PimaIndiansDiabetes2,5))
    
    inputX <- reactive({
        switch(input$plot_x,
               pregnant = PimaIndiansDiabetes2$pregnant,
               glucose = PimaIndiansDiabetes2$glucose,
               pressure = PimaIndiansDiabetes2$pressure,
               mass = PimaIndiansDiabetes2$mass,
               pedigree = PimaIndiansDiabetes2$pedigree,
               age = PimaIndiansDiabetes2$age)
    })
    inputY <- reactive({
        switch(input$plot_y,
               pregnant = PimaIndiansDiabetes2$pregnant,
               glucose = PimaIndiansDiabetes2$glucose,
               pressure = PimaIndiansDiabetes2$pressure,
               mass = PimaIndiansDiabetes2$mass,
               pedigree = PimaIndiansDiabetes2$pedigree,
               age = PimaIndiansDiabetes2$age)
    })
    output$plot1 <- renderPlotly ({
        plot1 <- plot_ly(PimaIndiansDiabetes2, x = ~inputX(), y = ~inputY(), color = ~diabetes, type = "scatter")
        layout(plot1, title = paste("Plotting diabetes against", input$plot_x, " and ", input$plot_y),
               xaxis = list(title = paste(input$plot_x)),
               yaxis = list(title = paste(input$plot_y)))
    })


    #PLM Model app
    require(caret)
    model <- reactive({
        #Make sure there is at least one predictor
        validate(
            need(input$predictors != "", "Please select a set of predictor(s)")
        )

        #Construct formula
        constructFormula <- paste("diabetes ~ ", paste(input$predictors, collapse = " + "))
        output$formula <- renderText(constructFormula)
        
        #Clean data
        cleanData <- PimaIndiansDiabetes2
        cleanData <- cleanData[c(-4,-5)] #remove insulin and tricep which has ~50% NA
        for(i in 1:6){
            cleanData[is.na(cleanData[,i]), i] <- mean(cleanData[,i], na.rm = TRUE)
        }
        
        #Split data for training/testing
        trainPerc <- input$perc_train
        inTrain <- createDataPartition(y=cleanData$diabetes, p=trainPerc, list=FALSE)
        training <- cleanData[inTrain,]
        testing <- cleanData[-inTrain,]
        
        #Build model
        glmMod <- train(as.formula(constructFormula), method="glm", family="binomial", data=training)
        
        #Result
        testCfMatrix <- confusionMatrix(testing$diabetes, predict(glmMod,testing,method="response"))
        trainCfMatrix <- confusionMatrix(training$diabetes, predict(glmMod,method="response"))
        
        result <- data.frame(Coefficients = summary(glmMod)$coeff, Train_Accuracy = trainCfMatrix$overall["Accuracy"], Test_Accuracy = testCfMatrix$overall["Accuracy"])
        return(result)
    })
    output$tableSumm <- renderTable(model())
    output$consoleSumm <- renderPrint(model())
    
    #tab 3: 
})
