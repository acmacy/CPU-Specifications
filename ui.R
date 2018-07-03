library(shiny)
library(plotly)
shinyUI(fluidPage(
  
  titlePanel("Performance of Computer CPUs"),
  sidebarLayout(position = "left",
    sidebarPanel(
      p("INSTRUCTIONS: Select the specifications you want and click on the SUBMIT button."),
      br(),
      submitButton("SUBMIT"),
      sliderInput('syct', "Cycle Time", min=min(cpus$syct), max = max(cpus$syct), value = c(min(cpus$syct), max(cpus$syct))),
      sliderInput('mmin', "Minimum memory", min=min(cpus$mmin), max = max(cpus$mmin), value = c(min(cpus$mmin), max(cpus$mmin))),
      sliderInput('mmax', "Maximum memory", min=min(cpus$mmax), max = max(cpus$mmax), value = c(min(cpus$mmax), max(cpus$mmax))),
      sliderInput('cach', "Cache Size", min=min(cpus$cach), max = max(cpus$cach), value = c(min(cpus$cach), max(cpus$cach))),
      sliderInput('chmin', "Minimum channels", min=min(cpus$chmin), max = max(cpus$chmin), value = c(min(cpus$chmin), max(cpus$chmin))),
      sliderInput('chmax', "Maximum channels", min=min(cpus$chmax), max = max(cpus$chmax), value = c(min(cpus$chmax), max(cpus$chmax)))
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      tabsetPanel(
        tabPanel("How to Use", htmlOutput("Documentation")),
        tabPanel("Result", tableOutput("Result")),
        tabPanel("Performance", plotlyOutput("Plot", width = "500px"))
      )
    )
  )
))
