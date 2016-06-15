# Toimialakehitys

Visual data exploration of national economic activities. 

This repository includes project, which main goal is to explore and understand the current status and
underlying trends in national economic activities in different levels. I developed this tool for professional cooperative Polkuverkosto.

The user interface and material are in finnish and explained more in detail in finnish in file "Tilanne ja tavoitteet"

In current version, I have combined open data available from Statistics Finland and National Land Survey of Finland. The tool has one 
interactive map, three static maps, and parallel coordinates visualization. Map visualizations are based on work presented in http://louhos.github.io/news/2015/06/06/kuntakartat/

To run in Rstudio you need package shiny. If you haven't it installed, then simply give commands: 
```
install.packages(shiny)
library(shiny) 
```
In addition, you have to check situation of following packages: sorvi, pxweb, gisfin, RColorBrewer, leaflet, MASS and plyr. 

After you have all the packages installed, you give command:

```
runGitHub("Toimialakehitys","mgrohn")
```
and enjoy the experience B-). 
