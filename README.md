# Toimialakehitys

Visual data exploration of national economic activities. 

This repository includes currently ongoing project, which has two goals. First one is to explore and understand the current status and
underlying trends in national economic activities in different levels. Second one is to develop this tool further for this task. This tool is for internal use for small group of researchers.

The user interface and material are in finnish and explained more in detail in finnish in file "Tilanne ja tavoitteet"

In current version, I have combined open data available from Statistics Finland and National Land Survey of Finland. The tool has one 
interactive map, three static maps, and parallel coordinates visualization. Map visualizations are based on work presented in http://louhos.github.io/news/2015/06/06/kuntakartat/

The user interface development is actively ongoing project. 

To run in Rstudio you need shiny. If you haven't it installed, then simply give commands: 

install.packages(shiny)

library(shiny) 

and then finally 

runGitHub("Toimialakehitys","mgrohn")

