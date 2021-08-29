#' Aviso: en este documento se encuentra el código que usé para resolver los 
#' ejercicios de los módulos de Shiny de RStudio. Como me interesa que quede 
#' como fuente, voy a dejar todo el código, pero hay que recordar que algunas 
#' cosas pertenecen a distintos ejercicios. Más que nada aparecerá comentado
#' el código para el output que no corresponda a la última versión.

# Load packages ----------------------------------------------------------------

library(shiny)
library(ggplot2)
library(tidyverse)
library(DT)

# Load data --------------------------------------------------------------------

load("movies.RData")
n_total <- nrow(movies)
all_studios <- sort(unique(movies$studio))
min_date <- min(movies$thtr_rel_date)
max_date <- max(movies$thtr_rel_date)

# Define UI --------------------------------------------------------------------

ui <- fluidPage( # tipo de página con dos elementos: un sidebar a la izquierda
                 # y una sección principal a la derecha
  sidebarLayout(
    
    # Inputs: Select variables to plot
    sidebarPanel(
      
      # Select variable for y-axis
      selectInput(
        inputId = "y",
        label = "Y-axis:", # etiqueta que ve el usuario
        choices = c( # opciones disponibles 
          "IMDB rating" = "imdb_rating",
          "IMDB number of votes" = "imdb_num_votes",
          "Critics score" = "critics_score",
          "Audience score" = "audience_score",
          "Runtime" = "runtime"
        ),
        selected = "audience_score" # selección por default
      ),
      
      # Select variable for x-axis
      selectInput(
        inputId = "x",
        label = "X-axis:",
        choices = c(
          "IMDB rating" = "imdb_rating",
          "IMDB number of votes" = "imdb_num_votes",
          "Critics score" = "critics_score",
          "Audience score" = "audience_score",
          "Runtime" = "runtime"
        ),
        selected = "critics_score"
      ),
      
      # Select variable for color
      selectInput(
        inputId = "z",
        label = "Color by:",
        choices = c(
          "Title type" = "title_type",
          "Genre" = "genre",
          "MPAA rating" = "mpaa_rating",
          "Critics rating" = "critics_rating",
          "Audience rating" = "audience_rating"
        ),
        selected = "mpaa_rating"
      ),
      
      # Set alpha level
      sliderInput(inputId = "alpha", 
                  label = "Transparency", 
                  min = 0, max = 1, 
                  value = 0.5),
      
      # Show data table
      checkboxInput(inputId = "show_data",
                    label = "Show data table",
                    value = TRUE), # valor inicial
      
      # # Selección de un número
      # HTML(paste("Enter a value between 1 and", n_total)),
      
      # Set number
      numericInput(inputId = "n",
                   min = 1, 
                   max = n_total,
                   value = 30,
                   step = 1,
                   label =  HTML(paste("Enter a value between 1 and", n_total))),
      
      # Select studio
      selectInput(inputId = "studio",
                  label = "Select studio:",
                  choices = all_studios,
                  selected = "20th Century Fox",
                  selectize = TRUE,
                  multiple = TRUE),
      
      # Select date
      HTML(paste0("Movies released since the following date will be plotted. 
                 Pick a date between ", "2013-01-01", " and ", "2014-01-01", ".")),
      
      br(), br(),
      
      dateRangeInput(inputId = "date",
                label = "Select date:",
                start = "2013-01-01",
                end = "2014-01-01",
                min = min_date, max = max_date,
                startview = "year")
      
    ),
    
    # Output 
    mainPanel(
      
      # Show scatterplot
      plotOutput(outputId = "scatterplot"),
      
      # Show table
      dataTableOutput(outputId = "moviestable"),
      
      # # Display number of observations (ejercicio previo)
      # HTML(paste0("The dataset has ", nrow(movies), 
      #             "observations.")) 
    )
  )
)

# Define server ----------------------------------------------------------------

server <- function(input, output, session) {
  
  # # Output scatterplot
  # output$scatterplot <- renderPlot({
  #   ggplot(data = movies, aes_string(x = input$x, y = input$y, 
  #                                     color = input$z)) +
  #     geom_point(alpha = input$alpha)
  #   })
  
  # # Output table ejercicio previo
  # output$moviestable <- renderDataTable(
  #   if(input$show_data){ # este IF no tiene nada porque es una operación lógica
  #     DT::datatable(data = movies %>% select(1:7),
  #                  options = list(pageLenght = 10),
  #                  rownames = FALSE)
  #     } )
    
  # # Output table
  # output$moviestable <- DT::renderDataTable({
  #   
  #   req(input$n)
  #   
  #   movies_sample <- movies %>%
  #     sample_n(input$n) %>%
  #     select(title:studio)
  #   
  #   DT::datatable(data = movies_sample, 
  #                 options = list(pageLength = 10), 
  #                 rownames = FALSE)
  # 
  
  # # Output data table
  # output$moviestable <- renderDataTable({
  #   movies_from_selected_studios <- movies %>%
  #     filter(studio == input$studio) %>%
  #     select(title:studio)
  #   DT::datatable(data = movies_from_selected_studios, 
  #                 options = list(pageLength = 10), 
  #                 rownames = FALSE)

  # Output scatterplot con fecha
  output$scatterplot <- renderPlot({
    movies_selected_date <- movies %>%
      filter(thtr_rel_date >= as.POSIXct(input$date[1]) # porque hay dos fechas
            & thtr_rel_date <= as.POSIXct(input$date[2]))
    ggplot(data = movies_selected_date, aes(x = critics_score, y = audience_score, color = mpaa_rating)) +
      geom_point()
  
  })
    }


# Create a Shiny app object ----------------------------------------------------

shinyApp(ui = ui, server = server)
