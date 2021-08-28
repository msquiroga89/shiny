# Module 1
## 1.1 Welcome

# Load packages ----------------------------------------------------------------

# install.packages("shiny")
library(shiny)
library(ggplot2)

# Load data --------------------------------------------------------------------

load("movies.RData")

# Define UI --------------------------------------------------------------------

ui <- fluidPage( # una página fluida con filas (elementos en la misma línea) y 
                 # columnas (que definen el espacio horizontal que ocupa cada uno).
                 # Las PF ocupan todo el espacio disponible en el navegador.
  
  sidebarLayout( # tipo de layout con una barra lateral y un panel central.
                 # Shiny usa Bootstrap 2 para los tipos de layout
    
    # Inputs: Select variables to plot
    sidebarPanel(
      
      # Select variable for y-axis
      selectInput(
        inputId = "y",
        label = "Y-axis:", # lo que ve el usuario 
        choices = c("imdb_rating", "imdb_num_votes", "critics_score", "audience_score", "runtime"),
        selected = "imdb_rating" # selecciona el default
      ),
      # Select variable for x-axis
      selectInput(
        inputId = "x",
        label = "X-axis:",
        choices = c("imdb_rating", "imdb_num_votes", "critics_score", "audience_score", "runtime"),
        selected = "imdb_rating"
      )
    ),
    
    # Output: Show scatterplot
    mainPanel(
      plotOutput(outputId = "scatterplot")
    )
  )
)

# Define server ----------- -----------------------------------------------------

server <- function(input, output, session) {
  output$scatterplot <- renderPlot({
    ggplot(data = movies, aes_string(x = input$x, y = input$y)) +
      geom_point()
  })
}

# Create a Shiny app object ----------------------------------------------------

shinyApp(ui = ui, server = server)