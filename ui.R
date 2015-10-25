library(shiny)
library (ggplot2)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("EIA Inventory Data - Seasonality Charts"),
  
  # Sidebar with a slider input for the number of bins
  sidebarLayout(
    sidebarPanel(
      h1("Documentation"),
      p("This tool lets you visualize the seasonality in US stocks of Crude oil, Motor Gasoline, Distillate Fuel oil , residual fuel oil, and Propane") ,
      p("To use it, just select the variable you like to look at the at the dropbox below"),
      p("The band shows the min/max between 2010:2014."),
      h1("Inputs"),
      selectInput(inputId = "inpVarToPlot",
                  label = "The variable to plot the seasonal for:",
                  choices = c( "Stocks_US_CommercialCrudeOil" ,
                               "Stocks_US_MotorGasoline" , 
                               "Stocks_US_DistillateFuelOil",
                               "Stocks_US_ResidualFuelOil" ,
                               "Stocks_US_PropanePropylene"
                               ),
                  selected = "Stocks_US_Conventional" )
      
      
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      plotOutput("distPlot")
    )
  )
))