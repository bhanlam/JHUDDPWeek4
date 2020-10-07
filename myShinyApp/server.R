#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(datasets)
data("airquality")

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
    
    #airquality
    output$distPlot <- renderPlot({
        
        # obtain selected variable
        variType <- switch(input$vari,
                           Ozone = airquality$Ozone,
                           Solar = airquality$Solar.R,
                           Wind = airquality$Wind,
                           Temperature = airquality$Temp,
                           airquality$Ozone)
        
        # generate bins based on input$bins from ui.R
        x    <- variType
        bins <- seq(min(x,na.rm = TRUE), max(x,na.rm = TRUE), length.out = input$bins + 1)
        
        # draw the histogram with the specified number of bins
        hist(variType, breaks = bins, col = 'darkgray', border = 'white', 
             main = "Histogram", xlab = input$vari)
        
    })
    
    #lm
    model <- reactive({
        
        # obtain x and y variable
        xvari <- switch(input$xvar,
                        Ozone = "Ozone",
                        Solar = "Solar.R",
                        Wind = "Wind",
                        Temperature = "Temp",
                        "Ozone")
        
        yvari <- switch(input$yvar,
                        Ozone = "Ozone",
                        Solar = "Solar.R",
                        Wind = "Wind",
                        Temperature = "Temp",
                        "Solar.R")
        
        #obtain brushed data
        brushed_data <- brushedPoints(airquality, input$brush1,
                                      xvar = xvari, yvar = yvari)
        if(nrow(brushed_data) < 2){
            return(NULL)
        }
        data = brushed_data
        lm(data[,yvari] ~ data[,xvari])
    })
    
    output$slopeOut <- renderText({
        if(is.null(model())){
            "No Model Found"
        } else {
            model()[[1]][2]
        }
    })
    
    output$intOut <- renderText({
        if(is.null(model())){
            "No Model Found"
        } else {
            model()[[1]][1]
        }
    })
    
    output$plot1 <- renderPlot({
        
        # obtain x and y variable
        xvari <- switch(input$xvar,
                        Ozone = "Ozone",
                        Solar = "Solar.R",
                        Wind = "Wind",
                        Temperature = "Temp",
                        "Ozone")
        
        yvari <- switch(input$yvar,
                        Ozone = "Ozone",
                        Solar = "Solar.R",
                        Wind = "Wind",
                        Temperature = "Temp",
                        "Solar.R")
        
        # plot graph depending on the radio button inputs
        plot(airquality[,xvari], airquality[,yvari], 
             col=as.factor(airquality$Month),
             xlab = "Ozone",
             ylab = "Solar", main = "Airquality Metrics",
             cex = 1.5, pch = 16, bty = "n")
        
        legend("right",month.abb[unique(airquality$Month)],
               col=1:length(airquality$Month),pch=16,
               title = "Months")
      
        if(!is.null(model())){
            abline(model(), col = "blue", lwd = 2)
        }
    })

})
