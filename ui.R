#
# This is the user-interface for Breast Cancer Prediction App
# 

library(shiny)
library(plotly)

# Define UI for application that draws a histogram
shinyUI(fluidPage(

    # Application title
    titlePanel("Diabetes Data Exploration and Modelling"),

    h4("Learning Data Analysis with ", code("PimaIndianDiabetes2"), " dataset in R."),
    h5("We are going to explore the data using interactive plots and create linear models based on our findings."),
    tabsetPanel(
        tabPanel("Plot", fluid=TRUE,
                 sidebarLayout(
                     sidebarPanel(
                         selectInput("plot_x", "Select Predictors for Plot on x axis", c("pregnant", "glucose", "pressure", "mass", "pedigree", "age"), selected = "pregnant"),
                         selectInput("plot_y", "Select Predictors for Plot on y axis", c("pregnant", "glucose", "pressure", "mass", "pedigree", "age"), selected = "glucose"),
                         submitButton("Submit")
                     ),
                     mainPanel(
                         h4("This tab is used for exploratory data analysis."),
                         tags$div("One of the first steps that we usually take is to plot the data against different predictors to identify trends or patterns."),
                         tags$div("In this application, ", code("PimaIndiansDiabetes2"), " dataset from ", code("mlbench")," library is used."),
                         h5("Below is a glance of how the data look like:"),
                         tableOutput("example"),
                         h5("Now let's move on to the exciting part!"),
                         tags$div("You can select the predictors on the left side bar and see how the positive/negative diabetes cases are distributed along these parameters. 
                                  You might be able to find relationships between some predictors and diabetes!"),tags$br(),
                         plotlyOutput("plot1"),
                     )
                 )),
        tabPanel("GLM Model", fluid=TRUE,
                 sidebarLayout(
                     sidebarPanel(
                         sliderInput("perc_train",
                                     "% of observations that go to training set",
                                     min = .5,
                                     max = .9,
                                     value = .7,
                                     step = .05),
                         selectInput("predictors", "Select Predictors for Linear Model", c("pregnant", "glucose", "pressure", "mass", "pedigree", "age"), multiple=TRUE),
                         submitButton("Submit")
                     ),
                     # Show a plot of the generated distribution
                     mainPanel(
                         h4("Now let's create linear model and use it to do prediction!"),
                         tags$div("You have identified some relationships between certain predictors and diabetes in the first tab. 
                                  You may expect that if we try to build a model to predict diabetes, the variables that have strong relationships with diabetes should be included."),
                         tags$div("Select those predictors on the left side bar and click Submit to construct a Generalized Linear Model (binomial)."), tags$br(),
                         tags$div("We are going to split ", code("PimaIndianDiabetes2"), " into training and testing sets. 
                                  Training set will be used to train the model, and testing set will be used to evaluate your predictions!"),
                         h5("You can set the percentage that goes to training set using the slider bar on the left. It is default to 70%."),
                         h5("Selected formula is:"),
                         textOutput("formula"),
                         tableOutput("tableSumm"),
                         h5("More precise details can be found below:"),
                         verbatimTextOutput("consoleSumm")
                         )
                     )
                 ),
    tabPanel("Best Model?", fluid=TRUE,
             mainPanel(
                 h4("So the question is: Is there a best model?"),
                 tags$div("According to famous statistician George Box, \"", em("All models are wrong"), "\"."),
                 tags$div("However, each of the models that you have constructed in tab 2 is useful in the sense that it explains
                          diabetes to a certain level. The Test Accuracy represents the accuracy of your model when predicting new observations.
                          You can see that your model is doing a pretty good job!"),
                 tags$div("We hope that this simple interactive experience will motivate you to dive deeper into data analysis."),
                 h4("Thank you and see you next time!")
             )
    )
        )
    ))
