library(shiny)
library(shinycssloaders)

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
  fluidRow(column(4, offset = 3, textOutput("error"))),
  fluidRow(column(4, offset = 3, plotOutput("make_plot")))
)
