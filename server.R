library(shiny)
library(shinycssloaders)
library(coauthornetwork)
library(robotstxt)

server <- function(input, output, session) {
  
  observeEvent(input$make_plot, {
    validate(
      need(input$url_box, "Please provide a valid Google Schoolar URL")
    )
    
    print(robotstxt::robotstxt("https://scholar.google.es/")$text)
    
    not_error <-
      tryCatch(
        grab_network(
          isolate(input$url_box),
          n_coauthors = as.numeric(isolate(input$n_coauthors))
        ),
        error = function(e) "error"
      )
    print(not_error)
    # length because it returns a tibble and it gives a warning
    # for the second condition of not having the same length
    if (length(not_error) == 1 && not_error == "error") {
      
      output$error <- renderText(safeError(stop("Cannot connect to Google Scholar. Is the URL you provided correct?")))
      
    } else {
      output$error <- renderText("")
      the_plot <- plot_coauthors(not_error)
      print("plot_made!")
      output$make_plot <- renderPlot(the_plot, width = 1000, height = 800)
    }
  })
}