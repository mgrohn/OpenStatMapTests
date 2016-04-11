# server.R
# Kuntien väestö toimialan mukaan


library(sorvi)
library(pxweb)
library(gisfin)
library(RColorBrewer)
library(leaflet)
library(MASS)
library(plyr)

# Koodissa käytetyt toimialakoodit
# Muutos
toimialakoodit<-c("M_A","M_BC","M_DEF","M_GHUX","M_JKLM","M_NO","M_P","M_Q")
# Vanhin hlömäärä
vtoimialakoodit<-c("V_A","V_BC","V_DEF","V_GHUX","V_JKLM","V_NO","V_P","V_Q")
# Vanhin prosentti
vptoimialakoodit<-c("VP_A","VP_BC","VP_DEF","VP_GHUX","VP_JKLM","VP_NO","VP_P","VP_Q")
# Tuorein hlömäärä
ttoimialakoodit<-c("T_A","T_BC","T_DEF","T_GHUX","T_JKLM","T_NO","T_P","T_Q")
# Tuorein prosentti
tptoimialakoodit<-c("TP_A","TP_BC","TP_DEF","TP_GHUX","TP_JKLM","TP_NO","TP_P","TP_Q")


# 041 - Alueella työssäkäyvät (työpaikat) alueen, toimialan (TOL 2008), sukupuolen ja vuoden mukaan 2007-2013
d <- get_pxweb_data(url = "http://pxwebapi2.stat.fi/PXWeb/api/v1/fi/StatFin/vrm/tyokay/041_tyokay_tau_114.px",
                    dims = list(Alue = c('*'),
                                Toimiala = c('*'),
                                Sukupuoli = c('*'),
                                Vuosi = c('*')),
                    clean = TRUE)

# Poimitaan aineistosta vanhin ja tuorein vuosi
Tuorein<-levels(d$Vuosi)[nlevels(d$Vuosi)]
Vanhin<-levels(d$Vuosi)[1]

print("Toimiala-aineisto haettu")

#Siivotaan ruotsinkieliset osat nimistä pois, koska kuntakoodi-aineistossa vain suomenkieliset kuntanimet

for(i in 1:nlevels(d$Alue)){
  levels(d$Alue)[i]<-sapply(strsplit(as.character(levels(d$Alue)[i]), " "), function (x) x[[1]])
}

# kuntakoodit sisältävä aineisto
mydata <- get_pxweb_data(url = "http://pxwebapi2.stat.fi/PXWeb/api/v1/fi/Kuntien_talous_ja_toiminta/Kunnat/ktt14/080_ktt14_2013_fi.px",
                         dims = list(Alue = c('*'),
                                     Tunnusluku = c('30'),
                                     Vuosi = c('Arvo')),
                         clean = TRUE)

print("Kuntakoodiaineista haettu")

#erotellaan koodit ja kuntanimet
mydata$Kuntakoodi <- sapply(strsplit(as.character(mydata$Alue), " "), function (x) x[[1]])
mydata$Kunta <- sapply(strsplit(as.character(mydata$Alue), " "), function (x) x[[2]])

#poimitaan kunnan nimi ja kuntakoodi karttaesityksiä varten
mergetest <- mydata[,c("Kunta","Kuntakoodi")]

#Liitetään kuntakoodit mukaan aineistoon
d<-merge(d,mergetest,all.x = TRUE, by.x = "Alue", by.y = "Kunta")

#Käytetään vain molempien sukupuolten kokonaismääriä
d<-d[d$Sukupuoli %in% c("Sukupuolet yhteensä"), ]

#Otetaan talteen alkuperäiset otsikot
Alkup_Tala_otsikot <- levels(d$Toimiala)

#Poimitaan vain kirjainkoodit ja nimetään "Toimialat yhteensä" nimelle "Kaikki"

for(i in 1:nlevels(d$Toimiala)){
  levels(d$Toimiala)[i]<-sapply(strsplit(as.character(levels(d$Toimiala)[i]), " "), function (x) x[[1]])
  if(levels(d$Toimiala)[i] == "Toimialat"){
    levels(d$Toimiala)[i] <- "Kaikki"
  }
}

print(levels(d$Toimiala))

# Käsitellään ensi vanhimman tarkasteluvuoden aineisto
dV<-d[d$Vuosi %in% Vanhin, ]

#Yhdistetään halutut koosteet toimialoista
A<-dV[dV$Toimiala %in% c("A"),]
BC<-dV[dV$Toimiala %in% c("B","C"),]
DEF<-dV[dV$Toimiala %in% c("D","E","F"),]
GHUX<-dV[dV$Toimiala %in% c("G","H","I","R","S","T","U","X"),]
JKLM<-dV[dV$Toimiala %in% c("J","K","L","M"),]
NO<-dV[dV$Toimiala %in% c("N","O"),]
P<-dV[dV$Toimiala %in% c("P"),]
Q<-dV[dV$Toimiala %in% c("Q"),]
Kaikki<-dV[dV$Toimiala %in% c("Kaikki"),]

#Summataan yhteen useamman toimialan väkimäärät 
V_A<-aggregate(values ~ Alue+Kuntakoodi,A,sum)
V_BC<-aggregate(values ~ Alue+Kuntakoodi,BC,sum)
V_DEF<-aggregate(values ~ Alue+Kuntakoodi,DEF,sum)
V_GHUX<-aggregate(values ~ Alue+Kuntakoodi,GHUX,sum)
V_JKLM<-aggregate(values ~ Alue+Kuntakoodi,JKLM,sum)
V_NO<-aggregate(values ~ Alue+Kuntakoodi,NO,sum)
V_P<-aggregate(values ~ Alue+Kuntakoodi,P,sum)
V_Q<-aggregate(values ~ Alue+Kuntakoodi,Q,sum)
V_Kaikki<-aggregate(values ~ Alue+Kuntakoodi,Kaikki,sum)

Toimialamuutos<-V_A

# kerätään vain data
Toimialamuutos$V_A<-V_A$values
Toimialamuutos$V_BC<-V_BC$values
Toimialamuutos$V_DEF<-V_DEF$values
Toimialamuutos$V_GHUX<-V_GHUX$values
Toimialamuutos$V_JKLM<-V_JKLM$values
Toimialamuutos$V_NO<-V_NO$values
Toimialamuutos$V_P<-V_P$values
Toimialamuutos$V_Q<-V_Q$values
Toimialamuutos$V_Kaikki<-V_Kaikki$values


# Käsitellään tuoreimman tarkasteluvuoden aineisto
dT<-d[d$Vuosi %in% Tuorein, ]

#Poimitaan halutut koosteet toimialoista
A<-dT[dT$Toimiala %in% c("A"),]
BC<-dT[dT$Toimiala %in% c("B","C"),]
DEF<-dT[dT$Toimiala %in% c("D","E","F"),]
GHUX<-dT[dT$Toimiala %in% c("G","H","I","R","S","T","U","X"),]
JKLM<-dT[dT$Toimiala %in% c("J","K","L","M"),]
NO<-dT[dT$Toimiala %in% c("N","O"),]
P<-dT[dT$Toimiala %in% c("P"),]
Q<-dT[dT$Toimiala %in% c("Q"),]
Kaikki<-dT[dT$Toimiala %in% c("Kaikki"),]

#Summataan yhteen useamman toimialan väkimäärät 
T_A<-aggregate(values ~ Alue+Kuntakoodi,A,sum)
T_BC<-aggregate(values ~ Alue+Kuntakoodi,BC,sum)
T_DEF<-aggregate(values ~ Alue+Kuntakoodi,DEF,sum)
T_GHUX<-aggregate(values ~ Alue+Kuntakoodi,GHUX,sum)
T_JKLM<-aggregate(values ~ Alue+Kuntakoodi,JKLM,sum)
T_NO<-aggregate(values ~ Alue+Kuntakoodi,NO,sum)
T_P<-aggregate(values ~ Alue+Kuntakoodi,P,sum)
T_Q<-aggregate(values ~ Alue+Kuntakoodi,Q,sum)
T_Kaikki<-aggregate(values ~ Alue+Kuntakoodi,Kaikki,sum)

# kerätään vain data

Toimialamuutos$T_A<-T_A$values
Toimialamuutos$T_BC<-T_BC$values
Toimialamuutos$T_DEF<-T_DEF$values
Toimialamuutos$T_GHUX<-T_GHUX$values
Toimialamuutos$T_JKLM<-T_JKLM$values
Toimialamuutos$T_NO<-T_NO$values
Toimialamuutos$T_P<-T_P$values
Toimialamuutos$T_Q<-T_Q$values
Toimialamuutos$T_Kaikki<-T_Kaikki$values

# Muutosprosenttien laskenta

Toimialamuutos$VP_A<-100*Toimialamuutos$V_A/Toimialamuutos$V_Kaikki
Toimialamuutos$VP_BC<-100*Toimialamuutos$V_BC/Toimialamuutos$V_Kaikki
Toimialamuutos$VP_DEF<-100*Toimialamuutos$V_DEF/Toimialamuutos$V_Kaikki
Toimialamuutos$VP_GHUX<-100*Toimialamuutos$V_GHUX/Toimialamuutos$V_Kaikki
Toimialamuutos$VP_JKLM<-100*Toimialamuutos$V_JKLM/Toimialamuutos$V_Kaikki
Toimialamuutos$VP_NO<-100*Toimialamuutos$V_NO/Toimialamuutos$V_Kaikki
Toimialamuutos$VP_P<-100*Toimialamuutos$V_P/Toimialamuutos$V_Kaikki
Toimialamuutos$VP_Q<-100*Toimialamuutos$V_Q/Toimialamuutos$V_Kaikki

Toimialamuutos$TP_A<-100*Toimialamuutos$T_A/Toimialamuutos$T_Kaikki
Toimialamuutos$TP_BC<-100*Toimialamuutos$T_BC/Toimialamuutos$T_Kaikki
Toimialamuutos$TP_DEF<-100*Toimialamuutos$T_DEF/Toimialamuutos$T_Kaikki
Toimialamuutos$TP_GHUX<-100*Toimialamuutos$T_GHUX/Toimialamuutos$T_Kaikki
Toimialamuutos$TP_JKLM<-100*Toimialamuutos$T_JKLM/Toimialamuutos$T_Kaikki
Toimialamuutos$TP_NO<-100*Toimialamuutos$T_NO/Toimialamuutos$T_Kaikki
Toimialamuutos$TP_P<-100*Toimialamuutos$T_P/Toimialamuutos$T_Kaikki
Toimialamuutos$TP_Q<-100*Toimialamuutos$T_Q/Toimialamuutos$T_Kaikki

# Muutosprosenttien erotus

Toimialamuutos$M_A<-Toimialamuutos$TP_A-Toimialamuutos$VP_A
Toimialamuutos$M_BC<-Toimialamuutos$TP_BC-Toimialamuutos$VP_BC
Toimialamuutos$M_DEF<-Toimialamuutos$TP_DEF-Toimialamuutos$VP_DEF
Toimialamuutos$M_GHUX<-Toimialamuutos$TP_GHUX-Toimialamuutos$VP_GHUX
Toimialamuutos$M_JKLM<-Toimialamuutos$TP_JKLM-Toimialamuutos$VP_JKLM
Toimialamuutos$M_NO<-Toimialamuutos$TP_NO-Toimialamuutos$VP_NO
Toimialamuutos$M_P<-Toimialamuutos$TP_P-Toimialamuutos$VP_P
Toimialamuutos$M_Q<-Toimialamuutos$TP_Q-Toimialamuutos$VP_Q


# Haetaan kartta
sp <- get_municipality_map("MML")

print("Kartta haettu")

sp2 <- sp::merge(sp, Toimialamuutos, all.x = TRUE, by.x = "kuntakoodi", by.y="Kuntakoodi")



# Rinnakkaiskoordinaatistoaineisto

# Asetetaan muutosdatalle alustavat minimi- ja maksimiarvot sekä sarakeotsiko
parcoorddata <- data.frame(-5,-5,-5,-5,-5,-5,-5,-5)
row.names(parcoorddata)<-c("mindata")
colnames(parcoorddata)<-(toimialakoodit)

maxdata<-c()
for(i in 1:length(parcoorddata)){
  maxdata<-c(maxdata,5)
}
parcoorddata[c("maxdata"),] <- maxdata

# Asetetaan vanhimman ja tuoreimman aineiston alustavat minimi- ja maksimiarvot
vpmin<-0
vpmax<-45
tpmin<-0
tpmax<-40

vpmindata<-c()
vpmaxdata<-c()
tpmindata<-c()
tpmaxdata<-c()

for(i in 1:length(parcoorddata)){
  vpmindata<-c(vpmindata,vpmin)
  vpmaxdata<-c(vpmaxdata,vpmax)
  tpmindata<-c(tpmindata,tpmin)
  tpmaxdata<-c(tpmaxdata,tpmax)
}

vparcoorddata<-parcoorddata
colnames(vparcoorddata)<-(vptoimialakoodit)
vparcoorddata[c("mindata"),]<-vpmindata
vparcoorddata[c("maxdata"),]<-vpmaxdata
tparcoorddata<-parcoorddata
colnames(tparcoorddata)<-(tptoimialakoodit)
tparcoorddata[c("mindata"),]<-tpmindata
tparcoorddata[c("maxdata"),]<-tpmaxdata

legendtext = c("min","max")
tcol <- c("black","black")

# Koko maan muutosprosentit 

parcoorddata[c("Koko"),]<-Toimialamuutos[Toimialamuutos$Alue %in% c("Koko"), toimialakoodit]
vparcoorddata[c("Koko"),]<-Toimialamuutos[Toimialamuutos$Alue %in% c("Koko"), vptoimialakoodit]
tparcoorddata[c("Koko"),]<-Toimialamuutos[Toimialamuutos$Alue %in% c("Koko"), tptoimialakoodit]

tcol<-c(tcol,"black")
legendtext<- c(legendtext,"Koko maa")

# suuraluevärit, käytetään ColorBrewerin luokitteluun tarkoitettua värikarttaa
sacolors<-brewer.pal(8,"Set2")

# min, max ja koko maa sekä suuralueet yhtenäisellä viivalla
lty<-c(1,1,1)

# Suuralueet eli sp2$AVI on koodi ja AVI.FI alueviraston nimi
# mahd na:t pois
# lasketaan suuralueiden prosentit henkilömäärien mukaan.

for(i in 1:nlevels(sp2$AVI)){
  vsum<-colSums(sp2@data[sp2$AVI %in% i, vtoimialakoodit],na.rm = TRUE)
  tsum<-colSums(sp2@data[sp2$AVI %in% i, ttoimialakoodit],na.rm = TRUE)
  vp<-100*vsum/sum(vsum)
  tp<-100*tsum/sum(tsum)
  
  parcoorddata[sp2@data[sp2$AVI %in% i, "AVI.FI"][1],]<-tp-vp
  vparcoorddata[sp2@data[sp2$AVI %in% i, "AVI.FI"][1],]<-vp
  tparcoorddata[sp2@data[sp2$AVI %in% i, "AVI.FI"][1],]<-tp
  legendtext<- c(legendtext,sp2@data[sp2$AVI %in% i, "AVI.FI"][1])  
  tcol<-c(tcol,sacolors[i])
  lty<-c(lty,1)
}

# kuntavärit, käytetään ColorBrewerin luokitteluun tarkoitettua värikarttaa 

kcolors<-brewer.pal(12,"Paired")

kuntalista<-levels(Toimialamuutos$Alue)

shinyServer(
  function(input, output) {
    
# Tee kuntavalinta käyttöliittymä
    
    output$Kunnat<-renderUI({
      selectInput("Kuntalista","Kuntavalinta", kuntalista, multiple = TRUE, selected = "Akaa")
      })

# piirretään ensimmäinen kartta
        
    output$Kartta1 <- renderPlot({

            
      ramparg <- switch (input$Värikartta, "1" = brewer.pal(11,"Spectral"),
                         "2" = brewer.pal(11,"RdYlGn"),
                         "3" = brewer.pal(11, "RdYlBu"),
                         "4" = brewer.pal(11,  "RdGy"),
                         "5" = brewer.pal(11,  "RdBu"),
                         "6" = brewer.pal(11,  "PuOr"),
                         "7" = brewer.pal(11,  "PRGn"),
                         "8" = brewer.pal(11,  "PiYG"),
                         "9" = brewer.pal(11,  "BrBG"),
                         "10" = brewer.pal(9,  "YlOrRd"),
                         "11" = brewer.pal(9,  "YlGn"),
                         "12" = brewer.pal(9,  "Greys"),
                         "13" = brewer.pal(9,  "PuBuGn")
      )
      palette_test<-colorRampPalette(ramparg, space = "Lab")
      set_col_regions(palette_test(21))
      
      
      colvar1<-switch (input$Aineisto, "1" = toimialakoodit[as.numeric(input$Kartta1)],
                       "2" = vptoimialakoodit[as.numeric(input$Kartta1)],
                       "3" = tptoimialakoodit[as.numeric(input$Kartta1)])
      
      ncuts<-input$cut1
  
      otsikko <- c(colvar1)

      spplot(sp2,zcol=colvar1, colorkey = TRUE, cuts = ncuts, main = otsikko)
     
    })

# toinen kartta    
    
    output$Kartta2 <- renderPlot({
      
      ramparg <- switch (input$Värikartta, "1" = brewer.pal(11,"Spectral"),
                         "2" = brewer.pal(11,"RdYlGn"),
                         "3" = brewer.pal(11, "RdYlBu"),
                         "4" = brewer.pal(11,  "RdGy"),
                         "5" = brewer.pal(11,  "RdBu"),
                         "6" = brewer.pal(11,  "PuOr"),
                         "7" = brewer.pal(11,  "PRGn"),
                         "8" = brewer.pal(11,  "PiYG"),
                         "9" = brewer.pal(11,  "BrBG"),
                         "10" = brewer.pal(9,  "YlOrRd"),
                         "11" = brewer.pal(9,  "YlGn"),
                         "12" = brewer.pal(9,  "Greys"),
                         "13" = brewer.pal(9,  "PuBuGn")
      )
      palette_test<-colorRampPalette(ramparg, space = "Lab")
      set_col_regions(palette_test(21))
      
      
      colvar2<-switch (input$Aineisto, "1" = toimialakoodit[as.numeric(input$Kartta2)],
                       "2" = vptoimialakoodit[as.numeric(input$Kartta2)],
                       "3" = tptoimialakoodit[as.numeric(input$Kartta2)])
      ncuts<-input$cut1
      
      print(c("kakkoskartta ",colvar2))
      otsikko <- c(colvar2)
      
      spplot(sp2,zcol=colvar2, colorkey = TRUE, cuts=ncuts, main = otsikko)
    })

# ja kolmas    
        
    output$Kartta3 <- renderPlot({
      ramparg <- switch (input$Värikartta, "1" = brewer.pal(11,"Spectral"),
                         "2" = brewer.pal(11,"RdYlGn"),
                         "3" = brewer.pal(11, "RdYlBu"),
                         "4" = brewer.pal(11,  "RdGy"),
                         "5" = brewer.pal(11,  "RdBu"),
                         "6" = brewer.pal(11,  "PuOr"),
                         "7" = brewer.pal(11,  "PRGn"),
                         "8" = brewer.pal(11,  "PiYG"),
                         "9" = brewer.pal(11,  "BrBG"),
                         "10" = brewer.pal(9,  "YlOrRd"),
                         "11" = brewer.pal(9,  "YlGn"),
                         "12" = brewer.pal(9,  "Greys"),
                         "13" = brewer.pal(9,  "PuBuGn")
      )
      palette_test<-colorRampPalette(ramparg, space = "Lab")
      set_col_regions(palette_test(21))
      
      
      colvar3<-switch (input$Aineisto, "1" = toimialakoodit[as.numeric(input$Kartta3)],
                       "2" = vptoimialakoodit[as.numeric(input$Kartta3)],
                       "3" = tptoimialakoodit[as.numeric(input$Kartta3)])
      ncuts<-input$cut1
      
      otsikko <- c(colvar3)
      
      spplot(sp2,zcol=colvar3, colorkey = TRUE, cuts=ncuts, main = otsikko)      
   })

# Interaktiivisen kartan alustus    
        
    output$Interaktiivinen<-renderLeaflet({

# poimitaan valintojen mukaiset datat aineistoista      
            
      region <-"Alue"
      color<-switch (input$Aineisto, "1" = toimialakoodit[as.numeric(input$Kartta1)],
                     "2" = vptoimialakoodit[as.numeric(input$Kartta1)],
                     "3" = tptoimialakoodit[as.numeric(input$Kartta1)])
      value2<-switch (input$Aineisto, "1" = toimialakoodit[as.numeric(input$Kartta2)],
                      "2" = vptoimialakoodit[as.numeric(input$Kartta2)],
                      "3" = tptoimialakoodit[as.numeric(input$Kartta2)])
      value3<-switch (input$Aineisto, "1" = toimialakoodit[as.numeric(input$Kartta3)],
                      "2" = vptoimialakoodit[as.numeric(input$Kartta3)],
                      "3" = tptoimialakoodit[as.numeric(input$Kartta3)])
      value1<-color
  
      ramparg <- switch (input$Värikartta, "1" = brewer.pal(11,"Spectral"),
                         "2" = brewer.pal(11,"RdYlGn"),
                         "3" = brewer.pal(11, "RdYlBu"),
                         "4" = brewer.pal(11,  "RdGy"),
                         "5" = brewer.pal(11,  "RdBu"),
                         "6" = brewer.pal(11,  "PuOr"),
                         "7" = brewer.pal(11,  "PRGn"),
                         "8" = brewer.pal(11,  "PiYG"),
                         "9" = brewer.pal(11,  "BrBG"),
                         "10" = brewer.pal(9,  "YlOrRd"),
                         "11" = brewer.pal(9,  "YlGn"),
                         "12" = brewer.pal(9,  "Greys"),
                         "13" = brewer.pal(9,  "PuBuGn")
      )
          
      palette<-colorNumeric(ramparg, NULL)
          
      state_popup <- paste0("<strong>Kunta: </strong>", sp2[[region]],
                            "<br><strong>", value1, ": </strong>",
                            round(sp2@data[,c(value1)], digits=2),
                            "<br><strong>", value2, ": </strong>",
                            round(sp2@data[,c(value2)], digits=2),
                            "<br><strong>", value3, ": </strong>",
                            round(sp2@data[,c(value3)], digits=2))

      leaflet(data = sp2) %>%
        addTiles() %>%
        addPolygons(fillColor = ~palette(get(color)),
                    fillOpacity = 0.5,
                    color = "#000000",
                    weight = 1,
                    popup = state_popup)
      
      
      
    })

# Rinnakkaiskoordinaatisto esitys valitusta aineistosta, suuralueet, koko maa ja valitut kunnat    
# Oikealle suuralueiden legend, vasemmalle vertailtavien kuntien    
        
    output$Profiilit <- renderPlot({
      
      print("Rinnakkaiset aloitettu")
      pdata<-parcoorddata
      vpdata<-vparcoorddata
      tpdata<-tparcoorddata
      lt<-lty
      legendtext2<-legendtext[1:2]
      tcol3<-tcol
      tcol2<-c("black","black")
      for(i in 1:length(input$Kuntalista)){
        pdata[input$Kuntalista[i],]<-Toimialamuutos[Toimialamuutos$Alue %in% input$Kuntalista[i], toimialakoodit]
        vpdata[input$Kuntalista[i],]<-Toimialamuutos[Toimialamuutos$Alue %in% input$Kuntalista[i], vptoimialakoodit]
        tpdata[input$Kuntalista[i],]<-Toimialamuutos[Toimialamuutos$Alue %in% input$Kuntalista[i], tptoimialakoodit]
        legendtext2<-c(legendtext2,input$Kuntalista[i])
        lt<-c(lt,2)
        tcol2<-c(tcol2,kcolors[i])
        tcol3<-c(tcol3,kcolors[i])
      }

# päivitetään asteikon minimi ja maksimi
      
      mindata = input$Minimi
      for(i in 2:length(parcoorddata)){
        mindata = c(mindata,input$Minimi)
      }
      
      pdata[c("mindata"),]<-mindata
      vpdata[c("mindata"),]<-mindata
      tpdata[c("mindata"),]<-mindata
      
      maxdata = input$Maksimi
      for(i in 2:length(parcoorddata)){
        maxdata = c(maxdata,input$Maksimi)
      }
      
      pdata[c("maxdata"),] <- maxdata
      vpdata[c("maxdata"),] <- maxdata
      tpdata[c("maxdata"),] <- maxdata

# debuggaus tulostuksia      
#      print("Rinn alustukset ohitettu")
#      print(c(tcol,tcol2,tcol3))
#      print(pdata)
#      print(parcoorddata)

# sallitaan plotin ulkopuolelle piirto ja muutetaan marginaaleja (bottom,left,top,right)            
      par(mar=c(12,4,4,2),xpd=TRUE)

# valitaan oikea piirrettävä aineisto
      
      plotdata<-switch (input$Aineisto, "1" = pdata,
                     "2" = vpdata,
                     "3" = tpdata)
      
      partitle<-switch (input$Aineisto, "1" = c("Toimialakohtainen muutos 2007 - 2012"),
                        "2" = c("Toimialojen osuus prosentteina 2007"),
                        "3" = c("Toimialojen osuus prosentteina 2012")
                        )
      
            
      parcoord(plotdata, col=tcol3, lwd=4, lty= lt, main = partitle, var.label=TRUE)

      print(c(input$Kuntalista," str output: ",str(input$Kuntalista),mode(input$Kuntalista),input$Kuntalista[1],
              length(input$Kuntalista)))
      
# suuralueiden värit      
      legend("bottomright",inset=c(0,-1.0), legend=legendtext[3:length(tcol)], fill=tcol[3:length(tcol)])

# kuntien värit            
      legend("bottomleft",inset=c(0,-1.0), legend=legendtext2[3:length(tcol2)], fill=tcol2[3:length(tcol2)],lty = lt[length(tcol)+1:length(tcol3)])
      
    })
    
# päivitetään liu'ut esitettävän aineiston mukaan
    
        output$Minimi<-renderUI({
          
          slvalue<-switch (input$Aineisto, 
                           "1" = -5, "2" = vpmin, "3" = tpmin
                           )
      
          slmin<-switch (input$Aineisto, 
                         "1" = -20, "2" = 0, "3" = 0
                         )
          
          slmax<-switch (input$Aineisto, 
                       "1" = 0, "2" = 50, "3" = 50
                       )
      
          sliderInput("Minimi",label = h5("Minimi"), min = slmin, max = slmax, value = slvalue, step = 1)
    
          })
      
        output$Maksimi<-renderUI({
          
          slvalue<-switch (input$Aineisto, 
                           "1" = 5, "2" = vpmax, "3" = tpmax
                           )
      
          slmin<-switch (input$Aineisto, 
                         "1" = 0, "2" = 0, "3" = 0
                         )
      
          slmax<-switch (input$Aineisto, 
                         "1" = 20, "2" = 60, "3" = 60
                         )
          
          sliderInput("Maksimi",label = h5("Maksimi"), min = slmin, max = slmax, value = slvalue, step = 1)
          
          })
  }
)



                      
                      
