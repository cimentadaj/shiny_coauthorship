library(shiny)
library(shinycssloaders)
library(coauthornetwork)

plot_coauthors <- function (network) {
  graph <- network[c("author", "coauthors")] %>% tidygraph::as_tbl_graph() %>% 
    tidygraph::mutate(closeness = suppressWarnings(tidygraph::centrality_closeness()))
  graph %>%
    ggraph::ggraph(layout = "kk") +
    ggraph::geom_edge_link(ggplot2::aes_string(alpha = "..index..", color = as.character("from")), alpha = 1/3, show.legend = FALSE) + 
    ggraph::geom_node_point(ggplot2::aes_string(size = "closeness"),
                            alpha = 1/2, show.legend = FALSE) +
    ggraph::geom_node_text(ggplot2::aes_string(label = "name"),
                           size = 5, repel = TRUE, check_overlap = TRUE,) +
    ggplot2::labs(title = glue::glue("Network of coauthorship of {network$author[1]}")) +
    ggraph::theme_graph(title_size = 16)
}


ui <- fluidPage(
  
  tags$head(tags$style(HTML("
                            .shiny-text-output {
                            background-color:#fff;
                            }
                            "))),
  
  h1("Explore", span("your network of co-authors in Google Scholar", style = "font-weight: 300"), 
     style = "font-family: 'Source Sans Pro';
     color: #fff; text-align: center;
     background-image: url('texturebg.png');
     padding: 20px"),
  br(),
  
  fluidRow(
    column(6, offset = 3,
           p("With this application you can explore the relationship between author-coauthors from your
             Google Scholar. You can find out who's writing with who and whether they have a closed network
             of collaborators. You only need to provide two things: the end of the URL of the Google Scholar profile
             of interest and the number of coauthors you want to explore.",
             style = "font-family: 'Source Sans Pro';"),
           p("The typical Google Scholar Profile
             is structured like this: https://scholar.google.com/citations?user=amYIKXQAAAAJ&hl=en. Copy the
             end of the URL, citations?user=amYIKXQAAAAJ&hl=en,  and paste it in the URL box", 
             style = "font-family: 'Source Sans Pro';")
    )
  ),
  fluidRow(column(3, offset = 3, textInput('url_box', label = h5("URL box"), placeholder = "citations?user=amYIKXQAAAAJ&hl=en")),
           column(2, selectInput('n_coauthors',
                                             label = h5("Number of co-authors"),
                                             choices = 1:10,
                                             selected = 5),
                  style = "margin-top: -5px;")),
  br(),
  fluidRow(column(3, offset = 5, actionButton("make_plot", "Create plot"))),
  br(),
  br(),
  fluidRow(column(4, offset = 3, plotOutput("make_plot")))
)

server <- function(input, output) {
  
  observeEvent(input$make_plot, {
    
    output$make_plot <- renderPlot({
      print("started making plot")
      
      validate(
        need(input$url_box, "Please provide a valid Google Schoolar URL")
      )
      
      print(plot_coauthors(grab_network(isolate(input$url_box), n_coauthors = as.numeric(isolate(input$n_coauthors)))))
    }, width = 1000, height = 800)
  })
}

shinyApp(ui, server)