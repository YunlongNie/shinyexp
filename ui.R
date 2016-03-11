library(shinyBS)
ui <- fluidPage(
    
    numericInput("sigma", 
        label = h3("noise level (>0)"), 
        value = 1),
    br(),
   numericInput("nmax", 
        label = h3("approximate maximum number of points(integer)"), 
        value = 10),

   numericInput("speed", 
        label = h3("active time"), 
        value = 500),
    br(),
    # actionButton("left", "Left",width="200px"),
    bsButton("left", label = "Left", size = 'large'),
    actionButton("start", "Start",width="200px"),
    bsButton("right", label = "Right", size = 'large'),
    br(),
    br(),
    bsButton("showall", label = "Show the results", size = 'large'),
    # actionButton("showall", "Showall"), 
    br(),
    bsButton("reset", label = "Reset", size = 'large'),
    # actionButton("reset", "Reset"), 
    plotOutput("plot", width = "800px", height = "400px")

)
