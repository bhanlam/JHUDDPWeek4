#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(datasets)
data("airquality")

# Define UI for application that draws a histogram
shinyUI(fluidPage(

    # Application title
    titlePanel("New York Air Quality Measurements"),

    # Sidebar with a slider input for number of histogram bins
    sidebarLayout(
        sidebarPanel(
            h3("Histogram controls"),
            
            radioButtons("vari", "Variable for Histogram:",
                         c("Ozone" = "Ozone",
                           "Solar Radiation" = "Solar",
                           "Wind" = "Wind",
                           "Temperature" = "Temperature")),
            sliderInput("bins",
                        "Number of bins:",
                        min = 1,
                        max = 50,
                        value = 30),
            
            h3("Linear model plot controls"),
            
            radioButtons("xvar", "X-axis variable:",
                         c("Ozone" = "Ozone",
                           "Solar Radiation" = "Solar",
                           "Wind" = "Wind",
                           "Temperature" = "Temperature")),
            
            radioButtons("yvar", "Y-axis variable:",
                         c("Solar Radiation" = "Solar",
                            "Ozone" = "Ozone",
                            "Wind" = "Wind",
                           "Temperature" = "Temperature")),
            
            h4("Slope:"),
            textOutput("slopeOut"),
            h4("Intercept:"),
            textOutput("intOut"),
            #h4("Test"),
            #textOutput("testOut")
        ),

        # Show a plot of the generated   distribution
        mainPanel(
            
            p("This is an adjustable histogram of the 
              desired variable in the \"airquality\" dataset. Choose the
              variable you would like to explore from the radio buttons on
              the left. Adjust the frequency bins via the slider to 
              adjust the bin resolution"),
            
            plotOutput("distPlot"),
            
            p("This is an interactive plot that fis a linear regression
              line onto the user selected data. Drag to select a group of points
              to see the fitted line. The x and y axis variables can be 
              selected via the radio buttons on the left. The slope and 
              intercept of the fitted line is displayed below the radio buttons"),
            
            plotOutput("plot1", brush = brushOpts(
                id = "brush1"
            ))
        )
    )
))
