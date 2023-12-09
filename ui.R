# Librerías

library(shiny)
library(DT)
library(rsconnect)
library(ggplot2)
library(Cairo)
library(plotly)
library(bslib)


rsconnect::setAccountInfo(name='<nombre_usuario_shinyapps.io>',
                          token='<token_shinyapps.io>',
                          secret='<secret_shinyapps.io>')


# UI, entradas, botones y tabla
fluidPage(
  titlePanel("IBM DB2 Tablas Cliente"),
  theme = bs_theme(bootswatch = "superhero"),
  
  
  # Input form
  sidebarLayout(
    sidebarPanel(
      h4("Insertar Datos"),
      inputPanel(      
        textInput("name", "Escriba un NAME:", ""),
        numericInput("age", "Escriba un AGE:", value=NULL),
        actionButton("submit_btn", "Enviar")),
      
      h4("Eliminar Datos"),
      inputPanel(
        textInput("eliminar_nombre", "Escriba un NAME a eliminar:", ""),
        numericInput("eliminar_edad", "Escriba un AGE a eliminar:", value=NULL),
        actionButton("delete_btn", "Eliminar"))

    ),
    mainPanel(
      tableOutput("table"),
      actionButton("refresh_btn", "Actualizar Tabla"),
      plotlyOutput("age_plot"),
      actionButton("refreshButton", "Actualizar Gráfica"),
    )
  )
  )
