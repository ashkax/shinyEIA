library(shiny)
library (dplyr)
library (ggplot2)


eia.Weekly <- read.csv( "./eia.csv") 

# Plotting Function ------------------------------------------------------------------------------------
weekToMonthLabel = c (  "1" = "Jan"  ,
                        "5" = "Feb"  ,
                        "9" = "Mar"  ,
                        "14" =  "Apr"  ,
                        "18" =  "May"  ,
                        "23" =  "Jun"  ,
                        "27" =  "Jul"  ,
                        "31" =  "Aug"  ,
                        "36" =  "Sep"  ,
                        "40" =  "Oct"  ,
                        "44" =  "Nov"  ,
                        "49" =  "Dec"  , 
                        "2" = "" , "3" = "" , "4" = "" , "6" = "" , "7" = "" , "8" = ""  , "10" = "" , "11" = "" , "12" = "" , "13" = "" , "15" = "" , "16" = "" , "17" = "" , "19" = "" , "20" = "" , "21" = "" , "22" = "" , "24" = "" , "25" = "" , "26" = ""  , "28" = "" , "29" = "" , "30" = "" , "32" = "" , "33" = "" , "34" = "" , "35" = ""  , "37" = "" , "38" = "" , "39" = "" , "41" = "" , "42" = "" , "43" = "" ,    "45" = "" , "46" = "" , "47" = "" , "48" = "" , "50" = "" , "51" = "" , "52" = "" 
) 


# Supplementary Functions
plotByYear <- function ( eia.Weekly  , 
                         plotVar         = "Stocks_US_TotalMotorGasoline"     , 
                         individualYears = 2013:2015  , 
                         bandYears       = 2010:2014 
)
{
  dfIndividualYears  <- subset( eia.Weekly 
                                , year %in% individualYears   
                                , c( plotVar , "Date", "year", "week"  ) )
  dfBand <- eia.Weekly[ c( plotVar ,  "year", "week"  )  ] %>%
    filter ( year %in% bandYears )   %>%
    group_by (  week )   %>% 
    summarise_ (   ymini =  paste( "min(" ,  as.name(plotVar)  ,")"  ) 
                   , ymaxi =  paste( "max(" ,  as.name(plotVar)  ,")"  )  )
  
  dfi <- left_join( dfIndividualYears , dfBand ,  by="week" )  
  
  gg <-  ggplot(dfi, aes_string(x="factor(week)"  , y=plotVar , colour="factor(year)", group="year")) +
    geom_ribbon(aes(ymin=ymini , ymax=ymaxi ), colour="grey50", linetype="dotted" , alpha=0.1) +
    geom_line(  size=1 ) + ggtitle( plotVar ) +
    scale_x_discrete( labels = weekToMonthLabel ) #+
    #theme( axis.title.y = element_blank() , axis.title.x = element_blank() ,legend.position="none"  )
  return (gg)
}


# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
  # Expression that generates a histogram. The expression is
  # wrapped in a call to renderPlot to indicate that:
  #
  #  1) It is "reactive" and therefore should re-execute automatically
  #     when inputs change
  #  2) Its output type is a plot
  
  output$distPlot <- renderPlot({
    #x    <- eia.Weekly$Stocks_US_TotalCrudeOil  #faithful[, 2]  # Old Faithful Geyser data
    #bins <- seq(min(x), max(x), length.out = input$bins + 1)
    
    # draw the histogram with the specified number of bins
    #hist(x, breaks = bins, col = 'darkgray', border = 'white')
    plotByYear( eia.Weekly , input$inpVarToPlot)
  })
})