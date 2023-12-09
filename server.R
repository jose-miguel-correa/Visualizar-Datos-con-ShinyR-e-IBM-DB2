# Librerías

library(shiny)
library(DBI)
library(RJDBC)
library(DT)
library(ggplot2)
library(Cairo)
library(plotly)


# JDBC connection setup
drv <- JDBC(driverClass="com.ibm.db2.jcc.DB2Driver", classPath="db2jcc4.jar")
con <- dbConnect(drv, "jdbc:db2://<id_servicio_ibm_db2_cloud>.databases.appdomain.cloud:<puerto>/<database_name>:sslConnection=true;", "usuario", "contraseña")


# Define server logic required to draw a histogram
function(input, output, session) {

  # Insertar datos al DB2
  observeEvent(input$submit_btn, {
    name <- input$name
    age <- input$age
    query <- sprintf("INSERT INTO <nombre_esquema>.<nombre_tabla> (name, age) VALUES ('%s', '%d')", name, age)
    dbSendUpdate(con, query)     
    
    
    # Vaciar inputs al enviar
    updateTextInput(session, "name", value = "")
    updateNumericInput(session, "age", value = "")
    
  })
  
  # Eliminar datos
  
  observeEvent(input$delete_btn, {
    condition1 <- input$eliminar_nombre
    condition2 <- input$eliminar_edad
    
    updateTextInput(session, "eliminar_nombre", value = "")
    updateNumericInput(session, "eliminar_edad", value = "")
    
    delete_query <- glue::glue_sql("DELETE FROM <nombre_esquema>.<nombre_tabla> WHERE NAME = {condition1} AND AGE = {condition2}",
                                   .con = con)
    
    dbSendUpdate(con, delete_query)
    
  })
  
  # Ver tabla
  output$table <- renderTable({
    dbGetQuery(con, "SELECT * FROM <nombre_esquema>.<nombre_tabla>")
  })

  # Actualizar tabla
  observeEvent(input$refresh_btn, {
    output$table <- renderTable({
      dbGetQuery(con, "SELECT * FROM <nombre_esquema>.<nombre_tabla>")
    })
  })

  # Ver gráfica
  output$age_plot <- renderPlotly({
    data <- dbGetQuery(con, "SELECT * FROM <nombre_esquema>.<nombre_tabla>")
    plot <- plot_ly(data, x = ~NAME, y = ~AGE, type = 'scatter', mode = 'markers')
    plot <- plot %>% layout(xaxis = list(title = "Nombre"), yaxis = list(title = "Edad"))
    plot %>% layout(template="plotly_dark")
  })
  
  # Actualizar gráfica
  observeEvent(input$refreshButton, {
    output$age_plot <- renderPlotly({
      data <- dbGetQuery(con, "SELECT * FROM <nombre_esquema>.<nombre_tabla>")
      plot <- plot_ly(data, x = ~NAME, y = ~AGE, type = 'scatter', mode = 'markers')
      plot <- plot %>% layout(xaxis = list(title = "Nombre"), yaxis = list(title = "Edad"))
      plot %>% layout(template="plotly_dark")
    })
  })

}
