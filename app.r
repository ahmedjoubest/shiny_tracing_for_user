library(shiny)
library(shinyalert)

### Function that we want the user to trace
foo <- function(a) {
  for (i in 1:100){
    Sys.sleep(0.05)
    message("Iteration numero : ", as.character(i))
    a=a+1
  }
  return(a)
}

ui = fluidPage(
  useShinyalert(),
  tags$head(tags$style("#text{color:blue; font-size:15px; font-style:bold; 
 max-height: 170px;}")),
  shinyjs::useShinyjs(),
  actionButton("btn","Click me"),
  textInput("a",'a input :'),
  textOutput("resultat")
)


server = function(input,output, session) {
  
  Data <- reactiveValues()
  
  observeEvent(input$btn, {
    
    ### Loading message + show iterations
    showModal(modalDialog(
      title = "Important message",
      fluidRow(verbatimTextOutput("text",T), )
    ))
    
    withCallingHandlers({
      shinyjs::html("text")
      Data$number <- foo(as.numeric(input$a))
    },
    message = function(m) {
      shinyjs::html(id = "text", html = m$message, add = TRUE)
      
    })
    
    ### Remove modal
    removeModal()
    
    ### Loop done
    shinyalert(text = HTML(
      "<p> Output Calculated </p>"),
      type = "info",
      timer = 0,
      animation = "pop",
      showConfirmButton = TRUE,
      html = TRUE,
      immediate = T)
    
    ### continuation of the shiny code...
    output$resultat <- renderText({
      as.character(Data$number)
    })
  })
  
}
shinyApp(ui, server)
