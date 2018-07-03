library(shiny)
library(MASS)
library(plotly)
library(dplyr)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
   
  t <- function() {
    data("cpus")
    cpus <- cpus[cpus$syct >= input$syct[[1]] & cpus$syct <= input$syct[[2]],]
    cpus <- cpus[cpus$mmin >= input$mmin[[1]] & cpus$mmin <= input$mmin[[2]],]
    cpus <- cpus[cpus$mmax >= input$mmax[[1]] & cpus$mmax <= input$mmax[[2]],]
    cpus <- cpus[cpus$cach >= input$cach[[1]] & cpus$cach <= input$cach[[2]],]
    cpus <- cpus[cpus$chmin >= input$chmin[[1]] & cpus$chmin <= input$chmin[[2]],]
    cpus <- cpus[cpus$chmax >= input$chmax[[1]] & cpus$chmax <= input$chmax[[2]],]
    colnames(cpus) <- c("Name", "Cycle Time", "Min Memory", 
                        "Max Memory", "Cache Size", "Min Channels", "Max Channels", "Performance")
    return(cpus)
  }
  
  output$Documentation <- renderUI({HTML("<h3>Documentation:<h3/><p>This dataset is a record of the relative performance measure and characteristics of 209 CPUs, with their manufacturer, model, cycle time, minimum main memory, maximum main memory, cache size, minimum number of channels, performance and estimated performance.
        <br/><br/><h4>How this works<h4/><p>When you select the specifications you want, the data about those CPUs that meat the specifications is shown in the RESULTS tab.
        After that, on another tab, PERFORMANCE, the comparitive plot of expected and published performance is shown.
        <br/><br/><h4>About the Variables<h4/>
Name: Manufacturer and Model
<br/>Cycle Time:            In Nanoseconds
<br/>Min Memory:            Minimum Main Memory in KiloBytes
<br/>Max Memory:            Maximum Main Memory in KiloBytes
<br/>Cache Size:            In KiloBytes
<br/>Min Channels:          Minimum Number of Channels
<br/>Max Channels:          Maximum Number of Channels
<br/>Performance:           Published Performance on a Benchmark Mix Relative to an IBM 370/158-3
<br/>Estimated Performance: Estimated Performance (by Ein-Dor & Feldmesser).
                                ")})
  
  
  
  output$Result <- renderTable(t()[,1:8])
  
  output$Plot <- renderPlotly({
    t = t()[,8:9]
    colnames(t) <- c("perf", "estperf")
    maxval <- max(max(t$perf), max(t$estperf)) + 50
    
    s = c(1:maxval)
    s = as.data.frame(s)
    s$estperf = s$s
    s$perf = s$s
    
    p <- plot_ly(t, y = ~perf, x = ~estperf, type="scatter", mode = "markers", name = "Actual") %>% 
      add_trace(y = ~s$perf, x = ~s$perf, mode="line", name = "Ideal") %>%
      layout(yaxis = list(title = "Published Performance", range = c(0, maxval)), 
             xaxis = list(title = "Estimated Performance", range = c(0, maxval)))
    
    return(p)
  })

})
