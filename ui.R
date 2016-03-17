# ui.R
library(shiny)
library(leaflet)

shinyUI(fluidPage(
  titlePanel("Toimialatilanne ja muutos"),
  
  fluidRow(
    
    column(2,
           radioButtons("Aineisto", label = h5("Aineisto"), 
                        choices = list("Muutos" = 1, "TA% 2007" = 2,
                                       "TA% 2012" = 3)),
           
           sliderInput("cut1", label = "jako", min = 1, max = 20, value = 15, step = 1),
           
           selectInput("Kartta1", label = "Kartta1", 
                       choices = list("A" = 1, "B,C" = 2, "D,E,F" = 3,
                                      "G,H,I...,T,U,X" = 4, "J,K,L,M" = 5,
                                      "N,O" = 6, "P" = 7, "Q" = 8), selected = 1),

           selectInput("Kartta2", label = "Kartta2", 
                       choices = list("A" = 1, "B,C" = 2, "D,E,F" = 3,
                                      "G,H,I...,T,U,X" = 4, "J,K,L,M" = 5,
                                      "N,O" = 6, "P" = 7, "Q" = 8), selected = 2),
           
           selectInput("Kartta3", label = "Kartta3", 
                       choices = list("A" = 1, "B,C" = 2, "D,E,F" = 3,
                                      "G,H,I...,T,U,X" = 4, "J,K,L,M" = 5,
                                      "N,O" = 6, "P" = 7, "Q" = 8), selected = 3)
    ),
    
    column(10,
    tabsetPanel(
      tabPanel("Kartat",
               column(4,
                      plotOutput("Kartta1")
                      ),    
               column(4,
                      plotOutput("Kartta2")
                      ),
               column(4,
                      plotOutput("Kartta3")
                      )
               ),
      tabPanel("Interaktiivinen",
               leafletOutput("Interaktiivinen")
               ),
      tabPanel("Muuttujakuvaukset",
               h2("Muuttujakuvaukset"),
               p("A Maatalous, metsätalous ja kalatalous"),
               p("B,C Kaivostoiminta ja louhinta sekä teollisuus"),
               p("D,E,F Sähkö-, kaasu- ja lämpöhuolto, jäähdytysliiketoiminta, 
                 Vesihuolto, viemäri- ja jätevesihuolto, jätehuolto ja muu ympäristön puhtaanapito
                 sekä rakentaminen"),
               p("G,H,I...,T,U,X Tukku- ja vähittäiskauppa; moottoriajoneuvojen ja moottoripyörien korjaus,
                 Kuljetus ja varastointi, Majoitus- ja ravitsemistoiminta, Taiteet, viihde ja virkistys,
                 Muu palvelutoiminta, Kotitalouksien toiminta työnantajina; kotitalouksien eriyttämätön 
                 toiminta tavaroiden ja palvelujen tuottamiseksi omaan käyttöön, Kansainvälisten 
                 organisaatioiden ja toimielinten toiminta, Toimiala tuntematon"),
               p("J,K,L,M Informaatio ja viestintä, Rahoitus- ja vakuutustoiminta, Kiinteistöalan toiminta,
                 Ammatillinen, tieteellinen ja tekninen toiminta"),
               p("N,O Hallinto- ja tukipalvelutoiminta, Julkinen hallinto ja maanpuolustus; 
                 pakollinen sosiaalivakuutus"),
               p("P Koulutus"),
               p("Q Terveys- ja sosiaalipalvelut")
               )
      )
    )
  ),
 
  fluidRow(
    
    column(2,
           selectInput("Värikartta", "Värikartta", 
                choices = list("Spectral" = 1, "Puna-kelta-vihreä" = 2, "Puna-kelta-sininen" = 3, 
                               "Puna-harmaa" = 4, "Puna-sini" = 5, "Oranssi-purppura" = 6, 
                               "Purppura-vihreä" = 7, "Pinkki-vihreä" = 8, "Ruskea-sini-vihreä" = 9,
                               "Kelta-oranssi-punainen" = 10, "Kelta-vihreä" = 11,
                               "Harmaat" = 12, "Purppura-sini-vihreä" = 13), selected = 1),
           
           uiOutput("Kunnat"),
           
           h5("Asteikon säädöt"),
           uiOutput("Minimi"),
           uiOutput("Maksimi")
           ),   
    
       
    column(10,
           plotOutput("Profiilit")
           )
    
    
    )
    
  )
)  

